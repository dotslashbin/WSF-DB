--coding reference          [=]
CREATE procedure mem as begin set nocount on /*
 
--107220 pavie 2006 rated 96

-- alter table xxxxxxxx add createDate smalldatetime NULL CONSTRAINT DF_xxxxxxxx_createDate  DEFAULT (getdate())
-- alter table xxxxxxxx add isPub bit NULL CONSTRAINT DF_xxxxxxxx_isPub  DEFAULT ((0))
 
-- snap timestamp for RowVersion
	exec snapRowVersion
	exec snapRowVersion getWhN ('dwf')
 
-- rename
	sp_rename [ @objname = ] 'object_name' , [ @newname = ] 'new_name' [ , [ @objtype = ] 'object_type' ] 
 
 
--schema binding
	with schemaBinding
 
--category lister
	oodef ooCategories 
 
--stringreplace
	replace (target, findThis, replaceWithThis)
 
--string search
	charIndex (findThis, target [,startPosition])
 
--default
	alter table wh add isView bit not null constraint df_wh_isView default (0)
 
--define primary key constraint at table definition
	create table mapPriceGToWine(priceGN int, wineN int, vinN int, wineNameN int, constraint PK_mapPriceGToWine primary key clustered(priceGN, wineN))
 
--show indexes
	def sp_helpindex
 
 
-- Cursor
Declare xcursor Cursor For Select SaleN, BuyerWhoN, WineN, BottleCount, TotalPrice from Sales order by saleDate
Declare @iTotalBottles int, @iSale int, @s varchar(999), @Description varChar(999), @count int
open xcursor
while true
		if @@fetch_status <> 0 break
		fetch next from xcursor into @SaleN, @BuyerWhoN, @wineN, @BottleCount, @TotalPrice
loop
 
---------------------------------------------------------------------------------------------------------------
--vbc /target:library wineMaint1.vb
 
use erp
drop function DeduceSourceDate
drop function combineLocations
drop function combinePlaces
drop function computeMaturity
drop function dropParenNote
drop function convertSurname
drop function utilRegexMatch
 
drop assembly wineMaint1
 
go
--CREATE ASSEMBLY wineMaint1 from 'c:\Documents and Settings\Doug\My Documents\Visual Studio 2005\Projects\SQLUtil\SQLUtil\wineMaint1.dll' WITH PERMISSION_SET = SAFE;
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
---------------------------------------------------------------------------------------------------------------
drop aggregate Concatenate
drop assembly Hello1Cls1
 
CREATE ASSEMBLY Hello1Cls1 from 'c:\Documents and Settings\Doug\My Documents\Visual Studio 2005\Projects\SQLUtil\SQLUtil\Hello1Cls1.dll' WITH PERMISSION_SET = SAFE;
go
CREATE AGGREGATE Concatenate (@input nvarchar(200)) RETURNS nvarchar(max) EXTERNAL NAME hello1Cls1.Concatenate;
go
---------------------------------------------------------------------------------------------------------------
 
--cd c:\Documents and Settings\Doug\My Documents\Visual Studio 2005\Projects\SQLUtil\SQLUtil\
cd c:\Documents and Settings\Doug\My Documents\Visual Studio 2008\Projects\SQLUtil\SQLUtil\ 
 
--vbc /target:library wineMaint1.vb
 
c:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\vbc /target:library wineMaint1.vb
 
CREATE ASSEMBLY wineMaint1 from 'c:\Documents and Settings\Doug\My Documents\Visual Studio 2005\Projects\SQLUtil\SQLUtil\wineMaint1.dll' WITH PERMISSION_SET = SAFE
 
CREATE FUNCTION DeduceSourceDate(@notes text) RETURNS text AS EXTERNAL NAME wineMaint1.WineMaint1.DeduceSourceDate
---------------------------------------------------------------------------------------------------------------
 
 
 
*/end
 
 
 
 
 
