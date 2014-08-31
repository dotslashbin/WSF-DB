----------------------------------------------------------------------------------------------------
--Assembly
----------------------------------------------------------------------------------------------------
-- build / compile the util clr assembly [=]
CREATE proc [dbo].[memBuildClrAssemblyVBConcatSnug] as begin set noCount on 
 

---------------------------------------------------------------------------------------------------------------
CREATE ASSEMBLY myWineClr from 'c:\ClrDll\myWinesClr.dll' WITH PERMISSION_SET = SAFE;
CREATE AGGREGATE ConcatForLocation (@input nvarchar(200)) RETURNS nvarchar(max) EXTERNAL NAME myWineClr.ConcatForLocation;
---------------------------------------------------------------------------------------------------------------


 
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
*/ 
 
