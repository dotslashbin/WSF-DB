CREATE view vPrice2 as 
	select
		priceGN
		,wineN
		,wineNameN nameN
		,isForSaleNow live
		,convert(date, mostRecentDate) [date]
		,mostRecentPriceCnt cnt
		,convert(int,mostRecentPriceLo) lo
		,convert(int, mostRecentPriceMedian) median
		,convert(int,mostRecentPriceHi) hi
		,convert(date, createDate) created
		,includesAuction auction
	from vPrice
