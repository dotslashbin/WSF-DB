-- mapPubGToWineTasting update xx [=]
CREATE proc updateMapPubGToWineTasting as begin
 
---------------------------------------------------------------------
--TO DO
---------------------------------------------------------------------
	-- make sure that odd publication groupings still give a good activeN
	-- updateMapPubGToWineTasting 
---------------------------------------------------------------------
---------------------------------------------------------------------
 
insert into mapPubGToWineTasting(pubGN, wineN, tastingN)
	select a.pubGN, a.wineN, b.tastingN
		from mapPubGToWine a
			join tasting b
				on a.wineN = b.wineN
			join pubGToPub c
				on c.pubGN = a.pubGN
					and c.pubN = b.pubN
		where not exists
			(select * 
				from mapPubGToWineTasting d
					where d.pubGN = a.pubGN
						and d.wineN = a.wineN
						and d.tastingN = b.tastingN
				)
 
	delete from mapPubGToWineTasting
		where not exists
			(select * 
				from mapPubGToWineTasting a
					where pubGN = a.pubGN
						and wineN = a.wineN
						and tastingN = a.tastingN
				)
 
end
 
