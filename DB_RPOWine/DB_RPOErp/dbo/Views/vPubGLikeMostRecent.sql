-- tastings equivalent to the most recent tasting / database PubG tasting update utility view         [=]
CREATE view vPubGLikeMostRecent as
	select a.*
		from vPubGTasting a
		join vPubGMostRecent b
			on a.pubGN = b.pubGN
				and a.wineN = b.wineN
		where (b.rating is null or b.rating = a.rating)
			and (b.drinkDate is null or year(b.drinkDate) = year(a.drinkDate))
			and (b.drinkDateHi is null or year(b.drinkDateHi) = year(a.drinkDateHi))
