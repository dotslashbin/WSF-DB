CREATE view vPubGToWineName as
	select pubGN, wineNameN
		from mapPubGToWine z
			join wine y
				on z.wineN = y.wineN
		group by pubGN, wineNameN




