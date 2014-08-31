create view vx as (
	select vintage, a.*
	from whToWine a
		join wine b
			on a.wineN = b.wineN)
