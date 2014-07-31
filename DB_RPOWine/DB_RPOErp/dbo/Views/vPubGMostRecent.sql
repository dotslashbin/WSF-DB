-- database PubG tasting update utility view         [=]
CREATE view vPubGMostRecent as
	select * 
		from
			(select *, row_number() over (partition by pubGN, wineN order by tasteDate desc, pubDate desc, tastingN) iRank 
				from vPubGTasting
				) a
		where iRank = 1


