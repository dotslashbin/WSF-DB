CREATE proc [zupdateJulianPrices] as 
begin
 
/*
updateJulianPrices
 
drop view vAlert
create view vAlert as (select [winealert id]wid, * from waWineAlertDatabase)
create view vForSale as (select [winealert id]wid, * from waForSale)
*/
 
------------------------------------------------------------------------------------ --------------------------------------------------------------------------------------------
--1.     Fill in vinn2, producer2, producerShow2
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
declare @date smallDateTime = getDate()
 
update vAlert set errors = null, warnings = null, vinn2 = null, producer2 = null, producerShow2 = null
update vForSale set errors = null, warnings = null
 
 
update vAlert set errors = isNull(errors + ';  ', '') + '[E01]  Vinn not numeric' where vinn is not null and isNumeric(vinn) = 0;
update vAlert set vinn2 = convert(int, vinn) where errors is null;
 
update a set errors = isNull(errors + ';  ', '') + '[E05]  WineAlert Id not in WineAlert Database'
	from (select *  from vForSale where wid is not null) a
		left join (select wid from vAlert where wid is not null) b
			on a.wid = b.wid
	where
		b.wid is null
		
/*
select * from vForSale where errors is not null
*/
 
 
--fill in vinn2 when there is a unique mapping through wineN from forSale-------------------------------------------------------------
update vAlert set vinn2 = null, producer2 = null, producerShow2 = null;
 
with
 a as (select wid, vinn2 from vAlert where vinn2 is null) 
,b as (select wid, wineN from vForSale where wineN is not null group by wid, wineN) 
,c as	(select wid, d.vinn
		from b
			join erpWine d
				on b.wineN = d.wineN
)
,e as (select wid from c group by wid having count(*) = 1)
update a set vinn2 = vinn
	from a
		join c on a.wid = c.wid
		join b on a.wid = b.wid
 
 
 
 --translate to erp producer when there is a vinn-------------------------------------------------------------
update a set a.producer2 = b.producer, a.producerShow2 = b.producerShow
	from vAlert a
		join (select vinn, producer, producerShow, row_number() over(partition by vinn order by producer)ii from erpWine)b
			on a.vinn2 = b.vinn and b.ii = 1
			
-- translate other wines with same producer-------------------------------------------------------------
update a set a.producer2 = b.producer2, a.producerShow2 = b.producerShow2
	from vAlert a
		join (select row_number() over (partition by prod order by producer2)ii, prod, producer2, producerShow2 from vAlert where vinn2 is not null) b
			on a.prod = b.prod and b.ii=1
	where
		a.producer2 is null; 
 
-- fill in the remaining ones from vAlert
update vAlert set producer2 = replace(prod, '"', ''),producerShow2 = replace(prodShow, '"', '') where producer2 is null
 
 
--update vinn2 from allocateVinn-------------------------------------------------------------
update a set vinn2 = b.vinn
	from vAlert a
		join allocateWidVinn b
			on a.wid = b.wid
 
 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--1a.     Create new non-erp Vinns for wid mapping
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
merge allocateWidVinn as aa
	using	(select vinn from erpWine group by vinn)bb
on aa.vinn = bb.vinn
when matched then
	update set aa.isAuto = 0
when not matched by target then
	insert  (wid, vinn, isAuto)
		values(null, bb.vinn, 0);
 
merge allocateWidVinn as aa
	using	(select max(wid)wid, vinn from vAlert where vinn is not null and errors is null group by vinn) as bb
on aa.vinn = bb.vinn
when matched then
	update set aa.wid = bb.wid, aa.isAuto = 0
when not matched by target then
	insert  (wid, vinn, isAuto)
		values(bb.wid, bb.vinn, 0);
 
declare @maxRealVinn int = (select max(vinn) from allocateWidVinn where isAuto = 0);
declare @minAutoVinn int = (select min(vinn) from  allocateWidVinn where vinn > @maxRealVinn and isAuto <> 0);
set @minAutoVinn = isNull(@minAutoVinn, 1000000);
with
a as (select a.wid, row_number() over(order by a.wid)ii
	from vAlert a 
		left join allocateWidVinn b
			on a.wid = b.wid
	where a.wid like '%[!a-b0-9]%'and b.wid is null
	)
insert into allocateWidVinn(wid, vinn, isAuto) 
	select wid,@minAutoVinn-ii,1 from a	
 
 
 
 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--2.     Update Raw Tables
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
delete from nameYearRaw;
 
insert into nameYearRaw(phase, wineN, vinN, fixedId, producer, producerShow, labelName,vintage,country, region, location, locale, [site], variety, colorClass, dryness, wineType,dateCreated, dateUpdated)
	select '2', wineN, vinN, fixedId, producer, producerShow, labelName,vintage,country, region, location, locale, [site], variety, colorClass, dryness, wineType, SourceDate, @date
	from erpWine;
 
with 
a as (select distinct vinn from erpWine where vinn is not null)
,b as (select * from vAlert where wid is not null and errors is null)
update b set b.errors = isNull(errors + ';  ', '') + '[E02]  Vinn not in erpWine'
	from b
		left join a
			on a.vinn = b.vinn2
		--where b.vinn2 is not null and a.vinn is null and b.errors is null;
		where b.vinn2 is null ;
 
/*
select * from valert where errors is not null
*/ 
 
update vForSale set errors = isNull(errors, ';  ') + '[E03]  WineN is not numeric' where wineN is not null and isNumeric(wineN) = 0;
 
with a as	(select distinct wineN from erpWine)
update b set b.errors = isNull(errors + ';  ', '') + '[E04]  WineN not in erpWine'
	from vForSale b
		left join a
			on a.wineN = b.wineN
		where b.wineN is not null and a.wineN is null and b.errors is null;
		
with 
a as (select wineN, min(vinn)vinn from erpWIne group by wineN)
, b as (select * from vForSale where errors is null)
, c as (select * from vAlert where errors is null)
update b set b.warnings = isNull(b.warnings + ';  ', '') + '[W01]  Vinn from WneN <> Vinn from WineAlertID'
	from b
		join a
			on a.wineN = b.wineN
		join c
			on b.wid = c.wid
	where a.vinn <> c.vinn2;
 
-------------------------------------------------------------------------
--2a.     Add succesive goups of wine to nameYear
-------------------------------------------------------------------------
 
--drop table #forSale
--drop table #Alert
 
--2a1.    add in erpFields for forSale items with wineN	
--2a2.    add in erp wine where wineN can be deduced from erpWine through wid=>vinn, vintage
--2a3     add in erpFields where there is wid=>vinn but no wineN can be deduced.  use vinn, create a wineN
--2a4.    add in vAlert for forSale items with no vinn.  use newly created vinn then create a wineN
--2a5     add in erpFields for vAlert not already in nameyear
--add in erpFields for vAlert not already in nameyear
 
--add in erpFields for forSale items with wineN	
select wid, wineN, vintage into #forSale from vForSale  where errors is null group by wid, wineN, vintage;
 
with
b as (select *, row_number() over(partition by wineN order by wineN)ii from erpWine)
insert into nameYearRaw(phase, wineN, vinn, wid, producer, producerShow, labelName,vintage,country, region, location, variety, colorClass, dryness, wineType,dateCreated, dateUpdated)
	select '2a', a.wineN, b.vinn,  a.wid, producer, producerShow, labelName, b.vintage, country, region, location, variety, colorClass, dryness, wineType, null, @date
	from #forSale a
		join b 
			on b.wineN = a.wineN and b.ii=1;
 
 
 
--2a2.     add in erp wine where wineN can be deduced from erpWine through wid=>vinn, vintage
select a.wid, a.vintage into #forSale2
	from (select wid, vintage from #forSale group by wid, vintage) a
		left join (select wid, vintage from nameYearRaw group by wid, vintage) b
			on a.wid=b.wid and a.vintage = b.vintage
	where b.wid is null and b.vintage is null;
 
with
a as (select wid, vintage from #forSale2)
,b as (select wid, vinn, row_number() over(partition by wid order by id )ii from vAlert where errors is null)
,c as (select *, row_number() over(partition by vinn, vintage order by sourceDate desc)ii from erpWine)
insert into nameYearRaw(phase, wineN, vinn, wid, producer, producerShow, labelName,vintage,country, region, location, variety, colorClass, dryness, wineType,dateCreated, dateUpdated)
	select '2a2', c.wineN, c.vinn,  a.wid, producer, producerShow, labelName, a.vintage, country, region, location, variety, colorClass, dryness, wineType, null, @date
	from a
		join b
			on b.wid = a.wid and b.ii = 1
		join c
			on c.vinn = b.vinn and c.ii = 1;
/*
--select * from #forSale2 order by vintage desc
--select distinct warnings from vForSale
--select distinct warnings from vAlert
--select distinct vintage from vForSale
 
select count(*) from #forsale2
select count(*) from #forsale3
*/
 
 
--2a3     add in erpFields where there is wid=>vinn but no wineN can be deduced.  use vinn, create a wineN
select a.* into #forSale3
	from #forSale2 a
		left join (select wid, vintage from nameYearRaw group by wid, vintage) b
			on a.wid = b.wid and a.vintage = b.vintage
	where
		b.wid is null and b.vintage is null;
with
a as (select wid, vintage from #forSale3 where wid is not null)
,b as (select * from (select wid, vinn, row_number() over(partition by wid order by id )ii from vAlert where vinn is not null and errors is null) b where b.ii = 1)
,c as (select * from (select *, row_number() over(partition by vinn order by sourceDate desc)ii from erpWine) c where c.ii = 1)
insert into nameYearRaw(phase, wineN, vinn, wid, producer, producerShow, labelName,vintage,country, region, location, variety, colorClass, dryness, wineType,dateCreated, dateUpdated)
	select 
		'2a3'
		--Have to use same calculation that we would for get for wineForVintage--oofr vintage
		,erp.dbo.calcWineFromVinnVintage(b.vinn, a.vintage, 1)
		,b.vinn,  a.wid, producer, producerShow, labelName, a.vintage, country, region, location, variety, colorClass, dryness, wineType, null, @date
	from a
		join b
			on b.wid = a.wid
		join c
			on c.vinn = b.vinn
/*
with
a as (select wid, vintage from #forSale3 where wid is not null)
,b as (select * from (select wid, vinn, row_number() over(partition by wid order by id )ii from vAlert where vinn is not null and errors is null) b where b.ii = 1)
,c as (select * from (select *, row_number() over(partition by vinn order by sourceDate desc)ii from erpWine) c where c.ii = 1)
 
select count(*)
	from #a a
		join #b b
			on b.wid = a.wid
		join #c c
			on c.vinn = b.vinn
 
select * into #a from (select wid, vintage from #forSale3 where wid is not null) a
select * into #b from (select * from (select wid, vinn, row_number() over(partition by wid order by id )ii from vAlert where vinn is not null and errors is null) b where b.ii = 1)a
select * into #c from  (select * from (select *, row_number() over(partition by vinn order by sourceDate desc)ii from erpWine) c where c.ii = 1) a
 
select count(*) from #a
select count(*) from #b
select count(*) from #c
 
select * from #a a
	join (select * from vAlert where vinn is not null and errors is null) b
		on a.wid = b.wid
 
select * from #forsale4 where wid = 'al1153188'
 
select * from valert where wid = 'al1153188'
 
declare @date smallDateTime = getDate();
with
a as (select wid, vintage from #forSale4)
--,b as (select *, row_number() over(partition by wid order by id )ii from vAlert where errors is null)
,b as (select distinct(wid), 1 ii from vAlert where errors is null)
select count(*) 
	from a
		join b
			on b.wid = a.wid and b.ii = 1;
 
 
	select 
		'2a4'
		--Have to use same calculation that we would for get for wineForVintage--oofr vintage
		,erp.dbo.calcWineFromVinnVintage(b.vinn2, a.vintage, 1)
		,b.vinn2,  a.wid, producer2, producerShow2, labelName, a.vintage, country, region, location, variety, colorClass, dryness, wineType, null, @date
	from a
		join b
			on b.wid = a.wid and b.ii = 1;
 
*/
 
 
--2a4.    add in vAlert for forSale items with no vinn.  use newly created vinn then create a wineN
select a.* into #forSale4
	from #forSale3 a
		left join (select wid, vintage from nameYearRaw group by wid, vintage) b
			on a.wid = b.wid and a.vintage = b.vintage
	where
		b.wid is null and b.vintage is null;
 
with
a as (select wid, vintage from #forSale4)
,b as (select *, row_number() over(partition by wid order by id )ii from vAlert where errors is null)
insert into nameYearRaw(phase, wineN, vinn, wid, producer, producerShow, labelName,vintage,country, region, location, variety, colorClass, dryness, wineType,dateCreated, dateUpdated)
	select 
		'2a4'
		--Have to use same calculation that we would for get for wineForVintage--oofr vintage
		,erp.dbo.calcWineFromVinnVintage(b.vinn2, a.vintage, 1)
		,b.vinn2,  a.wid, producer2, producerShow2, labelName, a.vintage, country, region, location, variety, colorClass, dryness, wineType, null, @date
	from a
		join b
			on b.wid = a.wid and b.ii = 1;
 
 
--2a5.     add in erpFields for vAlert not already in nameyear
with
a as (select distinct(wid) from vAlert
	except
	select distinct(wid) from nameYear)
,b as (select *, row_number() over(partition by wid order by id )ii from vAlert where errors is null)
insert into nameYearRaw(phase, wineN, vinn, wid, producer, producerShow, labelName,vintage,country, region, location, variety, colorClass, dryness, wineType,dateCreated, dateUpdated)
	select 
		'2a5'
		--Have to use same calculation that we would for get for wineForVintage--oofr vintage
		,erp.dbo.calcWineFromVinnVintage(b.vinn2, null, 1)
		,b.vinn2,  a.wid, producer2, producerShow2, labelName, null, country, region, location, variety, colorClass, dryness, wineType, null, @date
	from a
		join b
			on b.wid = a.wid and b.ii = 1;
 
exec dbo.droptable '#forSale'
exec dbo.droptable '#forSale2'
exec dbo.droptable '#forSale3'
exec dbo.droptable '#forSale4'
 
 
 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--3.     Normalize names
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
delete from nameYearNorm
 
set identity_Insert nameYearNorm on 
insert into nameYearNorm(idn,wineN,vinN,wid,producer,producerShow,labelName,vintage,country,region,location,locale,site,variety,colorClass,dryness,wineType,dateCreated,dateUpdated,whoUpdated,fixedId)
select idn,wineN,vinN,wid,producer,producerShow,labelName,vintage,country,region,location,locale,site,variety,colorClass,dryness,wineType,@date, @date,whoUpdated,fixedId
	from nameYearRaw
set identity_Insert nameYearNorm off
 
update nameYearNorm set producer = dbo.normalizeName(producer)
update nameYearNorm set producerShow = dbo.normalizeName(producerShow)
update nameYearNorm set labelName = dbo.normalizeName(labelName)
update nameYearNorm set vintage = dbo.normalizeName(vintage)
update nameYearNorm set country = dbo.normalizeName(country)
update nameYearNorm set region = dbo.normalizeName(region)
update nameYearNorm set locale = dbo.normalizeName(locale)
update nameYearNorm set site = dbo.normalizeName(site)
update nameYearNorm set variety = dbo.normalizeName(variety)
update nameYearNorm set colorClass = dbo.normalizeName(colorClass)
update nameYearNorm set dryness = dbo.normalizeName(dryness)
update nameYearNorm set wineType = dbo.normalizeName(wineType)
 
 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--4.     Get Unique Entries
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
delete from nameYear;
insert into nameYear(wineN,vinN,wid,producer,labelName,vintage,country,region,location,locale,site,variety,colorClass,dryness,wineType)
select wineN,vinN,wid, producer,labelName,vintage,country,region,location,locale,site,variety,colorClass,dryness,wineType
	from  nameYearNorm 
	group by wineN,vinN,wid,producer,labelName,vintage,country,region,location,locale,site,variety,colorClass,dryness,wineType
	order by producer,labelName,country,region,location,locale,site,variety,colorClass,dryness,wineType,vintage
 
update nameYear 
	set 
		  joinX = dbo.getJoinX(Producer, labelName, colorClass, country, region, location, locale, site, variety, wineType, dryness);
 
with
a as (select Producer, labelName, colorClass, country, region, location, locale, site, variety, wineType, dryness, MIN(joinX) joinX
			from nameYear
			group by Producer, labelName, colorClass, country, region, location, locale, site, variety, wineType, dryness
		)
insert into wineName (Producer, labelName, colorClass, country, region, location, locale, site, variety, wineType, dryness, createDate, joinx)
	select a.Producer, a.labelName, a.colorClass, a.country, a.region, a.location, a.locale, a.site, a.variety, a.wineType, a.dryness, @date, a.joinx
		from a
			left join wineName b
				on a.joinx = b.joinx
		where b.wineNameN is null;
 
update a
	set a.wineNameN = b.wineNameN
	from nameYear a
		join wineName b
			on a.joinx = b.joinx;
 
 
with
a as (select @date dateLo, @date dateHi, min(vintage)vintageLo, max(vintage)vintageHi, count(*)wineCount, joinx from nameYear group by joinx)
,b as (select dateLo, dateHi, vintageLo, vintageHi, wineCount, joinx from wineName)
,c as
	(
		select min(dateLo)dateLo, max(dateHi)dateHi, min(vintageLo)vintageLo, max(vintageHi)vintageHi, max(wineCount)wineCount, joinx from
		(
			select * 	from a
			union 
			select * from b
		)d
		group by joinx
	)
update e set dateLo=c.dateLo, dateHi=c.dateHi, vintageLo=c.vintageLo, vintageHi=c.vintageHi, wineCount=c.wineCount, e.isOld = 0
	from wineName e
		join c
			on e.joinx = c.joinx
 
merge wineName as aa
	using	(select distinct joinx from nameyear
		) as bb
	on aa.joinx = bb.joinx
when matched then
	update set aa.isOld = 0
when not matched by source then
	update set aa.isOld = 1;
 
 
 
merge equivalenceMap as aa
	using	(select wid, vinn, wineN, vintage from nameYear group by wid, vinn, wineN, vintage
		) as bb
	--on aa.wid = bb.wid and aa.vinn=bb.vinn and aa.wineN = bb.wineN and aa.vintage = bb.vintage
	on isNull(aa.wid, '') = isNull(bb.wid, '') and isnull(aa.vinn,0)=isnull(bb.vinn,0) and isnull(aa.wineN, 0) = isnull(bb.wineN, 0) and isnull(aa.vintage, '') = isnull(bb.vintage, '')
when matched then
	update set aa.isOld = 0
when not matched by target then
	insert  (wid, vinn, wineN, vintage, isOld)
		values(bb.wid, bb.vinn, bb.wineN, bb.vintage, 0)
when not matched by source then
	update set aa.isOld = 1;
 
 
 
 
 
 
 
 
 
 
 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--5.     Update Active Bits
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	update nameYear
		set 
			 isVinnWid = 0
			,isWidVinn = 0
			,isNameVinn = 0
			,isNameWid = 0;
 
	with
	 a as (select vinn, wineNameN, isNameVinn, vintage, rank() over (partition by vinn order by vintage desc, wineNameN) iRank from nameYear where vinn is not null and wineNameN is not null)
	,b as (select distinct(wineNameN) from a where iRank = 1)
	update c set isNameVinn = 1
		from nameYear c
			join b on c.wineNameN = b.wineNameN;
  
	with
	 a as (select vinn, wid, isVinnWid, vintage, rank() over (partition by vinn order by vintage desc, wid) iRank from nameYear where vinn is not null and wid is not null)
	,b as (select distinct(wid) from a where iRank = 1)
	update c set isVinnWid = 1
		from nameYear c
			join b on c.wid = b.wid;
			
	with
	 a as (select wid, wineNameN, isNameWid, vintage, rank() over (partition by wid order by vintage desc, wineNameN) iRank from nameYear where wid is not null and wineNameN is not null)
	,b as (select distinct(wineNameN) from a where iRank = 1)
	update c set isNameWid = 1
		from nameYear c
			join b on c.wineNameN = b.wineNameN;
  
	with
	 a as (select wid, vinn, iswidvinn, vintage, rank() over (partition by wid order by vintage desc, vinn) iRank from nameYear where wid is not null and vinn is not null)
	,b as (select distinct(vinn) from a where iRank = 1)
	update c set isWidVinn = 1
		from nameYear c
			join b on c.vinn = b.vinn;
 
	 with
	 a as (select wineNameN, vinn, isNameVinn, vintage, rank() over (partition by wineNameN order by vintage desc, wid) iRank from nameYear where wineNameN is not null and vinn is not null)
	,b as (select distinct(vinn) from a where iRank = 1)
	update c set isNameVinn = 1
		from nameYear c
			join b on c.vinn = b.vinn;
	
	 with
	 a as (select wineNameN, wid, isNamewid, vintage, rank() over (partition by wineNameN order by vintage desc, wid) iRank from nameYear where wineNameN is not null and wid is not null)
	,b as (select distinct(wid) from a where iRank = 1)
	update c set isNamewid = 1
		from nameYear c
			join b on c.wid = b.wid;
	
 
 
 
end
