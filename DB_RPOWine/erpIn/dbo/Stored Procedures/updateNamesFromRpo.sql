CREATE proc updateNamesFromRpo as begin
/*
RESTORE DATABASE [erp] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL10.SQLDOUGVISTA64\MSSQL\repldata\erp 19 addwine2 fixed' WITH  FILE = 1,  NOUNLOAD,  STATS = 10
GO
RESTORE DATABASE [erpIn] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL10.SQLDOUGVISTA64\MSSQL\Backup\erpInX.bak' WITH  FILE = 1,  NOUNLOAD,  STATS = 10
GO
USE erpIn
drop view vRpoWine 
create view vWineFromRpo as select * from rpoWinedata..wine
 
 
upda
 
*/
--updateJulianPrices28
set noCount on
 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---0.     Backup disable indexes
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
--BACKUP Database ERPIN;
--use erpin
truncate table erpIn.dbo.nameYearRaw;
truncate table erpIn.dbo.nameYear;
 
DBCC SHRINKDATABASE(N'erpIn' )
 
declare @date smallDateTime = getDate();
  
insert into nameYearRaw(phase, wineN, vinN, fixedId, producer, producerShow, labelName,vintage,country, region, location, locale, [site], variety, colorClass, dryness, wineType,dateCreated, dateTasted, dateUpdated)
	select 'b', wineN, vinN, fixedId
		,dbo.normalizeName(producer),dbo.normalizeName(producerShow),dbo.normalizeName(labelName),dbo.normalizeName(vintage),dbo.normalizeName(country),dbo.normalizeName(region),dbo.normalizeName(location),dbo.normalizeName(locale),dbo.normalizeName([site]),dbo.normalizeName(variety),dbo.normalizeName(colorClass),dbo.normalizeName(dryness),dbo.normalizeName(wineType)
		, SourceDate, tasteDate, @date
	from vWineFromRpo
	order by producer,wineN,tasteDate desc, fixedId;
 
update nameYearRaw
	set 
		  joinX = dbo.getJoinX(Producer, labelName, colorClass, country, region, location, locale, site, variety, wineType, dryness);
 
 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--4.     Get Unique Entries
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--truncate table nameYear;
--declare @maxVinn int = 2000000, @vinnTimes int = 1000, @vinnPlus int = 100000000,@date smallDateTime = getDate();
truncate table nameYear;
insert	 nameYear(wineN,vinN,wid,producer,labelName,vintage,country,region,location,locale,site,variety,colorClass,dryness,wineType, joinX, dateTasted)
select wineN,max(vinN),max(wid), producer,labelName,vintage,country,region,location,locale,site,variety,colorClass,dryness,wineType, joinX, max(dateTasted)
	from  nameYearRaw
	--group by wineN,vinN,wid,producer,labelName,vintage,country,region,location,locale,site,variety,colorClass,dryness,wineType
	group by wineN,joinX,producer,labelName,vintage,country,region,location,locale,site,variety,colorClass,dryness,wineType
	order by joinX,wineN,vintage
	
/*
create view vNameYear_a as
with
a as (     select distinct(wineN) from nameYear except select distinct(wineN) from erp..wine     )
,b as (     select c.* from nameyear c join a on a.wineN=c.wineN     )
,c as (     select row_number() over (partition by wineN order by dateTasted desc)ii, * from b     )
select * from c where ii=1
*/
 
 
 
 
--use erpin
declare i cursor for select WineN,Vinn,vintage,producer,labelName,colorClass,variety,dryness,wineType,country,locale,location,region,site from vNameYear_a
					order by country, producer, labelName, vintage, idn
declare		
		  @forceWineN int=null, @forceVinn int=null, @vintage varchar(4) , @producer nvarchar(100)
		, @labelName nvarchar(150), @colorClass nvarchar(20), @variety nvarchar(100), @dryness nvarchar(500), @wineType nvarchar(500)
		, @country nvarchar(100), @locale nvarchar(100), @location nvarchar(100), @region nvarchar(100), @site nvarchar(100)
		, @joinX nvarchar(2000), @namerWhN int, @wineNout int
 
open i
while 1=1
	begin
		fetch next from i into @forceWineN,@forceVinn,@vintage,@producer,@labelName,@colorClass,@variety,@dryness,@wineType,@country,@locale,@location,@region,@site 
		if @@fetch_status <> 0 break
		exec erp.dbo.addWine2 
					@forceWineN,@forceVinn,@vintage,@producer,@labelName,@colorClass,@variety,@dryness,@wineType,@country
					,@locale,@location,@region,@site, null
					,@namerWhN, null
	end
close i
deallocate i
 
--select count(*) from vNameYear_a
 
 
 
------------------------------------------------------------------------------------------------------------------------------
-- Add in missine wineNameN
------------------------------------------------------------------------------------------------------------------------------
/*
create view vNameYear_b as
with
a as (     select distinct joinx from nameYear except select distinct joinx from erp..wineName     )
,b as (    select row_number() over (partition by joinX order by idN)ii, *     from nameYear     )
,c as (     select b.* from b join a on a.joinX=b.joinX where ii=1     )
select * from c
*/
 
 
 
declare i2 cursor for select Vinn,producer,labelName,colorClass,variety,dryness,wineType,country,region, location, locale, site,joinX from vNameYear_b
					--Never copletes if we have this => Order by country, producer, labelName, vintage, idn
 
open i2
while 1=1
	begin
		fetch next from i2 into @forceVinn, @producer,@labelName,@colorClass,@variety,@dryness,@wineType,@country, @region,@location,@locale,@site,@joinX
		--print 'OK'
		--break
		if @@fetch_status <> 0 break
		
		exec erp.dbo.insertIntoWineName null,@producer,@labelName,@colorClass,@variety,@dryness,@wineType
					,@country, @region,@location,@locale,@site
					,@namerWhN, @joinX, null
	end
close i2	     
deallocate i2
 


------------------------------------------------------------------------------------------------------------------------------
-- Update WineNameN
------------------------------------------------------------------------------------------------------------------------------
update a set a.wineNameN=b.wineNameN
	from tastingNew a
		join erp..wine b
			on a.wineN=b.wineN
	where a.wineNameN <> b.wineNameN or (a.wineNameN is null and b.wineNameN is not null) or (a.wineNameN is not null and b.wineNameN is null)



/*
select count(*) from vnameyear_a 
select count(*) from vnameyear_b
*/ 
 
end
 
 
 
 
 
 
