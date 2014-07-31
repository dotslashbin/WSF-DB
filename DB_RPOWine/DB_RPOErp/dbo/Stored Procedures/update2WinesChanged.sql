CREATE proc [dbo].update2WinesChanged
as begin
--set nocount on;
exec dbo.oolog 'update2WinesChanged begin'; 
with
a as	(
			select
					wineN
					,vinn activeVinn
					,wineNameN
					,vintage
					,estimatedCost_Hi estimatedCostHi 
					,estimatedCost estimatedCostLo
					,encodedKeywords
					,hasErpTasting
					,MostRecentPriceCnt mostRecentPriceLoStd
					,MostRecentPriceHi mostRecentPriceHiStd
					,isCurrentlyForSale
					--,oojoinx joinx
					,joinx
				from vjwine
		)
--select count(*)
--select b.estimatedcostlo,a.estimatedcostlo
update b
		set		
					b.activeVinn=a.activeVinn
					,b.wineNameN=c.wineNameN
					,b.vintage=a.vintage
					,b.estimatedCostHi =a.estimatedCostHi 
					,b.estimatedCostLo=a.estimatedCostLo
					,b.encodedKeywords=a.encodedKeywords
					,b.hasErpTasting=a.hasErpTasting
					,b.mostRecentPriceLoStd=a.mostRecentPriceLoStd
					,b.mostRecentPriceHiStd=a.mostRecentPriceHiStd
					,b.isCurrentlyForSale=a.isCurrentlyForSale
	from a
		join vwineplus b
			on a.wineN=b.wineN
		join wineName c
			on a.joinx=c.joinx
	where
			a.activeVinn<>b.activeVinn or ( a.activeVinn is null and b.activeVinn is not null) or (a.activeVinn is not null and b.activeVinn is null)     --84
			or b.wineNameN<>c.wineNameN or ( b.wineNameN is null and c.wineNameN is not null) or (b.wineNameN is not null and c.wineNameN is null)     --3607
			or a.vintage<>b.vintage or ( a.vintage is null and b.vintage is not null) or (a.vintage is not null and b.vintage is null)
			or a.estimatedCostHi <>b.estimatedCostHi  or ( a.estimatedCostHi is null and b.estimatedCostHi is not null) or (a.estimatedCostHi is not null and b.estimatedCostHi is null)
			or a.estimatedCostLo<>b.estimatedCostLo or ( a.estimatedCostLo is null and b.estimatedCostLo is not null) or (a.estimatedCostLo is not null and b.estimatedCostLo is null)
			--RECALC--or a.encodedKeywords<>b.encodedKeywords or ( a.encodedKeywords is null and b.encodedKeywords is not null) or (a.encodedKeywords is not null and b.encodedKeywords is null)
			--RECALC--or a.hasErpTasting<>b.hasErpTasting or ( a.hasErpTasting is null and b.hasErpTasting is not null) or (a.hasErpTasting is not null and b.hasErpTasting is null)
			or a.mostRecentPriceLoStd<>b.mostRecentPriceLoStd or ( a.mostRecentPriceLoStd is null and b.mostRecentPriceLoStd is not null) or (a.mostRecentPriceLoStd is not null and b.mostRecentPriceLoStd is null)
			or a.mostRecentPriceHiStd<>b.mostRecentPriceHiStd or ( a.mostRecentPriceHiStd is null and b.mostRecentPriceHiStd is not null) or (a.mostRecentPriceHiStd is not null and b.mostRecentPriceHiStd is null)
			or a.isCurrentlyForSale<>b.isCurrentlyForSale or ( a.isCurrentlyForSale is null and b.isCurrentlyForSale is not null) or (a.isCurrentlyForSale is not null and b.isCurrentlyForSale is null)
 
exec dbo.oolog 'update2WinesChanged end'; 
end
 
 
 
