CREATE view z_vWineAny
as
select
	 	 v.wineN vWineN, v.priceGN, v.includesNotForSaleNow, v.includesAuction, z.pubGN
		,z.wineN, y.wineNameN, y.activeVinn
		,y.vintage
		,x.producer, x.producerProfileFile, x.producerShow, x.producerURL
		,x.labelName
		,x.country, x.region, x.location, x.locale, x.site, x.places
		,x.variety, x.colorClass, x.dryness, x.wineType
		,isNull (v.mostRecentPriceLo, y.estimatedCostLo) priceLo
		,isNull (v.mostRecentPriceHi, y.estimatedCostHi) priceHi
		,isNull(v.mostRecentPriceCnt, 0) priceCnt
		,x.encodedKeyWords
	from mapPubGToWine z
		join wine y
			on z.wineN = y.wineN 
		join wineName x
			on y.wineNameN = x.wineNameN
		left join price v
			on z.wineN = v.wineN
	where isNull(v.includesNotForSaleNow,1) = 1
		and (y.isInactive = 0)
		and(x.isInactive = 0)
