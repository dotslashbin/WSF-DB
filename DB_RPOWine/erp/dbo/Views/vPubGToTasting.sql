create view vPubGToTasting as
	select z.pubGN, y.tastingN, y.pubN, y.tasterN, y.vinN, y.wineN, y.wineNameN
		from pubGToPub z
			join tasting y
				on z.pubN = y.pubN
		group by z.pubGN, y.tastingN, y.pubN, y.tasterN, y.vinN, y.wineN, y.wineNameN
