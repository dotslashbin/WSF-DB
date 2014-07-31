--define "fat" view with all needed fields / database PubG tasting update utility view         [=]
CREATE view vPubGTastingFat as
	select
		a.pubGN
		,a.wineN
		,b.tastingN activeTastingN, b.wineNameN
		,c.cnt tastingCountThisPubG
		,d.iconN pubIconN 
		,b.maturity
		,b.rating
		,b.ratingShow
	from mapPubGToWine a
	join vPubGActiveTasting b
		on a.PubGN = b.pubGN
			and a.wineN = b.wineN
	join
		(select pubGN, wineN, count(*) cnt
			from vPubGTasting
			group by pubGN, wineN
			) c
		on a.pubGN = c.pubGN
			and a.wineN = c.wineN
	join wh d
		on a.pubGN = d.whN
