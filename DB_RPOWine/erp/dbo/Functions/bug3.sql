CREATE function bug3(@whN int, @supplierN int) 
returns @RR table (purchaseN int, bottleLocations varchar(max))
as begin
  
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
--ooi ' bottlesize '
declare @today date = getDate();
with
a as (select pb.litres, pb.nameInSummary shortSizeName, pa.*
		--, case when deliveryDate is null or deliveryDate <= '1900' or deliveryDate > @today then 1 else 0 end isOnOrder
		, case when (deliveryDate is null or deliveryDate < '1901') and deliveryDate > @today then 1 else 0 end isOnOrder
	from (select * from purchase where whN = @whN and (@supplierN is null or supplierN = @supplierN)) pa
		join bottleSize pb
			on pa.bottleSizeN = pb.bottleSizeN)
,b as (select purchaseN, litres, max(shortSizeName) shortSizeName
		, sum(bottleCountBought) purchaseBottleCount
		, sum (case when isOnOrder=1 then isNull(bottleCountBought,0) else 0 end) notYetDeliveredBottleCount
		, sum (case when isOnOrder=1 then 0 else isNull(bottleCount, 0) end) remainingBottleCount
		, sum (case when isOnOrder=1 then 0 else isNull(bottleCountBought, 0) - isNull(bottleCount,0) end) consumedBottleCount
	from a
	group by purchaseN, litres)
,g as (select top 199999 a.purchaseN, litres
		, e.bottleCountAvailable bottleCountAvailable
		, f.path, f.iiPath, f.depth, f.ii
	from a
		--join wine b
		--	on a.wineN = b.wineN
		join location e
			on e.whN = a.whN and e.purchaseN = a.purchaseN
		join @TT f
			on f.locationN = e.parentLocationN
	--where e.whN = @whN and (@wineN is null  or a.wineN = @wineN)
	where e.whN = @whN
	order by purchaseN, litres desc, ii)
,h as (select top 199999 
		  purchaseN
		, litres
		, sum(isNull(bottleCountAvailable,0)) bottleCountAvailable
		, dbo.compactLocationSummary(dbo.concatFF(convert(varchar, ii)+char(12)+path))locs 
	from g
	group by purchaseN, litres
	order by purchaseN, litres
	)
,hb as (select isNull(h.purchaseN, b.purchaseN) purchaseN, isNull(h.litres, b.litres) litres
		, dbo.getSummaryForSize(
			notYetDeliveredBottleCount		--@notDeliveredCount int
			, remainingBottleCount - isNull(bottleCountAvailable, 0) --@notCellaredCount int
			, isNull(bottleCountAvailable, 0)		--@cellarCount int
			, consumedBottleCount--@consumedCount int
			, shortSizeName
			, locs)subSummary		
		from h
			full join b on h.purchaseN = b.purchaseN and h.litres = b.litres)
,j as (select top 199999 purchaseN, subSummary
	from hb litres order by purchaseN, litres desc)
,k as (select purchaseN, RTrim(replace(dbo.concatFF(subSummary),char(12), '
 
')) bottleLocations from j group by purchaseN)
/*
*/ 
--, k2 as (select purchaseN, replace(replace(replace(k.bottleLocations, ',,,,,', ','), ',,,', ','), ',,', ',') bottleLocations
, k2 as (select purchaseN, replace(replace(replace(replace(k.bottleLocations, ',,,,,', ','), ',,,', ','), ',,', ','), ',;',';')     bottleLocations
	from k)
insert into @RR(purchaseN, bottleLocations)
	select purchaseN, bottleLocations from k2
	
return
end
 
 
 
 
 
 
 
 
 
 
 
 
 
