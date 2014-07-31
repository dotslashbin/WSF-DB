CREATE view vpriceGToWineName as
	select priceGN, includesNotForSaleNow, includesAuction, wineNameN
		from price z
		group by priceGN, includesNotForSaleNow, includesAuction, wineNameN
