/*
summarizeBottleValuation_after1003Mar06 20, null, null

select * from price where wineN=26404
*/

CREATE proc summarizeBottleValuation_after1003Mar06 (@whN int, @wineN int = null, @priceGN int = null) as
begin
 
set noCount on
--declare @whN int=20, @wineN int=45668, @priceGN int = null
--declare @whN int=20, @wineN int=45668, @priceGN int = null
--declare @whN int=20, @wineN int=null, @priceGN int = null
if @priceGN is null set @priceGN = 18220;
with
pa as (select whN, wineN, bottleSizeN, pricePerBottle, row_number() over (partition by wineN order by purchaseDate desc) ii
	from purchase
	--where whN = @whN and (@wineN is null or wineN = @wineN) and pricePerBottle > 0)
	where whN = @whN and (@wineN is null or wineN = @wineN))
,pp as (select whN, wineN, case when pricePerBottle > 0 then convert(float, pricePerBottle / (litres / .75)) else null end priceFromPurchase
	from pa
		join bottleSize pb
			on pb.bottleSIzeN = pa.bottleSizeN
	where ii=1)
,b as (select whN, wineN, bottleSizeN, sum(bottleCount) sizeBottleCnt
	from purchase b
	where whN = @whN and (@wineN is null or b.wineN =@wineN)
	group by whN, wineN, bottleSizeN)
,c as (select whN, wineN, sum(litres * sizeBottleCnt / 0.75) effectiveBottles
	from b
		join bottleSize d
			on b.bottleSizeN = d.bottleSizeN
	group by whN, wineN)
,g as (select c.wineN, c.effectiveBottles
	--,  isNull(e.mostRecentPriceLo, isNull(pp.priceFromPurchase,f.estimatedCostLo)) pricePerBottleLo
	--,  isNull(e.mostRecentPriceHi, isNull(pp.priceFromPurchase,f.estimatedCostHi)) pricePerBottleHi
	,  isNull(e.mostRecentPriceLo, pp.priceFromPurchase) pricePerBottleLo
	,  isNull(e.mostRecentPriceHi, pp.priceFromPurchase) pricePerBottleHi
	from c
		join wine f
			on f.wineN = c.wineN
		left join price e
			on e.wineN = c.wineN and e.priceGN = @priceGN and e.includesNotForSaleNow = 1 and e.includesAuction = 0
		join pp
			on pp.wineN = c.wineN) 
,h as (select g.wineN, convert(int, (g.effectiveBottles* (g.pricePerBottleLo + g.pricePerBottleHi)/2.0)) valuation
	from g)
update j
	set j.valuation = h.valuation
	from whToWine j
		join h
			on j.wineN = h.wineN
	where j.whN = @whN and (@wineN is null or j.wineN = @wineN) 
		and isNull(j.valuation,-1) <> isNull(h.valuation, -1);
 
 
 
end
 
 
