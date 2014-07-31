CREATE view vPriceGToWine as
	select z.priceGN, y.wineN, x.activeVinn, x.wineNameN
		from priceGToSeller z
			join (select retailerN, wineN
						from erpSearchD..forSaleDetail
						group by retailerN, wineN
						) y
				on y.retailerN = z.sellerN
			join wine x
				on x.wineN = y.wineN
			group by z.priceGN, y.wineN, x.activeVinn, x.wineNameN
