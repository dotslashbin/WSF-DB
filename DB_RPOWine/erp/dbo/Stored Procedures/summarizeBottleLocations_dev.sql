CREATE proc summarizeBottleLocations_dev (@whN int, @wineN int) as
--ALTER proc summarizeBottleLocations_dev1003Mar13 (@whN int, @wineN int) as
begin
--declare @whn int = 20, @wineN int = null
set noCount on 
 
-----------------------------------------------------------------------------------
-- Code
-----------------------------------------------------------------------------------
 
declare @TT table(locationN int, parentLocationN int, prevItemIndex int,name varchar(200), isBottle bit, path varchar(2000), iiPrev int, iiParent int, iiPath varchar(300), depth int, ii int)
 
-----------------------------------------------------------------------------------
-- Get all locations that need numbering
-----------------------------------------------------------------------------------
insert into @TT(locationN, parentLocationN, prevItemIndex, name, isBottle, path, iiPrev, iiParent, iiPath, depth, ii)
select locationN, parentLocationN,prevItemIndex,name, isBottle,  convert(varchar(max), '') path,  -1 iiPrev, -1 iiParent, convert(varchar(max), '')iiPath, 0 depth, 0 ii
	from location
	where whN = @whN and isBottle=0;
	 
update @TT set iiPrev = case when parentLocationN<0 or prevItemIndex <0 then 0 else -9999 end;
 
with
a as	(select locationN, prevItemIndex, isBottle, 0 iiPrev
		from @TT
		where iiPrev = 0
	union all
	select c.locationN, c.prevItemIndex, c.isBottle, a.iiPrev + 1
		from @TT c
			join a
				on c.prevItemIndex = a.locationN
		where a.iiPrev >= 0 and c.iiPrev < 0
		)
--select * from a
update b set b.iiPrev = a.iiPrev
	from @TT b
		join a
			on a.locationN = b.locationN
		option(maxRecursion 1000)
 
;with 
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
	from (select * from purchase where whN = @whN and (@wineN is Null or wineN=@wineN)) pa
		join bottleSize pb
			on pa.bottleSizeN = pb.bottleSizeN     )
,b as (select wineN, litres, max(shortSizeName) shortSizeName
		, sum(bottleCountBought) purchaseBottleCount
		, sum (case when isOnOrder=1 then isNull(bottleCountBought,0) else 0 end) notYetDeliveredBottleCount
		, sum (case when isOnOrder=1 then 0 else isNull(bottleCount, 0) end) remainingBottleCount
		, sum (case when isOnOrder=1 then 0 else isNull(bottleCountBought, 0) - isNull(bottleCount,0) end) consumedBottleCount
	from a
	group by wineN, litres)
,g as (select top 199999 b.*, litres
		, e.bottleCountAvailable bottleCountAvailable
		, f.path, f.iiPath, f.depth, f.ii
	from a
		join wine b
			on a.wineN = b.wineN
		join location e
			on e.whN = a.whN and e.purchaseN = a.purchaseN
		join @TT f
			on f.locationN = e.parentLocationN
	where e.whN = @whN and (@wineN is null  or a.wineN = @wineN)
	order by wineN, litres desc, ii)
--select wineN,bottleCountAvailable, path,iiPath, depth, ii from g
,h as (select top 199999 
		  wineN
		, litres
		, sum(isNull(bottleCountAvailable,0)) bottleCountAvailable
		, dbo.compactLocationSummary(dbo.concatFF(convert(varchar, ii)+char(12)+path))locs 
	from g
	group by wineN, litres
	order by wineN, litres
	)
,hb as (select isNull(h.wineN, b.wineN) wineN, isNull(h.litres, b.litres) litres
		
		--DEBUG     		, cellarBottleCount, purchaseBottleCount, remainingBottleCount,notYetDeliveredBottleCount --DEBUG
		
		, dbo.getSummaryForSize(
			notYetDeliveredBottleCount		--@notDeliveredCount int
			, remainingBottleCount - isNull(bottleCountAvailable, 0) --@notCellaredCount int
			, isNull(bottleCountAvailable, 0)		--@cellarCount int
			, consumedBottleCount--@consumedCount int
			, shortSizeName
			, locs)subSummary		
		from h
			full join b on h.wineN = b.wineN and h.litres = b.litres     )
,j as (select top 199999 wineN, subSummary
	from hb litres order by wineN, litres desc)
,k as (select wineN, RTrim(replace(dbo.concatFF(subSummary),char(12), '
 
')) bottleLocations from j group by wineN)
, k2 as (select wineN, replace(replace(replace(replace(k.bottleLocations, ',,,,,', ','), ',,,', ','), ',,', ','), ',;',';')     bottleLocations
	from k)
update m
		set m.bottleLocations = k2.bottleLocations
	from (select wineN, bottleLocations from whToWine where whN = @whN) m
		left join k2
			on k2.wineN = m.wineN
	--where isNull(m.bottleLocations, '') <> isNull(k2.bottleLocations,'');
	where 
		(m.wineN = @wineN or @wineN is null)
		and
		(
			m.bottleLocations <> k2.bottleLocations
			or not (m.bottleLocations is null and k2.bottleLocations is null)
		)
end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
