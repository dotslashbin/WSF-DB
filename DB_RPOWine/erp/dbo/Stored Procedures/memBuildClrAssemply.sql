-- build / compile the util clr assembly [=]
CREATE proc memBuildClrAssemply as begin set noCount on 
 
 
---------------------------------------------------------------------------------------------------------------
/* COMPILE
cd c:\Documents and Settings\Doug\My Documents\Visual Studio 2008\Projects\SQLUtil\SQLUtil\
c:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\vbc /target:library wineMaint1.vb
*/
---------------------------------------------------------------------------------------------------------------
/*
--vbc /target:library wineMaint1.vb
 
use erp
drop function DeduceSourceDate
drop function combineLocations
drop function combinePlaces
drop function computeMaturity
drop function dropParenNote
drop function convertSurname
drop function utilRegexMatch

drop aggregate Concat

drop function GetStrings
drop function GetWords
 
drop assembly wineMaint1
 
go
CREATE ASSEMBLY wineMaint1 from 'c:\Documents and Settings\Doug\My Documents\Visual Studio 2008\Projects\SQLUtil\SQLUtil\wineMaint1.dll' WITH PERMISSION_SET = SAFE;
go
CREATE FUNCTION DeduceSourceDate(@notes nvarchar(max)) RETURNS nvarchar(max) AS EXTERNAL NAME wineMaint1.WineMaint1.DeduceSourceDate
go
CREATE FUNCTION utilRegexMatch(@target nvarchar(max), @reg nvarchar(max), @regOptions int) RETURNS bit AS EXTERNAL NAME wineMaint1.WineMaint1.utilRegexMatch
go
CREATE FUNCTION combineLocations(
     @country nvarchar(max),@region nvarchar(max),@location nvarchar(max),@locale nvarchar(max),@site nvarchar(max))
     RETURNS nvarchar(max)
     AS EXTERNAL NAME wineMaint1.WineMaint1.combineLocations
go
CREATE FUNCTION computeMaturity(
     @drinkFrom as dateTime, @drinkTo as dateTime, @tastingDate as dateTime)
     RETURNS smallInt
	AS EXTERNAL NAME wineMaint1.WineMaint1.computeMaturity
go
CREATE FUNCTION combinePlaces(
     @region nvarchar(max),@location nvarchar(max),@locale nvarchar(max),@site nvarchar(max))
     RETURNS nvarchar(max)
     AS EXTERNAL NAME wineMaint1.WineMaint1.combinePlaces
go
CREATE FUNCTION dropParenNote(
     @s nvarchar(max))
     RETURNS nvarchar(max)
     AS EXTERNAL NAME wineMaint1.WineMaint1.dropParenNote
go
CREATE FUNCTION convertSurname(
     @s nvarchar(max))
     RETURNS nvarchar(max)
     AS EXTERNAL NAME wineMaint1.WineMaint1.convertSurname
go
--print dbo.dropparennote('outside parens(inside parens)')
 
---------------------------------------------------------------------------------------------------------------
--drop aggregate Concat
go 
CREATE AGGREGATE Concat (@input nvarchar(200)) RETURNS nvarchar(max) EXTERNAL NAME wineMaint1.Concat;
---------------------------------------------------------------------------------------------------------------
go
Create Function GetStrings(@s nvarchar(3000)) 
Returns Table (w nvarChar(3000))
AS EXTERNAL NAME wineMaint1.UserDefinedFunctions.GetStrings
---------------------------------------------------------------------------------------------------------------
go
Create Function GetWords(@s nvarchar(3000)) 
Returns Table (w nvarChar(3000))
AS EXTERNAL NAME wineMaint1.getWords.GetWords
---------------------------------------------------------------------------------------------------------------


 
USA  |  New Zealand  |  Italy  |  Netherlands  |  Germany  |  Cyprus  |  Algeria  |  Australia  |  Argentina  |  Hungary  |  Switzerland  |  Lebanon  |  Ukraine  |  Austria  |  UK  |  Canada  |  France  |  India  |  Greece  |  Israel  |  Uruguay  |  Slovenia  |  Morocco  |  Chile  |  Japan  |  Spain  |  Table  |  South Africa  |  Portugal  | 
/*
 
drop table #t
select country + '  (' + convert(varchar, count(*)) + ')' country into #t from winename group by country order by count(*) desc
select dbo.concat(country) from #t
France  (20985)  |  USA  (15693)  |  Italy  (6825)  |  Australia  (3118)  |  Spain  (2979)  |  Germany  (2854)  |  New Zealand  (1163)  |  Portugal  (984)  |  Austria  (890)  |  Chile  (511)  |  Argentina  (510)  |  South Africa  (455)  |  Israel  (137)  |  Greece  (55)  |  Japan  (48)  |  Hungary  (44)  |  Ukraine  (12)  |  Slovenia  (9)  |  Canada  (7)  |  Lebanon  (6)  |  Switzerland  (5)  |  India  (3)  |  Table  (3)  |  Uruguay  (2)  |  Cyprus  (2)  |  Algeria  (2)  |  UK  (1)  |  Netherlands  (1)  |  Morocco  (1)  | 
France  (20985)    USA  (15693)    Italy  (6825)    Australia  (3118)    Spain  (2979)    Germany  (2854)    New Zealand  (1163)    Portugal  (984)    Austria  (890)    Chile  (511)  |  Argentina  (510)  |  South Africa  (455)  |  Israel  (137)  |  Greece  (55)  |  Japan  (48)  |  Hungary  (44)  |  Ukraine  (12)  |  Slovenia  (9)  |  Canada  (7)  |  Lebanon  (6)  |  Switzerland  (5)  |  India  (3)  |  Table  (3)  |  Uruguay  (2)  |  Cyprus  (2)  |  Algeria  (2)  |  UK  (1)  |  Netherlands  (1)  |  Morocco  (1)  | 
 
 
 
print dbo.utilRegexMatch ('cat rat bat', 'r', '')
 
print dbo.utilRegexMatch ('   rat', '.*\b(cat|rat|bat).*', '')
 
 
 
 
 
 
 
 
 
 
/*
drop aggregate Concatenate
drop assembly Hello1Cls1
 
CREATE ASSEMBLY Hello1Cls1 from 'c:\Documents and Settings\Doug\My Documents\Visual Studio 2005\Projects\SQLUtil\SQLUtil\Hello1Cls1.dll' WITH PERMISSION_SET = SAFE;
go
CREATE AGGREGATE Concatenate (@input nvarchar(200)) RETURNS nvarchar(max) EXTERNAL NAME hello1Cls1.Concatenate;
go
*/
---------------------------------------------------------------------------------------------------------------
cd c:\Documents and Settings\Doug\My Documents\Visual Studio 2005\Projects\SQLUtil\SQLUtil\
c:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\vbc /target:library wineMaint1.vb
 
CREATE ASSEMBLY wineMaint1 from 'c:\Documents and Settings\Doug\My Documents\Visual Studio 2005\Projects\SQLUtil\SQLUtil\wineMaint1.dll' WITH PERMISSION_SET = SAFE
 
CREATE FUNCTION DeduceSourceDate(@notes text) RETURNS text AS EXTERNAL NAME wineMaint1.WineMaint1.DeduceSourceDate
---------------------------------------------------------------------------------------------------------------
 
 
 
 
 
 
 
 
with
a as (select top 200 producer from wine group by producer)
,b as (select dbo.concatenate(producer) aa from a)
select len(aa), aa from b
 
cols wine
 
drop table a#
with
a as (select variety, producer, labelName from wine group by variety, producer, labelName)
--select * from a order by variety, producer, labelName
,b as (select variety, producer, count(*) cnt from a group by variety, producer)
select variety, (producer + ' (' + cast(cnt as varchar) + ')') producer2 into a# from b order by variety, cnt desc, producer
 
select variety, dbo.concatenate(producer2) from a# group by variety order by count(producer2) desc
 
 
 
select source, IsBarrelTasting, count(*) cnt from wine group by source, IsBarrelTasting order by source, IsBarrelTasting
 
select source, CONVERT(nvarchar(30), sourceDate, 111) sourceDate, clumpName, isBarrelTasting, count(*) cnt from wine 
     where source like '%martin%'
     group by source, sourceDate, clumpName, isBarrelTasting order by source, sourceDate, clumpName, isBarrelTasting
 
 
select source, CONVERT(nvarchar, sourceDate, 111) sourceDate, clumpName, isBarrelTasting, count(*) cnt from wine 
     where source like '%martin%'
     group by source, sourceDate, clumpName, isBarrelTasting order by source, sourceDate, clumpName, isBarrelTasting
*/*/
exec oodef memBuildClrAssemply
end

