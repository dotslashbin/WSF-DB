-- pubG update wine xx [=]
CREATE proc [dbo].[z_updateMapWineToPubGPub] as begin
set noCount on
/*
begin try drop view vTop  end try begin catch end catch
-- temporary update view [=]
alter view vTop as
	--select a.pubGN masterGN, c.fullName masterGFullName, a.pubN topN, d.fullName topFullName, d.displayName topDisplayName, b.wineN, b.tastingCountThisPubG topTastingCount
	select a.pubGN masterGN, c.fullName masterGFullName, a.pubN topN, d.fullName topFullName, b.wineN, b.tastingCountThisPubG topTastingCount
		from pubGtoPub a
			join mapPubGToWine b
				on b.pubGN = a.pubN
			join wh c
				on c.whN = a.pubGN
			join wh d
				on d.whN = a.pubN
		where a.isDerived = 0
			--and not exists (select * from pubGToPub where pubN = a.pubGN)
			and b.wineN = 22168
			and a.pubGN = 18241


----------------------------------------------
-- Demonstrates current situation
----------------------------------------------
select * from vTop
select a.*, c.pubGN thisGN, d.fullName thisFullName, c.tastingCountThisPubG thisTastingCount
	from vTop a
		join pubGToPub b
			on a.topN = b.pubGN
		join mapPubGToWine c
			on b.pubN = c.pubGN
		join wh d
			on c.pubGn = d.whN
		where 	
			--(a.topTastingCount > c.tastingCountThisPubG or a.topN <> c.pubGN)
			--and
			c.wineN = a.wineN








x-All Publications (18241)
x-Wine Advocate Group (18242)
Wine Advocate Group (18223)

declare @memberWhN int, @pubGN int, @wineN int, @myMasterPubGN
select @pubGN = 9, @wineN = 22168, @myMasterPubGN = 18241



-----------------------------------
-- overview report of current status
-----------------------------------
begin try drop table #top  end try begin catch end catch
select dbo.getName(pubN) topTitle, pubN topN, tastingCountThisPubG topTastingCount
	into #top
	from pubGtoPub a
		join mapPubGToWine b
			on b.pubGN = a.pubN
				and b.wineN = 22168
	where a.pubGN = 18241 and a.isDerived = 0;
select * from #top
select dbo.getName(pubGN) fullName, * from mapPubGToWine where wineN = 22168
exec oopubg


select a.topN, a.topTastingCount, c.pubGN, wineN, tastingCountThisPubG
select count(*)
	from #top a
		join pubGToPub b
			on a.topN = b.pubGN
		join mapPubGToWine c
			on b.pubN = c.pubGN
		where 
			a.topTastingCount > c.tastingCountThisPubG
			and c.wineN = 22168





select * from mapPubGToWine










update pubGtoPub set pubN = 18242
	where pubGN = 18241 and pubN = 18241
select * from pubGtoPub where pubGN = 18241 and pubN = 18241




updateMapPubGToWine


 
begin try drop table #tas  end try begin catch end catch
begin try drop table #tcount  end try begin catch end catch
 
begin try drop table XXXXXXXX  end try begin catch end catch
begin try drop table XXXXXXXX  end try begin catch end catch
begin try drop table XXXXXXXX  end try begin catch end catch
begin try drop table XXXXXXXX  end try begin catch end catch
 
begin try drop table #pub  end try begin catch end catch
 select pubGN, pubN
	--into #pub
	from pubGToPub a where not exists (select * from pubGToPub where pubN = a.pubGN)

oopubg

select * from #pub
 
select wineN, pubN
	into #tas
	from tasting where pubN is not null
 
--get all non topside combinations
begin try drop table #tcount  end try begin catch end catch
select a.wineN, b.pubGN, count(*) tastingCount
	into #tcount
	from #tas a
		join #pub b
			on b.pubN = a.pubN
	group by a.wineN, b.pubGN
	order by a.wineN, b.pubGN
 
begin try drop table #many  end try begin catch end catch
select distinct wineN 
	into #many
	from #tcount a
	where exists
		(select * from #tcount where wineN = a.wineN group by wineN having count(*) >= 5)
 
delete from #tas where wineN <> 22168
delete from #tCount where wineN <> 22168
 
select * from #tas
select * from #tCount
		wineN		pubGN		tastingCount
		22168		4				1
		22168		6				1
		22168		8				1
		22168		9				3
		22168		18223		5
 
begin try drop table #myPubG  end try begin catch end catch
select distinct pubGN myPubGN into #myPubgN from #pub
 
select * from #pubg
 
select myPubGN, dbo.getName(myPubGN) my, wineN, b.pubGN otherPubGN, dbo.getName(b.pubGN) other, tastingCount
	from #myPubGN a
		full outer join #tCount b
			on 1=1
	where exists (select * from #tCount where wineN = b.wineN and pubGN = a.myPubGN)
	order by wineN, myPubGN, b.pubGN
 
 
 
 
 
 
 
 
 
 
insert into wh (tag, fullName, shortName, displayName, sortName, comments, isGroup, isPub, iconN  )
select 
	'x-' + tag, 'x-' + fullName, 'x-' + shortName, 'x-' + displayName, 'x-' + sortName, 'x-' + comments, isGroup, isPub, iconN
	from wh 
	where whn = 18223
 
 
x-All Publications				18241
x-Wine Advocate Group		18242

oopubG

insert into pubGToPub (pubGN, pubN)
	select 18242, pubN
	from pubGtoPub
		where pubN not in (1,2,3,8) and pubGN = 18223

select * from pubGtoPub
	


Wine Journal (6)
Bordeaux Book, 3rd Edition (1)
Burgundy Book (2)
Buying Guide, 2nd Edition (3)
Rhone Book (8)



-----------------------------------------------------------------------------------
-- Adjust Master for cross ref testing
-----------------------------------------------------------------------------------

oopubg










 
 
select tastingN, pubN
	into #tasPub
	from vtas
 
select * from #winetop where pubGN = 6 order by tastingCount desc
select * from #winetop where wineN = 33755
 
 
select distinct pubGN x from pubGtoPub
except
select distinct pubN x from pubGtoPub
 
--build a master count table, then expand for each myPubG
 
oopubg
 
 
 
 
 
 
 
 
-- temporary view [=]
create view vPub as 
	select b.pubGN pubGN, c.iconN pubGIconN, b.pubN pubN 
		from pubGtoPub a
			join pubGToPub b
				on a.pubN = b.pubGN
			join wh c
				on c.whN = b.pubGN
			where 
				a.pubGN = dbo.getPubN('allPub')
				and a.isDerived = 0
 
-- temporary view [=]
alter view vTas as
	select tastingN, wineN, pubN from tasting where pubN is not null
 
 
 
 
select wineN, pubGN, pubGiconN, count(*) tastingCount
into #wineTop
	from vPub a
		join vTas b
			on a.pubN = b.pubN
	group by wineN, pubGN, pubGiconN
	order by wineN, pubGN;
 
with
a as (select wineN from #wineTop group by wineN having count(*) > 1)
select * from #wineTop b where exists (select * from a where wineN = b.wineN)
 
 
 
 
 
 
 
 
 
 
 
select d.wineN. b.pubGN, b.pubN otherPubN, b. pubGIconN otherPubIconN, count(*) otherPubTastingCount
	from 
		(select wineN, pubN from tasting where pubN is not null) d
		join 
				(select b.pubGN pubGN, c.iconN pubGIconN, b.pubN pubN 
					from pubGtoPub a
						join pubGToPub b
							on a.pubN = b.pubGN
						join wh c
							on c.whN = b.pubGN
						where 
							a.pubGN = dbo.getPubN('allPub')
							and a.isDerived = 0
					) e
				on e.pubN = d.pubN
		group by 
 
with
 a as 
	(select wineN, pubN from tasting 
		where pubN is not null
		)
,b as 
	(select b.pubGN groupN, c.iconN groupIconN, b.pubN detailN
		from pubGtoPub a
			join pubGToPub b
				on a.pubN = b.pubGN
			join wh c
				on c.whN = b.pubGN
			where 
				a.pubGN = dbo.getPubN('allPub')
				and a.isDerived = 0
		)
,c as 
	(select pubN possibleN from pubGtoPub group by PubN)
select 
	from c 
		join 
 
 
select a.wineN, subMasterN, b.*, a.*
	from a
		join b
			on a.pubN = b.detailN
		where a.wineN = 24575
 
wineN
currentUserPubGN
otherPubN
otherPubIconN
otherPubTastingCount
rowversion
 
 
 
 
 
 
 
 
 
 
drop view vpop
 
 
 
 
wineN	pubN		reviewCount
 
1		wineJournal														ALL		1
		wineAdvocate Group											ALL		3
		(subordinate)
		italy report						WineAdvocateGroup		ALL		1
		wine advocate				WineAdvocateGroup		ALL		2
 
 
 
oon 'count'
 
 
ooi mapPubGToWine_
		wineN
		pubGN
		pubIconN
		tastingCountThisPubG
		rowversion
 
 
create table mapWineToPubGPub (wineN int, pubGN int, otherPubN int, otherPubIconN smallInt, otherPubTastingCount int, rowversion timeStamp)
 
 
 
select count (distinct pubGN) from pubGtoPub
 
oof 'update*pub'
 
*/
end
 
