create proc updateNov_before1011Nov26 as begin
/*
RESTORE DATABASE [erpIn] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL10.SQLDOUGVISTA64\MSSQL\Backup\erpInX.bak' WITH  FILE = 1,  NOUNLOAD,  STATS = 10
GO
USE erpIn
alter view vWineErp as select * from rpoWinedata..wine
*/
--updateJulianPrices28
set noCount on
 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---0.     Backup disable indexes
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
--BACKUP Database ERPIN;
--use erpin
truncate table erpIn.dbo.nameYearRaw;
truncate table erpIn.dbo.nameYearNorm;
truncate table erpIn.dbo.nameYear;
 
DBCC SHRINKDATABASE(N'erpIn' )
 
declare @date smallDateTime = getDate();
  
insert into nameYearRaw(phase, wineN, vinN, fixedId, producer, producerShow, labelName,vintage,country, region, location, locale, [site], variety, colorClass, dryness, wineType,dateCreated, dateUpdated)
	select 'b', wineN, vinN, fixedId, producer, producerShow, labelName,vintage,country, region, location, locale, [site], variety, colorClass, dryness, wineType, SourceDate, @date
	from vWineErp
	order by fixedId;
 
 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--3.     Normalize names
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--declare @maxVinn int = 2000000, @vinnTimes int = 1000, @vinnPlus int = 100000000,@date smallDateTime = getDate();
set identity_Insert nameYearNorm on 
insert into nameYearNorm(idn,wineN,vinN,wid,producer,producerShow,labelName,vintage,country,region,location,locale,site,variety,colorClass,dryness,wineType,dateCreated,dateUpdated,whoUpdated,fixedId)
select idn,wineN,vinN,wid,producer,producerShow,labelName,vintage,country,region,location,locale,site,variety,colorClass,dryness,wineType,@date, @date,whoUpdated,fixedId
	from nameYearRaw
	order by idN
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
--truncate table nameYear;
--declare @maxVinn int = 2000000, @vinnTimes int = 1000, @vinnPlus int = 100000000,@date smallDateTime = getDate();
truncate table nameYear;
insert	 nameYear(wineN,vinN,wid,producer,labelName,vintage,country,region,location,locale,site,variety,colorClass,dryness,wineType)
select wineN,max(vinN),max(wid), producer,labelName,vintage,country,region,location,locale,site,variety,colorClass,dryness,wineType
	from  nameYearNorm 
	--group by wineN,vinN,wid,producer,labelName,vintage,country,region,location,locale,site,variety,colorClass,dryness,wineType
	group by wineN,producer,labelName,vintage,country,region,location,locale,site,variety,colorClass,dryness,wineType
	order by producer,labelName,country,region,location,locale,site,variety,colorClass,dryness,wineType,vintage
 
update nameYear 
	set 
		  joinX = dbo.getJoinX(Producer, labelName, colorClass, country, region, location, locale, site, variety, wineType, dryness);
 
/*
with
a as (select distinct(wineN) from nameYear except select distinct(wineN) from erp..wine)
select count(*) cntNew from a

select winen, count(*) cnt from nameyear group by winen order by cnt desc
winen	cnt
71430	5
oodef cursorExample

CREATE proc [dbo].[cursorExample]
as begin
 
declare @wineN int;
declare i cursor for select wineN from (select distinct wineN from nameyear except select distinct wineN from vWineErp)a;
open i
while 1=1
	begin
		fetch next from i into @wineN
		if @@fetch_status <> 0 break
		--xxxx
	end
close i
deallocate i

 







*/
end
 
