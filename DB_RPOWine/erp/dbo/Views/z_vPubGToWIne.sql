-- database update utility view         [=]
CREATE view [z_vPubGToWIne] as
		select pubGN, wineN
			from mapPubGToTasting
			group by pubGN, wineN
