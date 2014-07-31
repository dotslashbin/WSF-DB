CREATE view vPurchase as (
	select ProducerShow, LabelName, Vintage, bottleLocations, a.*
		from purchase a
			join wine b
				on a.wineN = b.wineN
			join wineName c
				on b.wineNameN = c.wineNameN
			join whToWine e
				on a.whN = e.whN and a.wineN = e.wineN     )
				
