CREATE proc [dbo].[zupdateAll] as begin
set noCount on
  
--exec dbo.updateImportFromAccess
 
--create view waDb as (select [winealert id]wid, * from waWineAlertDatabase)
exec dbo.updateWineAlertVinn2
exec dbo.updateNameYearRaw
exec dbo.updateNameYearNorm
exec dbo.updateNameYearNonErp
exec dbo.updateNameYearUnique
exec dbo.updateNameYearActiveBits
set noCount off
end
/*
use erpin
[updateAll]


select isOld, dateHi, count(*) cnt from wineName group by isOld, dateHi

oodef updateNameYearNorm

ooi ' nameyear '
*/
 
