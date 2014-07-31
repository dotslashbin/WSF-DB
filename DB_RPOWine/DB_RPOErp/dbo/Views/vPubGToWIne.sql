-- database update utility view         [=]
CREATE view vPubGToWIne as
		select pubGN, wineN
			from pubGToPub a
				join tasting b
					on a.pubN = b.pubN
			group by a.pubGN, b.wineN
 
