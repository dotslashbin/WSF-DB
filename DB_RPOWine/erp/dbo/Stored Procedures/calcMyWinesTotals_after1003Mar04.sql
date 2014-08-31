/*
use erp
calcMyWinesTotals_after1003Mar04 20,null

calcMyWinesTotals_after1003Mar04 22,-8502039
calcMyWinesTotals_after1003Mar04 22,null
select * from vCounts where whn=22 and wineN=-8502039

calcMyWinesTotals_after1003Mar04 20, 29478
calcMyWinesTotals_after1003Mar04 20, null
calcwhtowine 20, null, 0
select * from vCount where whN=20

select * from whToWine where whn=20

select * from vcounts where whn=20

*/ 
CREATE proc [dbo].calcMyWinesTotals_after1003Mar04 (@whN int, @wineN int)
as begin
--declare @whN int = 20, @wineN int = null	---29478
set noCount on
declare @today date = getDate()
-- make sure everything has a whToWine record
		
if @wineN is not null
	begin
		if not exists (select * from whToWine where whN = @whN and wineN = @wineN)
			insert into whToWine(whN, wineN) select @whN, @wineN
	end
else
	begin
		insert into whToWine(whN, wineN)
			select @whN, a.wineN
				from (select distinct wineN from tasting where tasterN = @whN and wineN is not null) a
					left join whToWine b
						on a.wineN = b.wineN
					where
						b.wineN is null
 
		insert into whToWine(whN, wineN)
			select @whN, a.wineN
				from (select distinct wineN from purchase where whN = @whN and wineN is not null) a
					left join whToWine b
						on a.wineN = b.wineN
					where
						b.wineN is null
	end;
 
 
 
--declare @whN int = 20, @wineN int = 29477, @today date = getDate();
--declare @whN int = 20, @wineN int = null, @today date = getDate();
with
a as (select wineN, count(*)calcTastingCount from tasting where tasterN = @whN and (wineN = @wineN or @wineN is null) group by wineN)
,o as (select wineN, isNull(sum(bottleCountAvailable), 0) calcCellaredBottleCount 
		from purchase oa
			left join location ob
				on oa.purchaseN = ob.purchaseN and oa.whN = ob.whN
		where oa.whN=@whN and (oa.wineN = @wineN or @wineN is null) group by oa.wineN)
,b as (select *
			, case when deliveryDate is null or deliveryDate <= '1900' or deliveryDate > @today then 1 else 0 end isOnOrder
		from purchase wh
		where whN = @whN and (wineN = @wineN or @wineN is null))
,p as (select wineN, count(*) calcPurchaseCount from b group by wineN)
,c as (select wineN
		, sum(isNull(bottleCountBought,0)) purchaseBottleCount
		, sum (case when isOnOrder=1 then isNull(bottleCountBought,0) else 0 end) toBeDeliveredBottleCount
		, sum (case when isOnOrder=1 then 0 else isNull(bottleCount, 0) end) remainingBottleCount
		, sum (case when isOnOrder=1 then 0 else isNull(bottleCountBought, 0) - isNull(bottleCount,0) end) consumedBottleCount
		from b
		group by b.wineN)
,d as (select c.*
		, (remainingBottleCount + toBeDeliveredBottleCount) effectiveBottleCount
		, isNull(calcTastingCount, 0)calcTastingCount
		, isNull(calcPurchaseCount,0) calcPurchaseCount
		--, case when remainingBottleCount > calcCellaredBottleCount then remainingBottleCount - calcCellaredBottleCount else 0 end notYetCellaredBottleCount
		, (remainingBottleCount - calcCellaredBottleCount) notYetCellaredBottleCount
		from c
			join p
				on p.wineN = c.wineN
			left join a
				on a.wineN = c.wineN
			left join o
				on o.wineN = c.wineN)


--select * from d


update e set
		e.tastingCount = isNull(d.calcTastingCount, 0)
		,e.purchaseCount = isNull( d.calcPurchaseCount, 0)
		,e.bottleCount = isNull( d.effectiveBottleCount, 0)
		,e.toBeDeliveredBottleCount = isNull( d.toBeDeliveredBottleCount, 0)
		,e.notYetCellaredBottleCount = isNull( d.notYetCellaredBottleCount, 0)
		,e.consumedCount = isNull(d.consumedBottleCount, 0)
	from whToWine e
		left join  d
			on e.wineN = d.wineN
	where e.whN = @whN
		and (d.wineN = e.wineN or @wineN is Null)	--Mar 04
		and  (isNull(e.tastingCount,0) <> isNull(d.calcTastingCount,0)
			or isNull(e.purchaseCount ,0) <> isNull( d.calcPurchaseCount,0)
			or isNull(e.bottleCount ,0) <> isNull( d.effectiveBottleCount,0)
			or isNull(e.toBeDeliveredBottleCount ,0) <> isNull( d.toBeDeliveredBottleCount,0)
			or isNull(e.notYetCellaredBottleCount ,0) <> isNull( d.notYetCellaredBottleCount,0)
			or isNull(e.consumedCount ,0) <> isNull( d.consumedBottleCount,0))
 
 
 end 
 
