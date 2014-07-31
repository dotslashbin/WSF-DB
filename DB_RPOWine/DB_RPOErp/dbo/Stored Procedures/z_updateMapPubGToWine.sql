-- database pubG update xx          [=]
CREATE proc [dbo].[z_updateMapPubGToWine] as begin
 
-----------------------------------------------------------
-- Update mapPubGToWine
-----------------------------------------------------------
-- get most recent "good" tasting for each priceG
-- put selected fields from this into the map table
 
exec dbo.snapRowVersion
exec dbo.updatePubGRecurse
 
insert into mapPubGToWine(pubGN, wineN)
	select pubGN, wineN
		from vPubGToWine z
		where not exists 
			(select 1
				from mapPubGToWine y
				where z.pubGN = y.pubGN 
					and z.wineN = y.wineN
				)
 
delete from mapPubGToWine
	from mapPubGToWine
	where not exists
			(select 1
				from vPubGToWine a
				where a.pubGN = mapPubGToWine.pubGN 
					and a.wineN = mapPubGToWine.wineN
				)
 
 
-----------------------------------------------------------
-- Update using the  isTasterAsPub bit
-----------------------------------------------------------
 
/* 
create view vPubNeedingTasters as 
	select pubGN, pubN, dbo.getName(pubGN) pubG, dbo.getName(pubN) pub
			from pubGToPub a
				join wh b
					on b.whN = a.pubN
				where 
					b.isTasterAsPub = 1
 
alter view vPubToTaster as
	select pubGN, pubN, tasterN, pubG, pub, dbo.getName(tasterN) taster
		from vPubNeedingTasters a
			join whToTaster b
				on b.whN = a.pubN
 
 
 
begin try drop table #TastingG end try begin catch end catch
 
select tasterN, wineN 
	into #TastingG
	from tasting
	group by tasterN, wineN;
 
select a.pubGN, a.pubN,b.wineN, dbo.getName(a.pubGN), dbo.getName(a.pubN)
	from vPubToTaster a
		join #tastingG b
			on a.tasterN = b.tasterN
 
 
 
-----------------------------------------------------------
-- make sure that we are adding counts for all the reasonable groupings
-----------------------------------------------------------
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
 
 
 
 
 
 
/*
 
-----------------------------------------------------------
-- Definition of Views Used
-----------------------------------------------------------
-- database PubG tasting update utility view         [=]
alter view vPubGTasting as
	select a.pubGN, b.*
		from
			mapPubGToWine a
				left join tasting b
					on a.wineN = b.wineN
				where b.pubN in (select pubN from pubGToPub where pubGN = a.pubGN)
 
 
-- database PubG tasting update utility view         [=]
alter view vPubGMostRecent as
	select * 
		from
			(select *, row_number() over (partition by pubGN, wineN order by tasteDate desc, pubDate desc, tastingN) iRank 
				from vPubGTasting
				) a
		where iRank = 1
 
 
-- tastings equivalent to the most recent tasting / database PubG tasting update utility view         [=]
alter view vPubGLikeMostRecent as
	select a.*
		from vPubGTasting a
		join vPubGMostRecent b
			on a.pubGN = b.pubGN
				and a.wineN = b.wineN
		where (b.rating is null or b.rating = a.rating)
			and (b.drinkDate is null or year(b.drinkDate) = year(a.drinkDate))
			and (b.drinkDateHi is null or year(b.drinkDateHi) = year(a.drinkDateHi))
 
 
-- get first "real" equivalent to the most recent tasting / database PubG tasting update utility view         [=]
alter view vPubGActiveTasting as
	select a.*
		from
			(select *, row_number() over (partition by pubGN, wineN order by tasteDate desc, pubDate desc, tastingN) iRank
				from vPubGLikeMostRecent
				) a
		where iRank = 1
 
--define "fat" view with all needed fields / database PubG tasting update utility view         [=]
alter view vPubGTastingFat as
	select
		a.pubGN
		,a.wineN
		,b.tastingN activeTastingN, b.wineNameN
		,c.cnt tastingCountThisPubG
		,d.pubIconN
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
 
/*
select count(*) from mapPubGToWine
select count(*) from vPubGActiveTasting
select count(*) from vPubGTastingFat
*/
 
 
*/
 
-----------------------------------------------------------
-- Update the tasting-related fields
-----------------------------------------------------------
 
exec snapRowVersion
 
update a
		set 
			 a.activeTastingN = b.activeTastingN
			,a.pubIconN = b.pubIconN
			,a.maturity = b.maturity
			,a.rating = b.rating
			,a.ratingShow = b.ratingShow
			,a.tastingCountThisPubG = b.tastingCountThisPubG
			,a.wineNameN = b.wineNameN
		from mapPubGToWine a
			join vPubGTastingFat b
				on a.pubGN = b.pubGN
					and a.wineN = b.wineN
		where
			(a.activeTastingN is null and b.activeTastingN is not null) or (a.activeTastingN is not null and b.activeTastingN is null) or (a.activeTastingN <> b.activeTastingN)
				or (a.pubIconN is null and b.pubIconN is not null) or (a.pubIconN is not null and b.pubIconN is null) or (a.pubIconN <> b.pubIconN)
				or (a.maturity is null and b.maturity is not null) or (a.maturity is not null and b.maturity is null) or (a.maturity <> b.maturity)
				or (a.rating is null and b.rating is not null) or (a.rating is not null and b.rating is null) or (a.rating <> b.rating)
				or (a.ratingShow is null and b.ratingShow is not null) or (a.ratingShow is not null and b.ratingShow is null) or (a.ratingShow <> b.ratingShow)
				or (a.tastingCountThisPubG is null and b.tastingCountThisPubG is not null) or (a.tastingCountThisPubG is not null and b.tastingCountThisPubG is null) or (a.tastingCountThisPubG <> b.tastingCountThisPubG)
				or (a.wineNameN is null and b.wineNameN is not null) or (a.wineNameN is not null and b.wineNameN is null) or (a.wineNameN <> b.wineNameN)
 
-----------------------------------------------------------
-- Update derivative file
-----------------------------------------------------------
 
exec dbo.updateMapPubGToWineTasting
 
 
 
/*
select top 20 * from mapPubGToWine order by rowVersion desc
 
 
 
*/
 
 
 
 
/* OLD code from existing isActiveT calculation
update winew set isActiveT = 0;
with
xwho as (select * from winew)
,xeq as (
     select  
     (case when
          exists (select * from xwho y where 
               z.wineN = y.wineN 
               and y.isMostRecentTasting = 1 
               and (y.rating is null or (z.rating = y.rating))
               and (y.drinkDate is null or (year(z.drinkDate) = year(y.drinkDate)))
               and (y.drinkDate_hi is null or (year(z.drinkDate_hi) = year(y.drinkDate_hi)))
          )
          then 1 else 0 end
     ) isEq, *from xwho z)
,xActive as (select 
	row_number() over (partition by wineN, order by wineN, isEq desc, isNoTasting, tasteDate desc) iRank
     ,* from xeq)
update xActive set isActiveT = 1 where iRank = 1
*/
 
end
 
 
 
 
 
 
