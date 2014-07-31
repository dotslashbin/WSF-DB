CREATE proc summarizeBottleLocations_after1001Jan28 (@whN int, @wineN int) as
begin
 
set noCount on 
-----------------------------------------------------------------------------------
-- Code
-----------------------------------------------------------------------------------
/*
use erp
summarizeBottleLocations_after1001Jan28 20, null
select * from purchase where whN = 20
os purchase, 'where whN=20'
summarizeBottleLocationsX 22, null
summarizeBottleLocations 19, null
 
declare @whn int = 20, @wineN int = 84552
 
select wineN, bottleLocations from whToWine where whN=20 and bottleLocations is not null

select b.purchaseN, wineN, bottleCount, bottleCountBought,LocationN,parentLocationN,currentBottleCount,maxBottleCount,bottleCountHere,bottleCountAvailable,locationCapacity
	from location a
		right join purchase b
			on a.whN=b.whN and a.purchaseN=b.purchaseN
	where b.whN=20


*/ 
 
--declare @whn int = 20, @wineN int = null
 
declare @TT table(locationN int, parentLocationN int, prevItemIndex int,name varchar(200), isBottle bit, path varchar(2000), rooted bit, iiPrev int, iiParent int, iiPath varchar(300), depth int, ii int)
 
-----------------------------------------------------------------------------------
-- Get all locations that need numbering
-----------------------------------------------------------------------------------
insert into @TT(locationN, parentLocationN, prevItemIndex, name, isBottle, path, rooted, iiPrev, iiParent, iiPath, depth, ii)
select locationN, parentLocationN,prevItemIndex,name, isBottle,  convert(varchar(max), '') path, convert(bit,0) rooted, -1 iiPrev, -1 iiParent, convert(varchar(max), '')iiPath, 0 depth, 0 ii
	from location
	where whN = @whN and isBottle=0;
	
update a
	set a.rooted = 1
	from @TT a
		join @TT b
			on a.prevItemIndex = b.locationN;
 
with
a as	(select locationN, prevItemIndex, isBottle, rooted, 0 iiPrev
		from @TT
		where rooted = 0
	union all
	select c.locationN, c.prevItemIndex, c.isBottle, c.rooted, p.iiPrev + 1
		from @TT c
			join a p
				on p.locationN = case when c.prevItemIndex < 0 then c.parentLocationN else c.prevItemIndex end 
				--on c.prevItemIndex = p.locationN
	)
update b 
	set b.iiPrev = a.iiPrev
	from @TT b
		join a
			on b.locationN = a.locationN;
			
with 
a as (select row_number() over(partition by parentLocationN order by isBottle desc, iiPrev) ii2, iiParent from @TT)
update a
	set iiParent = ii2;
	
	
-----------------------------------------------------------------------------------
-- Get the path name for all locations with bottles of current wines
-----------------------------------------------------------------------------------
 
declare @padLen int
select @padLen = len(convert(varchar(max), max(iiParent))) from @TT
declare @pad varchar(max) = left('0000000', @padLen - 1);
 
with
a as	(select parentLocationN, locationN, name, convert(varchar(max), isNull(name, '')) path2,	right(@pad + convert(varchar(max), isNull(iiParent, '')),@padLen)iiPath2, 0 depth2
		from @TT
		where parentLocationN < 0
	union all
	--select pc.parentLocationN, pc.locationN, pc.name, pp.path2 + convert(varchar(max), ' ' + pc.name), pp.iiPath2 + right(@pad + convert(varchar(max), isNull(pc.iiParent, '')),@padLen), 1+pp.depth2
	select pc.parentLocationN, pc.locationN, pc.name, pp.path2 + convert(varchar(max), char(11) + pc.name), pp.iiPath2 + right(@pad + convert(varchar(max), isNull(pc.iiParent, '')),@padLen), 1+pp.depth2
		from @TT pc
			join a pp
				on pc.parentLocationN = pp.locationN
	)
update b set b.path = a.path2, b.iiPath = a.iiPath2, b.depth = a.depth2
	from @TT b
		join a
			on a.locationN = b.locationN;
			
 
-----------------------------------------------------------------------------------
-- Update the sequence field ii
-----------------------------------------------------------------------------------
with
a as (select row_number() over(order by iiPath) ii2, * from @TT)
update a set ii = ii2;
	
 
-----------------------------------------------------------------------------------
-- Gather up the bottle sizes for a particular wineN
-----------------------------------------------------------------------------------
--select getDate()
declare @today date = getDate();
with
a as (select pb.litres, pb.nameInSummary, pa.*
	from (select * from purchase where whN = @whN) pa
		join bottleSize pb
			on pa.bottleSizeN = pb.bottleSizeN)
,b as (select wineN, litres, max(nameInSummary) nameInSummary
		, sum(bottleCount) purchaseBottleCount
		, sum (case when deliveryDate is null or deliveryDate <= '1900' or deliveryDate > @today then bottleCount else 0 end) notYetDeliveredBottleCount
		, sum (case when deliveryDate is null or deliveryDate <= '1900' or deliveryDate > @today then 0 else isNull(bottleCount, 0) end) remainingBottleCount
	from a
	group by wineN, litres)
 
,g as (select top 199999 b.wineN, nameInSummary, litres, e.bottleCountAvailable bottleCount, f.path, f.iiPath, f.depth, f.ii
	from a
		join wine b
			on a.wineN = b.wineN
		join location e
			on e.whN = a.whN and e.purchaseN = a.purchaseN
		join @TT f
			on f.locationN = e.parentLocationN
	where e.whN = @whN and (@wineN is null  or a.wineN = @wineN)
	order by wineN, litres desc, ii)
,h as (select top 199999 wineN, litres, max(nameInSummary) nameInSummary, sum(bottleCount) cellarBottleCount, dbo.compactLocationSummary(dbo.concatFF(convert(varchar, ii)+char(12)+path))locs 
	from g
	group by wineN, litres
	order by wineN, litres
	)
,hb as (select isNull(h.wineN, b.wineN) wineN, isNull(h.litres, b.litres) litres
		
		--DEBUG     		, cellarBottleCount, purchaseBottleCount, remainingBottleCount,notYetDeliveredBottleCount --DEBUG
		
		, dbo.getSubSummary(
			isNull(h.nameInSummary, b.nameInSummary)
			,cellarBottleCount
			,purchaseBottleCount
			,remainingBottleCount
			,notYetDeliveredBottleCount
			,locs) subSummary
		from h
			full join b on h.wineN = b.wineN and h.litres = b.litres)
	
--,j as (select top 199999 wineN, (convert(varchar, cellarBottleCount) + ' ' + nameInSummary + case when cellarBottleCount = 1 then '' else 's' end + ' in ' + locs) subSummary 
--	from h litres order by wineN, litres desc)
,j as (select top 199999 wineN, subSummary
	from hb litres order by wineN, litres desc)
,k as (select wineN, RTrim(replace(dbo.concatFF(subSummary),char(12), '
 
')) bottleLocations from j group by wineN)
/*
select * from hb order by wineN
select * from purchase where whN=20 order by wineN
 
wineN	litres	cellar	purchase	remaining	notYetDelivered
29498	0.375	NULL	1		0		1	1 Half Bottle on order
 
purchaseN	whN	wineN	supplierN	bottleSizeN	purchaseDate	deliveryDate	pricePerBottle	bottleCount	notes	createDate	updateDate	bottlesRemaining
3808	20	29498	9	6	2010-01-22	1900-01-01	1	1	NULL	2010-01-22	2010-01-22	NULL
*/ 
update m
		set m.bottleLocations = k.bottleLocations
	from (select wineN, bottleLocations from whToWine where whN = @whN) m
		join k
			on k.wineN = m.wineN
	where isNull(m.bottleLocations, '') <> isNull(k.bottleLocations,'');
--*/
end
 
 
 
 
 
 
 
