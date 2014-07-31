CREATE proc [dbo].[zupdateNameYearRaw] as begin 
 
delete from nameYearRaw;
update waForSale set errors = null, warnings = null
update waWineAlertDatabase set errors = null, warnings = null;
 
insert into nameYearRaw(wineN, vinN, fixedId, producer, producerShow, labelName,vintage,country, region, location, locale, [site], variety, colorClass, dryness, wineType,dateCreated, dateUpdated)
	select wineN, vinN, fixedId, producer, producerShow, labelName,vintage,country, region, location, locale, [site], variety, colorClass, dryness, wineType, SourceDate, GETDATE()
	from erpWine;
 
 
--update waWineAlertDatabase set errors = isNull(errors + ';  ', '') + '[E01]  Vinn not numeric' where vinn is not null and isNumeric(vinn) = 0;
 
with a as	(select distinct vinn from erpWine)
update b set b.errors = isNull(errors + ';  ', '') + '[E02]  Vinn not in erpWine'
	from waWineAlertDatabase b
		left join a
			on a.vinn = b.vinn2
		where b.vinn2 is not null and a.vinn is null and b.errors is null;
 
;
update waForSale set errors = isNull(errors, ';  ') + '[E03]  WineN is not numeric' where wineN is not null and isNumeric(wineN) = 0;
 
with a as	(select distinct wineN from erpWine)
update b set b.errors = isNull(errors + ';  ', '') + '[E04]  WineN not in erpWine'
	from waForSale b
		left join a
			on a.wineN = b.wineN
		where b.wineN is not null and a.wineN is null and b.errors is null;
		
with 
a as (select wineN, min(vinn)vinn from erpWIne group by wineN)
, b as (select * from waForSale where errors is null)
, c as (select * from waWineAlertDatabase where errors is null)
update b set b.warnings = isNull(b.warnings + ';  ', '') + '[W01]  Vinn from WneN <> Vinn from WineAlertID'
	from b
		join a
			on a.wineN = b.wineN
		join c
			on b.[wineAlert Id] = c.[wineAlert Id]
	where a.vinn <> c.vinn2;

-------------------------------------------------------------------------
-- FIX THIS TO GET FIELDS FROM ERP INSTEAD OF WINEALERT
-------------------------------------------------------------------------
 
with
a as (select [WineAlert ID], wineN, vintage from waForSale where errors is null group by [WineAlert ID], wineN, vintage)
,b as (select * from waWineAlertDatabase where errors is null)
,c as (select wineN, min(vinn)vinn from erpWine group by wineN)
insert into nameYearRaw(wineN, vinn, wid, producer, producerShow, labelName,vintage,country, region, location, variety, colorClass, dryness, wineType,dateCreated, dateUpdated)
	select a.wineN, case when c.vinn is not null then c.vinn else b.vinn2 end vinN,  a.[WineAlert ID], prod1, prodShow, labelName,a.vintage,country, region, location, variety, 	colorClass, dryness, wineType, null, GETDATE()
	from a
		join b on b.[WineAlert ID] = a.[WineAlert ID]
		left join c on c.wineN = a.wineN
		
-------------------------------------------------------------------------
-- Add in the wine alert database entries that do not currently have forSale entries
-------------------------------------------------------------------------





end
 
 
/*
select COALESCE (convert(int, 'aa'), 99)
[updateNameYearRaw]
 
select * from waForSale where warnings is not null
 
select * from nameYearRaw where wineN = 69375
select vinn from waWineAlertDatabase where [wineAlert Id] = 'am1183100'
 
*/
 
