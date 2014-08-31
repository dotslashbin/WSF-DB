--temporary view for update [=]
create view vvWine as
	select 
			 (b.fullName + '  (' + convert(varchar, pubGN) + ')' ) thisG
			,wineN
			,tastingCountThisPubG tastingCount
			,pubGN thisGN
		from
			mapPubGToWine a
			join wh b
				on a.pubGN = b.whN
