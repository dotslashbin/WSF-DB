CREATE view vWine as (
	select whN, ProducerShow, LabelName, Vintage, bottleLocations, valuation, a.wineN, a.rowversion
		from whToWine a
			join wine b
				on a.wineN = b.wineN
			join wineName c
				on b.wineNameN = c.wineNameN     )
 
