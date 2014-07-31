--use erp
create proc summarizeBottleValuation_before1001Jan11 (@whN int, @wineN int = null, @priceGN int = null) as
begin

set noCount on
--summarizeBottleValuation 20, null, null
--select wineN, valuation from whTowine where whN=19
--
--declare @whN int = 19, @wineN int = null, @priceGN int = null
if @priceGN is null set @priceGN = 18220;
with
a as (select purchaseN, sum(bottleCountHere) purchaseBottleCnt 
	from location
	where whN = @whN and isBottle = 1
		group by purchaseN)
,b as (select wineN, bottleSizeN, sum(purchaseBottleCnt) sizeBottleCnt
	from a
		join purchase b
			on a.purchaseN = b.purchaseN
	group by wineN, bottleSizeN)
,c as (select wineN, sum(litres * sizeBottleCnt / 0.75) effectiveBottles
	from b
		join bottleSize d
			on b.bottleSizeN = d.bottleSizeN
	group by wineN)
,g as (select c.wineN, c.effectiveBottles, isNull(e.mostRecentPriceLo, f.estimatedCostLo) pricePerBottle
	from c
		join wine f
			on f.wineN = c.wineN
		join price e
			on c.wineN = e.wineN
		where 
			e.priceGN = @priceGN
			and e.includesNotForSaleNow = 1
			and e.includesAuction = 1)
,h as (select g.wineN, convert(int, (g.effectiveBottles* g.pricePerBottle)) valuation
	from g)
--select h.*, j.*
update j
	set j.valuation = h.valuation
	from whToWine j
		join h
			on j.wineN = h.wineN
	where j.whN = @whN and (@wineN is null or j.wineN = @wineN) 
		and isNull(j.valuation,-1) <> isNull(h.valuation, -1)





end