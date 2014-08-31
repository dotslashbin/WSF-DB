-- old [=]
CREATE view z_vWine
AS
SELECT  price.priceGN, price.includesNotForSaleNow, price.includesAuction, mapPubGToWine.pubGN, wine.wineN, wine.wineNameN, 
               wineName.encodedKeyWords, wineName.producer, wineName.producerProfileFile, wineName.producerShow, wineName.producerURL, 
               wineName.labelName, wineName.colorClass, wineName.variety, wineName.country, wineName.region, wineName.location, 
               wineName.locale, wineName.site, wineName.dryness, wineName.wineType, wineName.places, price.mostRecentPriceHi, 
               price.mostRecentPriceCnt, wine.vintage, price.mostRecentPriceLo, wine.activeVinn
	from mapPubGToWine 
		join wine 
			on mapPubGToWine.wineN = wine.wineN 
		join wineName
			on wine.wineNameN = wineName.wineNameN
		join price 
			on wine.wineN = price.wineN
	where (wine.isInactive = 0)
		and(wineName.isInactive = 0)
