-- larisa search user view [=]
CREATE view z_vWineForSaleNow
as
select
		v.priceGN, v.includesNotForSaleNow, v.includesAuction, z.pubGN, 
		y.wineN, y.wineNameN, y.activeVinn,
		y.vintage, 
		x.producer, x.producerProfileFile, x.producerShow, x.producerURL, 
		x.labelName, 
		x.country, x.region, x.location, x.locale, x.site, x.places, 
		x.variety, x.colorClass, x.dryness, x.wineType, 
		v.mostRecentPriceLo priceLo, 
		v.mostRecentPriceHi priceHi, 
		v.mostRecentPriceCnt priceCnt, 
		x.encodedKeyWords
	from mapPubGToWine z
		join wine y
			on z.wineN = y.wineN 
		join wineName x
			on y.wineNameN = x.wineNameN
		join price v
			on y.wineN = v.wineN
	where v.includesNotForSaleNow = 0
		and (y.isInactive = 0)
		and(x.isInactive = 0)
