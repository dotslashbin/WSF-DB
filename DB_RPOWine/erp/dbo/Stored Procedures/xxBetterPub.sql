-- upgrade test database to get / set up understandable publication groups xx [=]
CREATE proc xxBetterPub as begin set nocount on /*
 --107220 pavie 2006 rated 96
 
alter table wh add masterPubN int
alter table wh add defaultPubN int


select * from dbo.getCrossReferences(18240,18223,107220)





SELECT whN, tag, fullName, comments, handle, isFake, isPub, isGroup, shortName, displayName, sortName, isLocation, isProfessionalTaster, isErpMember, isRetailer, isImporter, isWinery, isWineMaker, isEditor, 
            isInactive, isView
FROM    wh a
WHERE  exists (select * from tasting b  where b.tasterN = a.whN) and comments not like '%/%'
 
select * from tasting b  where b.tastingN is not null
 
 
 
 
select whN, tag, fullName, comments from wh where whN in (9221036,1596,1764,2014,3301,3336)
 
update tasting set pubN = 7023 where tasterN = 7023 and pubN is null
 
 
select pubN, tasterN
	from tasting a
	where exists 
		(select * 
			from wh b 
			where 
				b.comments like '%/%'
				and b.whN = a.tasterN
			)
		and a.pubN is null
	group by pubN, tasterN
 
 
 
print dbo.getName(18243)
select * from wh where tag = 'pubHG'
 
select dbo.getName(tasterN) from tasting where pubN = 18243 group by tasterN
 
 
 
update a set a.pubN =18243
--select count(*)
	from tasting a
	where exists 
		(select * 
			from wh b 
			where 
				b.comments like '%/HG%'
				and b.whN = a.tasterN
			)
	and a.pubN is null
 
 
print dbo.getName(18245)
select count(*) from tasting where tasterN = 18243
 
 
select count(*)
	from tasting a
	where exists 
		(select * 
			from wh b 
			where 
				b.comments like '%/PZ%'
				and b.whN = a.tasterN
			)
 
 
 
 
 
ooi tasting, taster
 
select count(*) from wh b where b.comments like '%/WC%'
 
select count(*) from tasting where tasterN = 7022
 
 
 
18244  --PZ
 
 
select pubN, count(*) from tasting where tasterN = 7022 group by pubN
 
select count(*) from tasting where tasterN = 7022 and wineN % 5 = 0
 
update tasting set pubN = 3109 where tasterN = 7022 and wineN % 3 = 0
update tasting set pubN = 7023 where tasterN = 7022 and (wineN % 19) = 0 and pubN is null
18244
 
update tasting set pubN = 18244 where tasterN = 7022 and pubN is null
 
 
 
 
 
 
SELECT whN, tag, fullName, comments, handle, isFake, isPub, isGroup, shortName, displayName, sortName, isLocation, isProfessionalTaster, isErpMember, isRetailer, isImporter, isWinery, isWineMaker, isEditor, 
            isInactive, isView
FROM    wh
WHERE (comments LIKE '%/%')
ORDER BY dbo.xxPubOrder(comments) DESC
 
 
 
 
 
 
SELECT 
			whN, handle, isFake, isPub, isGroup, fullName, comments, tag, shortName, displayName, sortName, 
			isLocation, isProfessionalTaster, isErpMember, isRetailer, isImporter, isWinery, isWineMaker, isEditor, 
            isInactive, isView
FROM    wh
WHERE
			(comments LIKE '%/%') OR
			(comments LIKE '%fake pub%') OR
			(handle IS NOT NULL)
ORDER BY
			CASE WHEN comments LIKE '%/PZ%' THEN 0 ELSE 1 END, 
			CASE WHEN comments LIKE '%/TT%' THEN 0 ELSE 1 END, 
			CASE WHEN comments LIKE '%/WC%' THEN 0 ELSE 1 END, 
			CASE WHEN comments LIKE '%/BB%' THEN 0 ELSE 1 END
 
 
 
SELECT whN, handle, isFake, isGroup, fullName, comments, isPub, tag, shortName, displayName, sortName, isLocation, isProfessionalTaster, isErpMember, isRetailer, isImporter, isWinery, isWineMaker, isEditor, 
            isInactive, isView
FROM    wh
WHERE (comments LIKE '%/%') OR
            (comments LIKE '%fake pub%') OR
            (handle IS NOT NULL)
ORDER BY CASE WHEN comments LIKE '%/PZ%' THEN 0 ELSE 1 END, CASE WHEN comments LIKE '%/TT%' THEN 0 ELSE 1 END, CASE WHEN comments LIKE '%/WC%' THEN 0 ELSE 1 END, 
            CASE WHEN comments LIKE '%/BB%' THEN 0 ELSE 1 END
 
 
 
 
 
 
 
select fullname, comments from wh where handle is not null
 
update a set comments = convert(varchar, b.cnt) + ' ' + comments
select a.comments, convert(varchar, b.cnt) + ' fake tastings, ' + comments, a.whN, b.tasterN, b.cnt, a.handle
update a set a.comments =  convert(varchar, b.cnt) + ' fake tastings, ' + comments
	from wh a
	join 
		(select tasterN, count(*) cnt
			from #wt
			group by tasterN
			) b
		on b.tasterN = a.whN
	where a.handle is not null
		and a.comments not like '%fake%tasting%'
 
update wh set comments = 'fake pub, ' + comments where handle is not null and comments not like '%fake%pub%'
 
select * from wh where comments like '%/%'
 
 
select fullname, comments from wh where handle is not null
 
 
107220 pavie rated 96
 
select * into #b from #wt where wineN = 107220
 
select whn, fullName from wh where whN in (select tasterN from #b)
 
update wh set handle = 1 where whN in (select tasterN from #b)
 
select * from #a where wineN in (select tasterN from #b)
 
 
select * from fakename
 
alter table wh add handle smallInt
 
alter table fakeName add isUsed bit
 
update fakeName set isUsed = 1 where (exists
 
select count(*) from wh where comments like '%fake%pub%'
 
update fakeName set isUsed = 1 where nameN <= 35
 
select count(*) from wh where handle is not null
update wh set handle = row_number() over (order by whN)
	where handle is not null
 
update a set handle = b.iRank
	from wh a
	join 
		(select whN, row_number() over(order by whn) iRank
			from wh
			where handle is not null
			) b
		on b.whN = a.whN
 
update 
 
 
 
 
 
 
 
 
 
 
find wines with maximum number of joint fake tasters
 
select count(*) from tasting where _fixedId is null
 
select wineN, count(*) cnt from tasting where _fixedid 
 
 
select wineN, count(*) cnt 
	into #a
	from #wt 
	where wineN in (select wineN from #wt where tasterN = 7022)
	group by wineN having count(*) > 10 order by count(*) desc
 
alter table #a add rating int
 
update a set a.rating = b.rating
	from #a a
	join
		(select wineN, max(rating) rating from rpowinedatad..wine group by wineN) b
		on a.wineN = b.wineN
 
 
select * from rpowinedatad..wine where wineN in (select wineN from #a where rating = 96)
 
select * from rpo 37734
 
107220 pavie 2006 rated 96
 
 
 
 
 
 
 
select * from rpowinedatad..wine where wineN = 37734
 
 
select * 
	into #tt
	from #wt
	where tasterN in (select whN from wh where comments like '%fake%pub%')
 
select wineN, count(*) from #tt group by wineN order by count(*) desc
 
 
--------------------------------------------------
drop table #wt
select wineN, tasterN, count(*) cnt
	into #wt
	from tasting 
	where pubN is null
	group by wineN, tasterN order by count(*) desc
 
select distinct tasterN from #wt where cnt >= 2
 
drop table #multi
select a.tasterN, fullName, winesWithMultipleTastingsCnt, wineCnt
	into #multi
	from 
		(select tasterN, count(*) wineCnt
			from #wt
			group by tasterN
			) a
	join
		(select tasterN, count(*) winesWithMultipleTastingsCnt
			from #wt
			where cnt > 1
			group by tasterN
			) b
		on a.tasterN = b.tasterN
	join wh c
		on c.whN = a.tasterN
	
select * from #multi order by wineCnt desc
 
select * 
	into #targ
	from 
		(select *
			, row_number() over(order by wineCnt desc) iRank
			from #multi
			) a
	where iRank % 20 = 1
 
select * from #targ
 
 
select distinct firstName into #firstNames from membership..full2
select distinct lastName into #lastNames from membership..full2
select firstName, lastName into #firstLast from membership..full2 group by firstName, lastName
select * from #firstLast
 
 
select firstName, lastName
	from 
		(select firstName from #firstNames where len(firstName) > 3 order by len(firstName)) a
		(select lastName from #lastNames where len(lastName) > 5 order by len(lastName)) b
 
create table fakeName (first varchar(99), last varchar(99))
 
insert into  fakeName(first)
	select firstName 
	from #firstNames where len(firstName) > 3 
	order by len(firstName)
 
update a set last = b.lastName
	from fakeName a
	join 
		(select lastName, row_number() over(order by len(lastName)) iRank
			from #lastNames
			where len(lastName) > 4
			) b
		on a.nameN = b.iRank
 
select * from fakeName
 
select count(*) from fakeName a
	where exists
		(select * from membership..full2 b where b.firstName = first and b.lastName = last)
 
 
 
select * from #targ
 
ooi ' wh '
 
select fullName, displayName, comments from wh where whN in (select tasterN from #targ)
 
update wh set comments = 'fake Pub, fake Tasting, ' + comments
	where whN in (select tasterN from #targ)
 
select count(*) from wh where comments like '%fake%pub%'
 
 
select count(distinct wineN) wCnt, count(distinct tasterN) tCnt from tasting where pubN is null
 
 
 
update a set a.fullName = 
 
select fullName, first + ' ' + last
	from
		(select fullName, row_number() over (order by whN) iRank
			from wh
			where comments like '%fake%pub%'
			) a
	join fakeName b
		on b.nameN = a.iRank
 
select upper(left(firstName, 1)) + right(firstName, len(firstName) - 1) 
	from #firstNames
 
update fakeName set first = upper(left(first, 1)) + right(first, len(first) - 1) 
update fakeName set last = upper(left(last, 1)) + right(last, len(last) - 1) 
 
 
select * from fakename
 
 
update a set a.fullName = first + ' Q ' + last
	from
		(select fullName, row_number() over (order by whN) iRank
			from wh
			where comments like '%fake%pub%'
			) a
	join fakeName b
		on b.nameN = a.iRank
 
select * from wh where fullName like '% Q %'
 
update wh set displayName = fullName where fullName like '% Q %' and displayName is null
 
 
ooi ' wh ', 'is'
 
select fullName from wh where fullName is not null and comments not like '%fake%'
 
update wh set isFake = 1 where comments like '%fake%'
 
 
select * from #multi
 
select a.fullName, comments, b.*
--update a set comments = replace(comments, 'fake Tasting', convert(varchar, b.wineCnt) + ' fake tastings')
	from wh a
	left join #multi b
		on a.whN = b.tasterN
	where a.comments like '%fake%pub%'
 
 
 
whN 7022 has about 3000 tastings
 
 
 
 
 
 
*/
end
 
 
 
 
 
