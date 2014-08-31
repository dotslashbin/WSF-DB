CREATE proc [dbo].calcMyWinesTotals_before1003Mar03 (@whN int, @wineN int)
as begin
--declare @whN int = 20, @wineN int = null
/*
use erp
oofr tota
ToDo
	Find out why not yet cellared is computing incorrectly
 
 
calcWhToWine 20,null,0
calcMyWinesTotals_after1001Jan31 20, null
select * from location where whN=20
 
calcMyWinesTotals_after1001Jan29 20, 88041
select wineN, bottleLocations, toBeDeliveredBottleCount, toBeDeliveredX, notYetCellaredBottleCount,notYetCellaredX,bottleCount,tastingCount,wantToSellBottleCount,wantToBuyBottleCount,buyerCount,sellerCount,purchaseCount 
	from  whtowine where whn=20
*/ 
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
 
 
 
--declare @whN int = 20, @wineN int = null, @today date = getDate();
with
a as (select wineN, count(*)calcTastingCount from tasting where tasterN = @whN and (wineN = @wineN or @wineN is null) group by wineN)
,o as (select wineN, sum(bottleCountAvailable) calcCellaredBottleCount 
		from location oa
			join purchase ob
				on oa.purchaseN = ob.purchaseN
		where oa.whN=@whN and ob.whN=@whN and (wineN = @wineN or @wineN is null) group by wineN)
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
		--, (remainingBottleCount-isNull(calcCellaredBottleCount,0)) notYetCellaredBottleCount 
		, case when remainingBottleCount > calcCellaredBottleCount then remainingBottleCount - calcCellaredBottleCount else 0 end notYetCellaredBottleCount
		from c
			join p
				on p.wineN = c.wineN
			left join a
				on a.wineN = c.wineN
			left join o
				on o.wineN = c.wineN)
update e set
		e.tastingCount = d.calcTastingCount
		,e.purchaseCount = d.calcPurchaseCount
		,e.bottleCount = d.effectiveBottleCount
		,e.toBeDeliveredBottleCount = d.toBeDeliveredBottleCount
		,e.notYetCellaredBottleCount = d.notYetCellaredBottleCount
		,e.consumedCount = d.consumedBottleCount
	from whToWine e
		join  d
			on e.wineN = d.wineN
	where e.whN = @whN
		and  (isNull(e.tastingCount,0) <> d.calcTastingCount
			or isNull(e.purchaseCount ,0) <> d.calcPurchaseCount
			or isNull(e.bottleCount ,0) <> d.effectiveBottleCount
			or isNull(e.toBeDeliveredBottleCount ,0) <> d.toBeDeliveredBottleCount
			or isNull(e.notYetCellaredBottleCount ,0) <> d.notYetCellaredBottleCount
			or isNull(e.consumedCount ,0) <> d.consumedBottleCount)
 
 
 end 
 
/*
ooi whtowine, coun
 
[calcMyWinesTotals_after10Jan18] 20, null
os whtowine, 'where whn=20'
os purchase,'where whn=20'
select purchaseDate, count(*) cnt from purchase group by purchaseDate order by purchasedATE
select deliveryDate, count(*) cnt from purchase group by deliveryDate order by deliveryDate
 
use erp
ooi ' whtowine ', count
	bottleCount
	tastingCount
	wantToSellBottleCount
	wantToBuyBottleCount
	buyerCount
	sellerCount
	purchaseCount
	toBeDeliveredBottleCount
	notYetCellaredBottleCount
 
os whToWine, 'where whN=20'
*/ 
 
 
 
 
