/*
use erp 
 
calcMyWinesTotals_dev1003Mar09 20, 29481
 
select * from vcount where whn=19
select * from whToWine where whn=19
select * from tasting where tastern=20
*/
CREATE proc [dbo].calcMyWinesTotals_dev1003Mar09b (@whN int, @wineN int)
as begin
--*/
--declare @whN int = 20, @wineN int = 29481
--declare @whN int = 19, @wineN int = 69797
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
,o as (select wineN
			, isNull(sum(bottleCountAvailable), 0) calcCellaredBottleCount 
			, max(case when deliveryDate <= @today then deliveryDate else null end) mostRecentDeliveryDate
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
,d as (select da.whN, da.wineN
		, isNull(a.calcTastingCount, 0)calcTastingCount
		, c.toBeDeliveredBottleCount
		, c.consumedBottleCount
		, (c.remainingBottleCount + c.toBeDeliveredBottleCount) effectiveBottleCount
		, isNull(p.calcPurchaseCount,0) calcPurchaseCount
		, (c.remainingBottleCount - calcCellaredBottleCount) notYetCellaredBottleCount
		, o.mostRecentDeliveryDate
		from whToWine da
			left join a on
				da.wineN = a.wineN
			left join c on
				da.wineN = c.wineN
			left join p
				on da.wineN = p.wineN
			left join o
				on da.wineN = o.wineN
		where da.whN = @whN
			and (da.wineN = @wineN or @wineN is Null)     )
--/*
update e set
		e.tastingCount = isNull(d.calcTastingCount, 0)
		,e.purchaseCount = isNull( d.calcPurchaseCount, 0)
		,e.bottleCount = isNull( d.effectiveBottleCount, 0)
		,e.toBeDeliveredBottleCount = isNull( d.toBeDeliveredBottleCount, 0)
		,e.notYetCellaredBottleCount = isNull( d.notYetCellaredBottleCount, 0)
		,e.consumedCount = isNull(d.consumedBottleCount, 0)
		,e.mostRecentDeliveryDate = d.mostRecentDeliveryDate
--*/
--select e.bottleCount, d.effectiveBottleCount, isNull( d.effectiveBottleCount, 0)
	from whToWine e
		left join  d
			on e.wineN = d.wineN
	where e.whN = @whN
		--and (d.wineN = e.wineN or @wineN is Null)	--Mar 04
		and (e.wineN = @wineN or @wineN is Null)	--Mar 08
		and  (e.tastingCount <> d.calcTastingCount
				or not(e.tastingCount is null and d.calcTastingCount is null)
			or e.purchaseCount  <>  d.calcPurchaseCount
				or not(e.purchaseCount is null and d.calcPurchaseCount is null)
			or e.bottleCount  <>  d.effectiveBottleCount
				or not(e.bottleCount is null and d.effectiveBottleCount is null)
			or e.toBeDeliveredBottleCount  <>  d.toBeDeliveredBottleCount
				or not(e.toBeDeliveredBottleCount is null and d.toBeDeliveredBottleCount is null)
			or e.notYetCellaredBottleCount  <>  d.notYetCellaredBottleCount
				or not(e.notYetCellaredBottleCount is null and d.notYetCellaredBottleCount is null)
			or e.consumedCount  <>  d.consumedBottleCount
				or not(e.consumedCount is null and d.consumedBottleCount is null)
			or e.mostRecentDeliveryDate <> d.mostRecentDeliveryDate
				or not (e.mostRecentDeliveryDate is null and d.mostRecentDeliveryDate is null)
			)
 
 end 