-- database PubG tasting update utility view         [=]
CREATE view vPubGTasting as
	select a.pubGN, b.*
		from
			mapPubGToWine a
				left join tasting b
					on a.wineN = b.wineN
				where b.pubN in (select pubN from pubGToPub where pubGN = a.pubGN)


