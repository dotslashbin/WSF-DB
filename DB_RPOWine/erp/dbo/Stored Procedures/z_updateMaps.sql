--database maps update		[=]
CREATE procedure z_updateMaps as begin set noCount on 

--------------------------------------------------------
-- PubGToTasting
--------------------------------------------------------
--oodef vPubGToTasting
--delete from mapPubGToTasting

insert into mapPubGToTasting(pubGN, tastingN, pubN, tasterN, vinN, wineN, wineNameN)
	select pubGN, tastingN, pubN, tasterN, vinN, wineN, wineNameN
		from vPubGToTasting z
		where not exists 
			(select 1
				from mapPubGToTasting y
				where z.pubGN = y.pubGN 
					and z.tastingN = y.tastingN
				)

delete from mapPubGToTasting
	where not exists
		(select 1 
			from vPubGToTasting z
			where z.pubGN = mapPubGToTasting.pubGN
				and z.tastingN = mapPubGToTasting.tastingN
			)

--------------------------------------------------------
-- PubGToWine
--------------------------------------------------------
/* moved to updatePubG
--create table mapPubGToWine( pubGN int, wineN int constraint PK_mapPubGToWine primary key (pubGN, wineN))
insert into mapPubGToWine(pubGN, wineN)
	select pubGN, wineN
		from vPubGToWine z
		where not exists 
			(select 1
				from mapPubGToWine y
				where z.pubGN = y.pubGN 
					and z.wineN = y.wineN
				)
*/

delete from mapPubGToWine
	where not exists
		(select 1 
			from vPubGToWine z
			where z.pubGN = mapPubGToWine.pubGN
				and z.wineN = mapPubGToWine.wineN
			)

--------------------------------------------------------
-- PubGToWineName
--------------------------------------------------------

--create table mapPubGToWineName( pubGN int, wineNameN int constraint PK_mapPubGToWineName primary key (pubGN, wineNameN))
insert into mapPubGToWineName(pubGN, WineNameN)
	select pubGN, WineNameN
		from vPubGToWineName z
		where not exists 
			(select 1
				from mapPubGToWineName y
				where z.pubGN = y.pubGN 
					and z.WineNameN = y.WineNameN
				)

delete from mapPubGToWineName
	where not exists
		(select 1 
			from vPubGToWineName z
			where z.pubGN = mapPubGToWineName.pubGN
				and z.WineNameN = mapPubGToWineName.wineNameN
			)

--------------------------------------------------------
-- PriceGToWineName UPGRADE TO BITS
--------------------------------------------------------
--select * from vpriceGToWineName
insert into mapPriceGToWineName(priceGN, includesNotForSaleNow, includesAuction, wineNameN)
	select priceGN, includesNotForSaleNow, includesAuction, wineNameN
		from vpriceGToWineName z
		where not exists 
			(select 1
				from mapPriceGToWineName y
				where z.priceGN = y.priceGN 
					and z.includesNotForSaleNow = y.includesNotForSaleNow
					and z.includesAuction = y.includesAuction
					and z.wineNameN = y.wineNameN
				)

delete from mapPriceGToWineName
	where not exists
		(select 1 
			from vpriceGToWineName z
			where z.priceGN = mapPriceGToWineName.priceGN
				and z.includesNotForSaleNow = mapPriceGToWineName.includesNotForSaleNow
				and z.includesAuction = mapPriceGToWineName.includesAuction
				and z.wineNameN = mapPriceGToWineName.wineNameN
			)





end
