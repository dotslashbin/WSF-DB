-- get first "real" equivalent to the most recent tasting / database PubG tasting update utility view         [=]
CREATE view vPubGActiveTasting as
	select a.*
		from
			(select *, row_number() over (partition by pubGN, wineN order by tasteDate desc, pubDate desc, tastingN) iRank
				from vPubGLikeMostRecent
				) a
		where iRank = 1
