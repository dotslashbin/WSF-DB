----------------------------------------------------------------------------------------------------
--Assembly
----------------------------------------------------------------------------------------------------
-- build / compile the util clr assembly [=]
CREATE proc memBuildClrAssemblyVBMyWinesConcatFFSummarizeLocation as begin set noCount on 
 
 
/*
---------------------------------------------------------------------------------------------------------------
On Don Ruso using visual studio project
---------------------------------------------------------------------------------------------------------------

--in DOS window
cd C:\Documents and Settings\doug\My Documents\Visual Studio 2008\Projects\MyWinesClrProj\MyWinesClrProj
c:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\vbc /target:library myWinesClr2.vb

--In SQL
CREATE ASSEMBLY myWinesClr2 from 'C:\Documents and Settings\doug\My Documents\Visual Studio 2008\Projects\MyWinesClrProj\MyWinesClrProj\myWinesClr2.dll' WITH PERMISSION_SET = SAFE;
Create function compactLocationSummary2(@a nvarchar(max)) RETURNS nvarchar(max) EXTERNAL NAME  myWinesClr2.locationSummaryClass2.compactLocationSummary;

ALTER ASSEMBLY myWinesClr2 from 'C:\Documents and Settings\doug\My Documents\Visual Studio 2008\Projects\MyWinesClrProj\MyWinesClrProj\myWinesClr2.dll' WITH PERMISSION_SET = SAFE;
ALTER ASSEMBLY myWinesClr from 'C:\Documents and Settings\doug\My Documents\Visual Studio 2008\Projects\MyWinesClrProj\MyWinesClrProj\myWinesClr.dll' WITH PERMISSION_SET = SAFE;
---------------------------------------------------------------------------------------------------------------
(other)
---------------------------------------------------------------------------------------------------------------

oofr


cd c:\Documents and Settings\Doug\My Documents\Visual Studio 2008\Projects\SQLUtil\SQLUtil\
c:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\vbc /target:library concatSnug.vb



CREATE ASSEMBLY myWinesClr from 'c:\ClrDll\myWinesClr.dll' WITH PERMISSION_SET = SAFE;
Go
CREATE AGGREGATE concatFF (@input nvarchar(200)) RETURNS nvarchar(max) EXTERNAL NAME myWinesClr.concatFF;
Go
Create function compactLocationSummary(@a nvarchar(max)) RETURNS nvarchar(max) EXTERNAL NAME  myWinesClr.locationSummaryClass.compactLocationSummary;
Go
 
--on DonRuso
CREATE ASSEMBLY myWinesClr from 'D:\PROJECTS\MyWinesVB\\myWinesClr.dll' WITH PERMISSION_SET = SAFE;
CREATE ASSEMBLY myWinesClr from 'D:\PROJECTS\MyWinesVB\\myWinesClr2.dll' WITH PERMISSION_SET = SAFE;
 
 
use erp
--ALTER ASSEMBLY myWinesClr from 'c:\ClrDll\myWinesClr.dll' WITH PERMISSION_SET = SAFE;
ALTER ASSEMBLY myWinesClr from 'D:\PROJECTS\MyWinesVB\myWinesClr2.dll' WITH PERMISSION_SET = SAFE;
 
 
select dbo.compactLocationSummary('12foo')
 
drop function compactLocationSummary
drop aggregate ConcatFF
drop assembly myWinesClr
 
 
 
 
 
*/---------------------------------------------------------------------------------------------------------------
 
 
 
---------------------------------------------------------------------------------------------------------------
/* COMPILE
cd c:\Documents and Settings\Doug\My Documents\Visual Studio 2008\Projects\SQLUtil\SQLUtil\
c:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\vbc /target:library concatSnug.vb
*/
---------------------------------------------------------------------------------------------------------------
/*
--vbc /target:library concatSnug.vb
 
use erp
 
drop aggregate ConcatSnug 
drop assembly concatSnug
 
go
--ALTER ASSEMBLY concatSnug from 'c:\ClrDll\concatSnug.dll' WITH PERMISSION_SET = SAFE;
--select country, dbo.concatSnug(region) from winename group by country
declare @s varchar(max)
select @s = dbo.concatSnug(region) from winename where country = 'Australia' group by country
print @s
 
select dbo.concatSnug(region) from winename where country = 'Australia' group by country
 
 
--CREATE ASSEMBLY concatSnug from 'c:\Documents and Settings\Doug\My Documents\Visual Studio 2008\Projects\SQLUtil\SQLUtil\concatSnug.dll' WITH PERMISSION_SET = SAFE;
CREATE ASSEMBLY concatSnug from 'c:\ClrDll\concatSnug.dll' WITH PERMISSION_SET = SAFE;
 
 
go
           C:\ClrDll\concatSnug.dll
---------------------------------------------------------------------------------------------------------------
--drop aggregate ConcatSnug
go 
--CREATE AGGREGATE ConcatSnug (@input nvarchar(200)) RETURNS nvarchar(max) EXTERNAL NAME concatSnug.Concat;
CREATE AGGREGATE ConcatSnug (@input nvarchar(200)) RETURNS nvarchar(max) EXTERNAL NAME concatSnug.ConcatSnug;
 
 
 
 
 
 
 
*/
exec oodef memBuildClrAssemblyVBConcatSnug
end

/*
with a as (select top 25 * from wineName) 
select country, dbo.concatSnug(region) from a group by country
 
select country, dbo.concatSnug(region) from winename group by country
 
select country, dbo.concat(region) from winename group by country
select country, len(dbo.concatSnug(region)) from winename group by country
 
select country, len(dbo.concatSnug(region)) from winename where country not in ('france', 'australia') group by country
select country, len(dbo.concatSnug(region)) from winename where country in ('france') group by country
 
 
      select 37+1326+1914+1913+1198
 
 
---------------------------------------------------------------------------------------
-- Parallel Assembly
---------------------------------------------------------------------------------------
CREATE AGGREGATE concatFF (@input nvarchar(200)) RETURNS nvarchar(max) EXTERNAL NAME myWinesClr.concatFF;
Go
Create function compactLocationSummary(@a nvarchar(max)) RETURNS nvarchar(max) EXTERNAL NAME  myWinesClr.locationSummaryClass.compactLocationSummary;
Go
 
--on DonRuso after adding local VB studio project

--on DonRuso
CREATE ASSEMBLY myWinesClr2 from 'D:\PROJECTS\MyWinesVB\myWinesClr2.dll' WITH PERMISSION_SET = SAFE;
Drop Assembly myWinesClr2
 
 
use erp
--ALTER ASSEMBLY myWinesClr from 'c:\ClrDll\myWinesClr.dll' WITH PERMISSION_SET = SAFE;
ALTER ASSEMBLY myWinesClr from 'D:\PROJECTS\MyWinesVB\\myWinesClr.dll' WITH PERMISSION_SET = SAFE;
ALTER ASSEMBLY myWinesClr from 'D:\PROJECTS\MyWinesVB\\myWinesClr2.dll' WITH PERMISSION_SET = SAFE;
 
 
 
 
oofr
use erp
summarizeBottleLocations 20, null
update whToWine set bottleLocations = null where whN=20 and wineN =  59866
select whN, wineN, bottleLocations from whtowine where whN=20 and wineN =  59866
 
 
 
summarizeBottleLocations 19, null
select bottleLocations from whtowine where whN = 19
 
select locationN, name from location where name like '%col%'
 
27361
 
select * from whtowine where whn=20 and bottleLocations like '%col*a%'
 
*/
