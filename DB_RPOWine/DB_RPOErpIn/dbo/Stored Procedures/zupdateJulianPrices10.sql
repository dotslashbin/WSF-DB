--use erpin
CREATE proc [zupdateJulianPrices10] as begin
--alter proc temp as begin
--temp
	-- after sql restart: 9:55
	-- immediate rerun no restart	: under 2 min
	-- immediate rerun no restart	: under 10:73
	-- immediate rerun no restart	: under 1:42 min
	-- after 3 week delay (probably with a sql restart)           13 min not finished
	-- after sql restart: 1:58
	-- after reboot - finished successfully but no time shown
	-- very fast, 1:44
/*
----ACTIVE
begin try drop view vAlert end try  begin catch end catch
begin try drop view vAlertOK end try  begin catch end catch
begin try drop view vForSale end try begin catch end catch
begin try drop view vForSaleOK end try begin catch end catch
go
create view vAlert as (select [winealert id]wid, * from waWineAlertDatabase)
go
create view vForSale as (select [winealert id]wid, * from waForSale)
go
create view vAlertOK as (select * from vAlert where errors is null)
go
create view vForSaleOK as (select * from vForSale where errors is null)
*/

set noCount on
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---0.     Backup disable indexes
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--BACKUP Database ERPIN;
truncate table erpIn.dbo.nameYearRaw;
truncate table erpIn.dbo.nameYearNorm;
truncate table erpIn.dbo.nameYear;
/*
oon nameYearRaw2
*/

DBCC SHRINKDATABASE(N'erpIn' )

 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---a     Fill in vinn2, producer2, producerShow2
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

declare @maxVinn int = 2000000, @vinnTimes int = 1000, @vinnPlus int = 100000000,@date smallDateTime = getDate();
 
update vAlert set errors = null, warnings = null, vinn2 = null, producer2 = null, producerShow2 = null
update vForSale set errors = null, warnings = null
 
 
update vAlert set errors = isNull(errors + ';  ', '') + '[E01]  Vinn not numeric' where vinn is not null and isNumeric(vinn) = 0;
update vAlertOK set vinn2 = convert(int, vinn) where errors is null;
 
update a set errors = isNull(errors + ';  ', '') + '[E05]  WineAlert Id not in WineAlert Database'
	from (select *  from vForSale where wid is not null) a
		left join (select wid from vAlert where wid is not null) b
			on a.wid = b.wid
	where
		b.wid is null
		
--normalize vForSale vintage
update vForSale set vintage = 'N.V.' where vintage like '%N%V%';
 
with
a as (select * from vForSale where wineN is not null and vintage is not null)
update a set errors = isNull(errors + ';  ', '') + '[E06]  erp wineN Vintage <> ForSale vintage'
	from a
		join erpWine b
			on a.wineN = b.wineN
	where a.vintage <> b.vintage;
 
 
--aa     set vinn2 to the eRP vinn for the most recent vintage for this wid
--     fill in vinn2 from the most recent forSale vintage that has a wineN
--     shouldn't be here)update vAlert set vinn2 = null, producer2 = null, producerShow2 = null;
with 
 a as (select wid, vinn2 from vAlertOK where vinn2 is null) 
,b as (select wid, wineN, row_number() over(partition by wid order by vintage desc, id)ii from vForSaleOK where wineN is not null) 
,c as (select wid, wineN from b where ii = 1)
,d as	(select wid, vinn
		from c
			join erpWine e
				on c.wineN = e.wineN
)update a set vinn2 = vinn
	from a
		join d
			on a.wid = d.wid
 
 --aaa     set producer2 and producerShow2 to erp producer when there is a vinn
update a set a.producer2 = b.producer, a.producerShow2 = b.producerShow
	from vAlertOK a
		join (select vinn, producer, producerShow, row_number() over(partition by vinn order by producer)ii from erpWine)b
			on a.vinn2 = b.vinn and b.ii = 1
			
--aab     translate other wines with same wid producer
update a set a.producer2 = b.producer2, a.producerShow2 = b.producerShow2
	from vAlertOK a
		join (select row_number() over (partition by prod order by producer2)ii, prod, producer2, producerShow2 from vAlertOK where vinn2 is not null) b
			on a.prod = b.prod and b.ii=1
	where
		a.producer2 is null; 
 
--aac.     fill in the remaining ones from vAlertOK
update vAlertOK set producer2 = replace(prod, '"', ''),producerShow2 = replace(prodShow, '"', '') where producer2 is null
 
 
 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ab>.     Create new non-erp Vinns for wid mapping
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--aba.		make sure we have all the vinns already in use from erpWine and vAlert
--     truncate table allocateWidVinn	
merge allocateWidVinn as aa
	using	(select max(vinn)vinn, wid from vAlertOK where vinn is not null group by wid) as bb
on aa.wid = bb.wid
when matched then
	update set aa.vinn = bb.vinn
when not matched by target then
	insert  (wid, vinn, isAuto)
		values(bb.wid, bb.vinn, 1);

merge allocateWidVinn as aa
	using	(select vinn from erpWine group by vinn)bb
	on aa.vinn = bb.vinn
when matched then
	update set aa.isAuto = 0;
 
--abb.     create vinn's from 2 milllion down.  
declare @maxRealVinn int = (select max(vinn) from allocateWidVinn where isAuto = 0);
declare @minAutoVinn int = (select min(vinn) from  allocateWidVinn where vinn > @maxRealVinn and isAuto <> 0);
set @minAutoVinn = isNull(@minAutoVinn, 2000000);
--     print  @minAutoVinn
with
a as (select a.wid, row_number() over(order by a.wid)ii
	from (select distinct wid from vAlertOK) a 
		left join allocateWidVinn b
			on a.wid = b.wid
	where a.wid like '%[!a-b0-9]%'and b.wid is null)
insert into allocateWidVinn(wid, vinn, isAuto) 
	select wid,@minAutoVinn-ii,1 from a;     
 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--b>.     Update Raw Tables
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--b>     Update nameYearRaw 
--ba>     Add in all current eRP wines
--baa>     Analyze Errors
--bab>     Update Vinn2 from allocateVinn
--bb>.     Add succesive goups of wine to nameYear
--bba>    add in erpFields for forSale items with wineN	
--bbb>     add in erp wine where wineN can be uniquely deduced from erpWine through wid=>vinn, vintage
--bbc>     add in erpFields where there is wid=>vinn but no wineN can be deduced.  use vinn, create a wineN     ACTIVE
--bbda>.    add in vAlertOK for forSale items with no vinn.  but there is a valid erp producer.   use newly created vinn then create a wineN
--bbdb>.    add in vAlertOK for forSale items with no vinn.  but there is a no valid erp producer.   use newly created vinn then create a wineN
--bbe>     add in erpFields for vAlertOK not already in nameyear
--bbf>     ?? add in wine alert db not currently for sale


--     truncate table nameYearRaw;

---     declare @date smallDateTime = getDate()
--ba>     Add in all current eRP wines
insert into nameYearRaw(phase, wineN, vinN, fixedId, producer, producerShow, labelName,vintage,country, region, location, locale, [site], variety, colorClass, dryness, wineType,dateCreated, dateUpdated)
	select 'b', wineN, vinN, fixedId, producer, producerShow, labelName,vintage,country, region, location, locale, [site], variety, colorClass, dryness, wineType, SourceDate, @date
	from erpWine
	order by fixedId;
 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--baa>     Analyze Errors		         
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
with 
a as (select distinct vinn from erpWine where vinn is not null)
,b as (select * from vAlert where wid is not null and errors is null)
update b set b.errors = isNull(errors + ';  ', '') + '[E02]  Vinn not in erpWine'
	from b
		left join a
			on a.vinn = b.vinn2
		--where b.vinn2 is not null and a.vinn is null and b.errors is null;
		where b.vinn2 is null ;
 
update vForSale set errors = isNull(errors, ';  ') + '[E03]  WineN is not numeric' where wineN is not null and isNumeric(wineN) = 0;
 
with a as	(select distinct wineN from erpWine)
update b set b.errors = isNull(errors + ';  ', '') + '[E04]  WineN not in erpWine'
	from vForSale b
		left join a
			on a.wineN = b.wineN
		where b.wineN is not null and a.wineN is null and b.errors is null;
 		
with 
a as (select wineN, min(vinn)vinn from erpWIne group by wineN)
, b as (select * from vForSaleOK where errors is null)
, c as (select * from vAlertOK where errors is null)
update b set b.warnings = isNull(b.warnings + ';  ', '') + '[W01]  Vinn from WneN <> Vinn from WineAlertID'
	from b
		join a
			on a.wineN = b.wineN
		join c
			on b.wid = c.wid
	where a.vinn <> c.vinn2;
 
 
--bab>.     Update Vinn2 from allocateVinn
merge vAlertOK as aa
	using allocateWidVinn bb
on aa.wid = bb.wid
when matched then
	update  set aa.vinn2=bb.vinn;
			
---     select count(*) from nameYearRaw
---          145935
---     select count(*) from allocateWidVinn
---          77583
 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--bb>.     Add succesive goups of wine to nameYear
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--bba>.    add in erpFields for forSale items with wineN	
--bbb>.    add in erp wine where wineN can be deduced from erpWine through wid=>vinn, vintage
--bbc>     add in erpFields where there is wid=>vinn but no wineN can be deduced.  use vinn, create a wineN
--bbd>.    add in vAlertOK for forSale items with no vinn.  use newly created vinn then create a wineN
--bbe>     add in erpFields for vAlertOK not already in nameyear

--bba>.    add in erpFields for forSale items with wineN	

--     declare @date smallDateTime = getDate();

insert into fforSale(wid, vintage, wineN,  phase)
	select wid, vintage, wineN, null
		from vForSaleOK
		group by wid, vintage, wineN;
	

with
b as (select *, row_number() over(partition by wineN order by fixedId)ii from erpWine)
insert into nameYearRaw(phase, wineN, vinn, wid, producer, producerShow, labelName,vintage,country, region, location, variety, colorClass, dryness, wineType,dateCreated, dateUpdated)
	select 'bba>', a.wineN, b.vinn,  a.wid, producer, producerShow, labelName, b.vintage, country, region, location, variety, colorClass, dryness, wineType, null, @date
	from fforSale a
		join b 
			on b.wineN = a.wineN and b.ii=1
		where phase is null;
		
update a set a.phase = b.phase
	from fforsale a
		join (select wid, vintage, max(phase) phase from nameYearRaw where phase is not null group by wid, vintage) b
			on a.wid=b.wid and a.vintage=b.vintage
	where a.phase is null;

			

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 --bbb>.     add in erp wine where wineN can be uniquely deduced from erpWine through wid=>vinn, vintage
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---     declare @date smallDateTime = getDate();
 
--     find case from erpWine where there is unique vintage,wid
--     declare @date smallDateTime = getDate();
with 
e as (select a.wid, a.vintage, d.vinn, d.wineN
	from fforSale a
		join vAlertOK b
			on a.wid = b.wid
		join erpWine d
			on d.vinn = b.vinn2 and d.vintage = a.vintage
		where a.phase is null     )
,f as (select wid, vintage,wineN, vinn from e
	group by wid, vintage, wineN, vinn)
,g as (select wid,vintage, max(wineN) wineN, max(vinn) vinn
	from f
	group by wid, vintage
	having count(*) = 1)
,h as (select *, row_number() over(partition by wineN order by fixedId)ii from erpWine)
insert into nameYearRaw(phase, wineN, vinn, wid, producer, producerShow, labelName,vintage,country, region, location, variety, colorClass, dryness, wineType,dateCreated, dateUpdated)
	select 'bbb>', g.wineN, g.vinn,  g.wid, producer, producerShow, labelName, g.vintage, country, region, location, variety, colorClass, dryness, wineType, null, @date
	from g
		join h
			on g.wineN = h.wineN and h.ii = 1
---     (647 row(s) affected)

update a set a.phase = b.phase
	from fforsale a
		join (select wid, vintage, max(phase) phase from nameYearRaw where phase is not null group by wid, vintage) b
			on a.wid=b.wid and a.vintage=b.vintage
	where a.phase is null;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--bbc>     add in erpFields where there is wid=>vinn but no wineN can be deduced.  use vinn, create a wineN     ACTIVE
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--declare @maxVinn int = 2000000, @vinnTimes int = 1000, @vinnPlus int = 100000000,@date smallDateTime = getDate();
with
a as (select aa.wid, ab.vinn, aa.vintage, case when 1=isNumeric(aa.vintage) then cast(aa.vintage as int) - 1500 else 0 end vintageAsOffset 
	from fforSale aa
		join allocateWidVinn ab
			on aa.wid = ab.wid
	where phase is null     )
,b as (select row_number() over (partition by vinn order by vintage desc) ii, fixedId
	from erpWine     )
,c as (select ca.vinn, producer, producerShow, labelName, vintage, country, region, location, variety, colorClass, dryness, wineType
	from erpWine ca
		join b
			on ca.fixedId = b.fixedId
	where b.ii = 1     )
insert into nameYearRaw(phase, wineN, vinn, wid
		, producer, producerShow, labelName,vintage,country
		, region, location, variety, colorClass, dryness, wineType,dateCreated, dateUpdated)
	select 'bbc'
			,  (a. vinn * @vinnTimes + @vinnPlus + vintageAsOffset) wineN2
			, a.vinn,  a.wid, producer, producerShow, labelName, a.vintage, country, region, location, variety, colorClass, dryness, wineType, null, @date
		from a
			join c
				on a.vinn = c.vinn;
	
--bbda>.    add in vAlertOK for forSale items with no vinn.  but there is a valid erp producer.   use newly created vinn then create a wineN
begin try drop table nameYearRaw_afterbbc end try begin catch end catch
select * into nameYearRaw_afterbbc from nameYearRaw;

update a set a.phase = b.phase
	from fforsale a
		join (select wid, vintage, max(phase) phase from nameYearRaw where phase is not null group by wid, vintage) b
			on a.wid=b.wid and a.vintage=b.vintage
	where a.phase is null;









--bbdb>.    add in vAlertOK for forSale items with no vinn.  but there is a no valid erp producer.   use newly created vinn then create a wineN
--bbe>     add in erpFields for vAlertOK not already in nameyear
--bbf>     ?? add in wine alert db not currently for sale

		
		
		
		
		








/* old 0912Dec06
declare @date smallDateTime = getDate();
with
a as (select wid, vintage from fforSale2)
,b as (select wid, vinn, row_number() over(partition by wid order by id )ii from vAlertOK where errors is null)
,c as (select *, row_number() over(partition by vinn, vintage order by sourceDate desc)ii from erpWine)
insert into nameYearRaw(phase, wineN, vinn, wid, producer, producerShow, labelName,vintage,country, region, location, variety, colorClass, dryness, wineType,dateCreated, dateUpdated)
	select 'bbb>', c.wineN, c.vinn,  a.wid, producer, producerShow, labelName, a.vintage, country, region, location, variety, colorClass, dryness, wineType, null, @date
	from a
		join b
			on b.wid = a.wid and b.ii = 1
		join c
			on c.vinn = b.vinn and c.ii = 1;
		--order by wid, vintage;

select count(*) from nameYearRaw
select * from fforSale2;

*/
 
/* new left unfinished from 09Dec06
declare @date smallDateTime = getDate();
with
a as (select *, row_number() over (partition by vinn order by vintage desc, sourceDate desc) ii from erpWine)
,b as (select * from a where ii =1 )
,c as (select * from vAlertOK where vinn2 is not null)
insert into nameYearRaw(phase, wineN, vinn, wid, producer, producerShow, labelName,vintage,country, region, location, variety, colorClass, dryness, wineType,dateCreated, dateUpdated)
	select 'bbb>', c.wineN, c.vinn,  a.wid, producer, producerShow, labelName, a.vintage, country, region, location, variety, colorClass, dryness, wineType, null, @date
	from fforSale2 d
		join c
			on c.wid = d.wid
		join b
			on b.vinn = c.vinn2
*/ 
 
 
 
 
 
 
 
 
 
 
 
----select * from fforSale2 order by vintage desc
----select distinct warnings from vForSale
----select distinct warnings from vAlertOK
----select distinct vintage from vForSaleOK
 
----select count(*) from fforSale2
----select count(*) from fforSale3

 
 
--bbc>     add in erpFields where there is wid=>vinn but no wineN can be deduced.  use vinn, create a wineN
select a.* into fforSale3
	from fforSale2 a
		left join (select wid, vintage from nameYearRaw group by wid, vintage) b
			on a.wid = b.wid and a.vintage = b.vintage
	where
		b.wid is null and b.vintage is null;
with
a as (select wid, vintage from fforSale3 where wid is not null)
,b as (select * from (select wid, vinn, row_number() over(partition by wid order by id )ii from vAlertOK where vinn is not null and errors is null) b where b.ii = 1)
,c as (select * from (select *, row_number() over(partition by vinn order by sourceDate desc)ii from erpWine) c where c.ii = 1)
insert into nameYearRaw(phase, wineN, vinn, wid, producer, producerShow, labelName,vintage,country, region, location, variety, colorClass, dryness, wineType,dateCreated, dateUpdated)
	select 
		'bbc>'
		--Have to use same calculation that we would for get for wineForVintage--oofr vintage
		,erp.dbo.calcWineFromVinnVintage(b.vinn, a.vintage, 1)
		,b.vinn,  a.wid, producer, producerShow, labelName, a.vintage, country, region, location, variety, colorClass, dryness, wineType, null, @date
	from a
		join b
			on b.wid = a.wid
		join c
			on c.vinn = b.vinn;
	--order by wid, vintage
/*
with
a as (select wid, vintage from fforSale3 where wid is not null)
,b as (select * from (select wid, vinn, row_number() over(partition by wid order by id )ii from vAlertOK where vinn is not null and errors is null) b where b.ii = 1)
,c as (select * from (select *, row_number() over(partition by vinn order by sourceDate desc)ii from erpWine) c where c.ii = 1)
 
select count(*)
	from #a a
		join #b b
			on b.wid = a.wid
		join #c c
			on c.vinn = b.vinn
 
select * into #a from (select wid, vintage from fforSale3 where wid is not null) a
select * into #b from (select * from (select wid, vinn, row_number() over(partition by wid order by id )ii from vAlertOK where vinn is not null and errors is null) b where b.ii = 1)a
select * into #c from  (select * from (select *, row_number() over(partition by vinn order by sourceDate desc)ii from erpWine) c where c.ii = 1) a
 
select count(*) from #a
select count(*) from #b
select count(*) from #c
 
select * from #a a
	join (select * from vAlertOK where vinn is not null and errors is null) b
		on a.wid = b.wid
 
select * from fforSale4 where wid = 'al1153188'
 
select * from vAlertOK where wid = 'al1153188'
 
declare @date smallDateTime = getDate();
with
a as (select wid, vintage from fforSale4)
--,b as (select *, row_number() over(partition by wid order by id )ii from vAlertOK where errors is null)
,b as (select distinct(wid), 1 ii from vAlertOK where errors is null)
select count(*) 
	from a
		join b
			on b.wid = a.wid and b.ii = 1;
 
 
	select 
		'bbd>'
		--Have to use same calculation that we would for get for wineForVintage--oofr vintage
		,erp.dbo.calcWineFromVinnVintage(b.vinn2, a.vintage, 1)
		,b.vinn2,  a.wid, producer2, producerShow2, labelName, a.vintage, country, region, location, variety, colorClass, dryness, wineType, null, @date
	from a
		join b
			on b.wid = a.wid and b.ii = 1;
 
*/
 
 
--bbd>.    add in vAlertOK for forSale items with no vinn.  use newly created vinn then create a wineN
select a.* into fforSale4
	from fforSale3 a
		left join (select wid, vintage from nameYearRaw group by wid, vintage) b
			on a.wid = b.wid and a.vintage = b.vintage
	where
		b.wid is null and b.vintage is null;
 
with
a as (select wid, vintage from fforSale4)
,b as (select *, row_number() over(partition by wid order by id )ii from vAlertOK where errors is null)
insert into nameYearRaw(phase, wineN, vinn, wid, producer, producerShow, labelName,vintage,country, region, location, variety, colorClass, dryness, wineType,dateCreated, dateUpdated)
	select 
		'bbd>'
		--Have to use same calculation that we would for get for wineForVintage--oofr vintage
		,erp.dbo.calcWineFromVinnVintage(b.vinn2, a.vintage, 1)
		,b.vinn2,  a.wid, producer2, producerShow2, labelName, a.vintage, country, region, location, variety, colorClass, dryness, wineType, null, @date
	from a
		join b
			on b.wid = a.wid and b.ii = 1;
	--order by wid, vintage;
 
--bbe>.     add in erpFields for vAlertOK not already in nameyear
with
a as (select distinct(wid) from vAlertOK
	except
	select distinct(wid) from nameYear)
,b as (select *, row_number() over(partition by wid order by id )ii from vAlertOK where errors is null)
insert into nameYearRaw(phase, wineN, vinn, wid, producer, producerShow, labelName,vintage,country, region, location, variety, colorClass, dryness, wineType,dateCreated, dateUpdated)
	select 
		'bbe>'
		--Have to use same calculation that we would for get for wineForVintage--oofr vintage
		,erp.dbo.calcWineFromVinnVintage(b.vinn2, null, 1)
		,b.vinn2,  a.wid, producer2, producerShow2, labelName, null, country, region, location, variety, colorClass, dryness, wineType, null, @date
	from a
		join b
			on b.wid = a.wid and b.ii = 1
	order  by wid;
 
exec dbo.droptable 'fforSale'
exec dbo.droptable 'fforSale2'
exec dbo.droptable 'fforSale3'
exec dbo.droptable 'fforSale4'
 
 
 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--3.     Normalize names
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--delete from nameYearNorm
truncate table nameYearNorm;
 
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
--delete from nameYear;
truncate table nameYear;
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
 
/*
ooi idusage
	wid
	vinN
	wineN
	wineNameN
	vintage
	dateLo
	dateHi
	isOld
*/ 
 
merge idUsage as aa
	using	(select wid, vinn, wineN, wineNameN, vintage from nameYear group by wid, vinn, wineN, wineNameN, vintage
		) as bb
	--on aa.wid = bb.wid and aa.vinn=bb.vinn and aa.wineN = bb.wineN and aa.vintage = bb.vintage
		on isNull(aa.wid, '') = isNull(bb.wid, '') and isnull(aa.vinn,0)=isnull(bb.vinn,0) and isnull(aa.wineN, 0) = isnull(bb.wineN, 0) and isnull(aa.wineNameN,0) = isnull(bb.wineNameN,0) and isnull(aa.vintage, '') = isnull(bb.vintage, '')
when matched then
	update set aa.isOld = 0, dateLo = case when @date < dateLo then @date else dateLo end, dateHi = case when @date > dateHi then @date else dateHi end
when not matched by target then
	insert  (wid, vinn, wineN, wineNameN, vintage, dateLo, dateHi, isOld)
		values(bb.wid, bb.vinn, bb.wineN, bb.wineNameN, bb.vintage, @date, @date, 0)
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
