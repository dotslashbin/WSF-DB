
-- =============================================
-- Author:		Alex B.
-- Create date: 4/13/14
-- Description:	Adoptation of the script 23UpdateImportPrices.sql,
--				originally developed by Julian.
-- NOTE: USES & UPDATES RPOWine database objects.
-- NOTE: following tables must be loaded first: 
--	CurrencyConversion, Retailers, ForSaleDetail, StdBottleSize, WAName
--	CurrencyConversion must be cleared - records with USDollars = NULL will prevent correct processing.
-- =============================================
CREATE PROCEDURE [dbo].[23UpdateImportPrices] 
	@IsUseOldWineN bit = 1, @IsUpdateWineDB bit = 0
	
AS
set nocount on;

/* Alex B.
truncate table CurrencyConversion
truncate table Retailers
truncate table ForSaleDetail
truncate table StdBottleSize
truncate table WAName
-- copy
delete CurrencyConversion where USDollars is NULL
*/

if col_length('Wine','oldWineN') is null begin
	alter table Wine add oldWineN int null; 
end

/*
DETECT VINN MAPPING CONFLICTS, SINCE WE DON'T APPEAR TO BE DOING THIS NOW, DETERMINE WHY WE'RE NOT ALREADY MAKING BAD MAPPING

NOTE: USES & UPDATES RPOWine database objects.

-- Checking errors:
select Errors, count(*) from ForSaleDetail group by Errors

*/

--Should be run whenever we rerun this script
truncate table dbo.ForSale
truncate table dbo.Wine
truncate table dbo.WineName

update dbo.ForSaleDetail set errors = null, warnings = null where warnings is not null or errors is not null;
--it's just been truncated - ???
--update dbo.ForSale set errors = null, warnings = null where warnings is not null or errors is not null;
--update dbo.ForSale set wineN = null where wineN < 0 or isTempWineN = 1

update dbo.WAName set errors = null, warnings = null where warnings is not null or errors is not null;
update dbo.Retailers set errors = null, warnings = null where warnings is not null or errors is not null;
update dbo.ForSaleDetail set wineN2 = null
update dbo.ForSaleDetail set wineN = null where wineN < 0 or isTempWineN = 1

/*
------------------------------
--CAREFULL.  These are read in from Julian, don't delete unless you run JulianImport.vb again
delete from dbo.ForSaleDetail
delete from dbo.WAName
delete from dbo.Retailers
--CAREFULL.  These are read in from Julian, don't delete unless you run JulianImport.vb again
------------------------------
*/

--3 Disable Indexes --------------------------
exec LogMsg 'Import Stage 1'
print '-- 1. ' + cast(getdate() as varchar(30))

begin try
	alter fullText Index on dbo.ForSaleDetail disable;
	alter fullText Index on dbo.Wine disable;
	alter fullText Index on dbo.WineName disable;
	--TODO: alter fullText Index on RpoWineData.dbo.wine disable;
end try
begin catch
end catch

--08Dec24
--TODO: it does not make any sense...
--update RpoWineData.dbo.wine set EstimatedCost_Hi = null where EstimatedCost is  null and  EstimatedCost_Hi <> 0

--Initialize isTemp's - nulls cause problems
update dbo.ForSale set isTempWineN = 0 where isTempWineN is null;
update dbo.ForSaleDetail set isTempWineN = 0 where isTempWineN is null;
update dbo.WAName set isTempVinn = 0 where isTempVinn is null;

--cleanup any left over effects from prior runs of this script on the dataEntry round
update dbo.ForSaleDetail set wineN = null where wineN < 0 or isTempWineN = 1;
update dbo.ForSale set wineN = null where wineN < 0 or isTempWineN = 1;
update dbo.WAName set vinn = null where vinn < 0 or isTempVinn = 1;

--restore readin errors in case we are processing the same readin files more than once
if exists (select 1 from dbo.Retailers where errorsOnReadin is not null)
     update dbo.Retailers set errors = errorsOnReadIn
else
     update dbo.Retailers set errorsOnReadIn = errors

if exists (select 1 from dbo.WAName where errorsOnReadin is not null)
     update dbo.WAName set errors = errorsOnReadIn
else
     update dbo.WAName set errorsOnReadIn = errors

if exists (select 1 from dbo.ForSaleDetail where errorsOnReadin is not null)
     update dbo.ForSaleDetail set errors = errorsOnReadIn
else
     update dbo.ForSaleDetail set errorsOnReadIn = errors

print '-- 1.2. FillInStd -- ' + cast(getdate() as varchar(30))
Insert Into dbo.StdLocation(Location, Scale, Cnt, IsOK, IsERP) 
Select Country, 'Country', count(*) Cnt, 1, 1 
From RPOWine.dbo.Wine 
where Country is not null and Country not in (select location from dbo.StdLocation) 
Group By Country;

Insert Into dbo.StdLocation(Location, Scale, Cnt, IsOK, IsERP) 
Select Region, 'Region', count(*) Cnt, 1,1 
From RPOWine.dbo.Wine 
where Region is not null and Region not in (select location from dbo.StdLocation) 
Group By Region;

Insert Into dbo.StdLocation(Location, Scale, Cnt, IsOK, IsERP) 
Select Location, 'Location', count(*) Cnt, 1,1 
From RPOWine.dbo.Wine 
where Location is not null and Location not in (select location from dbo.StdLocation) 
Group By Location;

Insert Into dbo.StdLocation(Location, Scale, Cnt, IsOK, IsERP) 
Select Locale, 'Locale', count(*) Cnt, 1,1 
From RPOWine.dbo.Wine 
where Locale is not null and Locale not in (select location from dbo.StdLocation) 
Group By Locale;

Insert Into dbo.StdLocation(Location, Scale, Cnt, IsOK, IsERP) 
Select Site, 'Site', count(*) Cnt, 1,1 
From RPOWine.dbo.Wine 
where Site is not null and Site not in (select location from dbo.StdLocation) 
Group By Site;

Insert into dbo.StdVariety (Variety, Cnt, IsOK, IsERP) 
Select Variety, count(*) Cnt, 1,1 
From RPOWine.dbo.Wine 
where Variety is not null and Variety not in (select Variety from dbo.StdVariety) 
Group By Variety;

Insert into dbo.StdProducer (Producer, Cnt, IsOK, IsERP) 
Select Producer, count(*) Cnt, 1,1 
From RPOWine.dbo.Wine 
where Producer is not null  and Producer not in (select Producer from dbo.StdProducer) 
Group By  Producer;

Insert into dbo.StdColorClass (ColorClass, Cnt, IsOK, IsERP) 
Select ColorClass, count(*) Cnt, 1,1 
From RPOWine.dbo.Wine 
where ColorClass is not null and ColorClass not in (select ColorClass from dbo.StdColorClass) 
Group By  ColorClass;

Insert into dbo.StdDryness (Dryness, Cnt, IsOK, IsERP) 
Select Dryness, count(*) Cnt, 1,1 
From RPOWine.dbo.Wine 
where Dryness is not null and Dryness not in (select Dryness from dbo.StdDryness) 
Group By  Dryness;

Insert into dbo.StdWineType (WineType, Cnt, IsOK, IsERP) 
Select WineType, count(*) Cnt, 1,1 
From RPOWine.dbo.Wine 
where WineType is not null and WineType not in (select WineType from dbo.StdWineType) 
Group By  WineType;

print '-- 2. AddJulianToStd -- ' + cast(getdate() as varchar(30))
exec LogMsg 'Import Stage 2';

Insert Into dbo.StdLocation(Location, Scale, Cnt, IsOK, IsERP) 
Select Country, 'Country', count(*) Cnt, 0, 0 
From dbo.WAName 
where Country not in (select location from dbo.StdLocation) 
Group By Country;

Insert Into dbo.StdLocation(Location, Scale, Cnt, IsOK, IsERP) 
Select Region, 'Region', count(*) Cnt, 0, 0 
From dbo.WAName  
where Region not in (select location from dbo.StdLocation) 
Group By Region;

Insert Into dbo.StdLocation(Location, Scale, Cnt, IsOK, IsERP) 
Select Location, 'Location', count(*) Cnt, 0, 0 
From dbo.WAName 
where Location not in (select location from dbo.StdLocation) 
Group By Location;

Insert into dbo.StdVariety (Variety, Cnt, IsOK, IsERP) 
Select Variety, count(*) Cnt, 0, 0 
From dbo.WAName 
where Variety not in (select variety from dbo.StdVariety) 
Group By Variety;

Insert into dbo.StdProducer (Producer, Cnt, IsOK, IsERP) 
Select Producer, count(*) Cnt, 0, 0 
From dbo.WAName
where Producer not in (select Producer from dbo.StdProducer)
Group By Producer;

Insert into dbo.StdColorClass (ColorClass, Cnt, IsOK, IsERP) 
Select ColorClass, count(*) Cnt, 0, 0 
From dbo.WAName
where ColorClass not in (select ColorClass from dbo.StdColorClass)
Group By ColorClass;

Insert into dbo.StdDryness (Dryness, IsOK, Cnt, IsERP) 
Select Dryness, count(*) Cnt, 0, 0 
From dbo.WAName 
where Dryness not in (select Dryness from dbo.StdDryness)
Group By Dryness;

Insert into dbo.StdWineType (WineType, Cnt, IsOK, IsERP) 
Select WineType, count(*) Cnt, 0, 0 
From dbo.WAName  
where WineType not in (select WineType from dbo.StdWineType)  
Group By WineType;

print '-- 3. CurrencyConversion -- ' + cast(getdate() as varchar(30))
--Jun20'07
/*
Insert into dbo.CurrencyConversion (AlertCurrency, Pending) 
Select Currency, 1 
From dbo.ForSaleDetail 
where Currency not in (select alertCurrency from dbo.CurrencyConversion) 
Group By Currency;
*/
-- new: Alex B.
delete CurrencyConversion where USDollars is NULL

Insert into dbo.StdBottleSize(WAlertBottleSize,Pending) 
select BottleSize, 1 
from dbo.ForSaleDetail 
where bottleSize not in (select wAlertBottleSize from dbo.StdBottleSize) 
	and bottleSize is NOT NULL
Group by bottleSize;

update dbo.StdBottleSize set dateAdded = GetDate() where dateAdded is null;
update dbo.StdColorClass set dateAdded = GetDate() where dateAdded is null;
update dbo.StdDryness set dateAdded = GetDate() where dateAdded is null;
update dbo.StdLocation set dateAdded = GetDate() where dateAdded is null;
update dbo.StdProducer set dateAdded = GetDate() where dateAdded is null;
update dbo.StdVariety set dateAdded = GetDate() where dateAdded is null;
update dbo.StdWineType set dateAdded = GetDate() where dateAdded is null;

--For now, just set everything to OK
update dbo.StdLocation set isOK = 1;
update dbo.StdVariety set isOK = 1;
update dbo.StdProducer set isOK = 1;
update dbo.StdColorClass set isOK = 1;
update dbo.StdDryness set isOK = 1;
update dbo.StdWineType set isOK = 1;

print '-- 4. WineNameErrors -- ' + cast(getdate() as varchar(30))
--Put Errors Into dbo.WAName
--update dbo.WAName set errors = null, warnings = null
--select * from dbo.WAName where errors is not null
--erpSearchD.dbo.logmsg 'Import Stage 3';

; with a as (
	select wid from dbo.WAName group by wid having count(*) > 1
), b as (
	select n.* from dbo.WAName n join a on n.wid = a.wid
)
update b set errors = case when errors is null then '' else errors + ',   ' end + 'E1.Duplicate WineAlert Id';

if @IsUseOldWineN = 1 begin
	--with a as (
	--	select distinct 
	--		vinn = oldVinN
	--	from RPOWine.dbo.Wine_VinN
	--), b as (
	--	select w.* 
	--	from dbo.WAName w 
	--		left join a on w.vinn = a.vinn 
	--	where w.vinn is not null and a.vinn is null 
	--)
	--update b set errors = case when errors is null then 'E2.BadVinn' else (errors + ',   E2.BadVinn') end;

	update WAName set
		errors = case when errors is null then 'E2.BadVinn' else (errors + ',   E2.BadVinn') end
	from WAName wan
		left join RPOWine.dbo.Wine_VinN v on isnull(v.oldVinN, 0) > 0 and wan.VinN = v.oldVinN
	where v.ID is NULL
	
end else begin
	--with a as (
	--	select distinct 
	--		vinn = ID
	--	from RPOWine.dbo.Wine_VinN
	--), b as (
	--	select w.* 
	--	from dbo.WAName w 
	--		left join a on w.vinn = a.vinn 
	--	where w.vinn is not null and a.vinn is null 
	--)
	--update b set errors = case when errors is null then 'E2.BadVinn' else (errors + ',   E2.BadVinn') end;
	
	update WAName set
		errors = case when errors is null then 'E2.BadVinn' else (errors + ',   E2.BadVinn') end
	from WAName wan
		left join RPOWine.dbo.Wine_VinN v on wan.VinN = v.ID
	where v.ID is NULL

end

; with a as (
	select w.* from dbo.WAName w left join dbo.StdProducer v on w.Producer = v.Producer and v.IsOK = 1 
	where w.Producer is not null and v.Producer is null
)
update a set errors = case when errors is null then 'E3.BadProducer' else (errors + ',   E3.BadProducer') end 
where vinn is null;

with a as (
	select w.* from dbo.WAName w left join dbo.StdVariety v on w.variety = v.variety and v.IsOK = 1 
	where w.variety is not null and v.variety is null
)
update a set errors = case when errors is null then 'E4.BadVariety' else (errors + ',   E4.BadVariety') end 
where vinn is null;

with a as (
	select w.* from dbo.WAName w left join dbo.StdColorClass v on w.ColorClass = v.ColorClass and v.IsOK = 1 
	where w.ColorClass is not null and v.ColorClass is null)
update a set errors = case when errors is null then 'E5.BadColorClass' else (errors + ',   E5.BadColorClass') end 
where vinn is null;

with a as (
	select w.* from dbo.WAName w left join dbo.StdDryness v on w.Dryness = v.Dryness and v.IsOK = 1 
	where w.Dryness is not null and v.Dryness is null
)
update a set errors = case when errors is null then 'E6.BadDryness' else (errors + ',   E6.BadDryness') end 
where vinn is null;

with a as (
	select w.* from dbo.WAName w left join dbo.StdWineType v on w.WineType = v.WineType and v.IsOK = 1 
	where w.WineType is not null and v.WineType is null
)
update a set errors = case when errors is null then 'E7.BadWineType' else (errors + ',   E7.BadWineType') end 
where vinn is null;

if @IsUseOldWineN = 1 begin
	with a as (
		select wid, wineN from dbo.ForSaleDetail where wineN > 0 
		group by wid, wineN
	), b as (
		select a.wid, 
			vinn = z.oldVinN
		from RPOWine.dbo.Wine_N z 
			join a on a.wineN = z.oldWineN
		group by wid, z.oldVinN
	), c as (
		select wid, vinn from dbo.WAName where vinn > 0 
		group by wid, vinn
	), d as (
		select wid, vinn from b 
		union 
		select wid, vinn from c
	), e as (
		select wid from d 
		group by wid having count(*) > 1
	), f as (
		select z.* 
		from dbo.WAName z 
		where exists (select * from e where e.wid = z.wid)
	)
	--select * from e
	update f set warnings = case when warnings is null then '' else warnings + ',   ' end 
		+ 'E37. Multiple Vinns associated with this Wid';
end else begin
	with a as (
		select wid, wineN from dbo.ForSaleDetail where wineN > 0 
		group by wid, wineN
	), b as (
		select a.wid, 
			vinn = z.Wine_VinN_ID
		from RPOWine.dbo.Wine_N z 
			join a on a.wineN = z.ID
		group by wid, z.Wine_VinN_ID
	), c as (
		select wid, vinn from dbo.WAName where vinn > 0 
		group by wid, vinn
	), d as (
		select wid, vinn from b 
		union 
		select wid, vinn from c
	), e as (
		select wid from d 
		group by wid having count(*) > 1
	), f as (
		select z.* 
		from dbo.WAName z 
		where exists (select * from e where e.wid = z.wid)
	)
	--select * from e
	update f set warnings = case when warnings is null then '' else warnings + ',   ' end 
		+ 'E37. Multiple Vinns associated with this Wid';
end

print '-- 5. ForSaleErrors -- ' + cast(getdate() as varchar(30))
--update dbo.ForSaleDetail set errors = null
--select * from dbo.ForSaleDetail where errors is not null
exec LogMsg 'Import Stage 5';

--get rid of any temporary wineN from the last round
update dbo.ForSale set wineN = null where wineN < 0 or isTempWineN = 1;

--June20'07
with a as (
	select 
		z.IdN 
	from dbo.ForSaleDetail z 
		left join dbo.CurrencyConversion y on z.currency = y.alertcurrency 
	where y.alertCurrency is null or isnull(y.pending, 0) = 1
)
update ForSaleDetail set errors = case when errors is null then '' else errors + ', ' end 
	+  'E70. NoConversionForCurrency'
where IdN in (select IdN from a);

with a as (
	select f.* 
	from dbo.ForSaleDetail f 
		left join dbo.WAName w on f.wid = w.wid 
	where f.wid is not null and w.wid is null
)
update a set errors = case when errors is null then 'E8. BadWid' else (errors + ',  E8. BadWid') end;

with a as (
	select f.* 
	from dbo.ForSaleDetail f 
		left join dbo.Retailers r on f.retailerCode = r.RetailerCode 
	where f.RetailerCode is not null and r.RetailerCode is null)
update a set errors = case when errors  is null then '' else errors + ',   ' end 
	+ 'E9. BadRetailerCode';

if @IsUseOldWineN = 1 begin
	with
	a as (
		select distinct WineN = oldWineN from RPOWine.dbo.Wine_N
	), b as (
		select f.* 
		from dbo.ForSaleDetail f 
			left join a on f.wineN = a.wineN 
		where f.wineN is not null and a.wineN is null
	)
	update b set errors = case when errors is null then 'E10. BadWineN' else (errors + ',   E10. BadWineN') end;
end else begin
	with
	a as (
		select WineN = ID from RPOWine.dbo.Wine_N
	), b as (
		select f.* 
		from dbo.ForSaleDetail f 
			left join a on f.wineN = a.wineN 
		where f.wineN is not null and a.wineN is null
	)
	update b set errors = case when errors is null then 'E10. BadWineN' else (errors + ',   E10. BadWineN') end;
end

--update dbo.ForSaleDetail set errors = case when errors is null then 'No Price' else (errors + ',  No Price') end where price is null;
--update dbo.ForSaleDetail set errors = case when errors  is null then 'No Bottle Size' else (errors + ',  No Bottle Size') end where BottleSize is null;
update dbo.ForSaleDetail set errors = case when errors  is null then '' else (errors + ',  ') end 
	+ 'E35. No Raw Price'  
where price is null;
update dbo.ForSaleDetail set errors = case when errors is null then '' else (errors + ',  ') end 
	+ 'E34. Wid but No Bottle Size'  
where BottleSize is null and wid is not null;

with a as (
	select wid, vintage, wineN 
	from dbo.ForSaleDetail 
    where wid is not null and winen is not null and vintage is not null and wineN is not null 
    group by wid, vintage, wineN
), b as (
	select wid, vintage, count(*) as cnt 
	from a group by wid, vintage
), c as (
	select wid, vintage 
	from b where cnt > 1
), d as (
	select f.* 
	from dbo.ForSaleDetail f 
		join c on f.wid = c.wid and f.vintage = c.vintage
)
update d set errors = case when errors is null then '' else errors + ',   ' end 
	+ 'E11.Multiple WineN per Wid/Vintage';
--case when errors  is null then 'Multiple WineN per Wid/Vintage' else (errors + ',  Multiple WineN per Wid/Vintage') end

print '-- 6. Fill In Retailer Information -- ' + cast(getdate() as varchar(30))
exec LogMsg 'Import Stage 6';

update ForSaleDetail set
     retailerName = r.RetailerName, city = r.City, Country = r.Country, State = r.State, retailerIdN = r.retailerIdN,
     URL = case when f.URL is null then r.URL else f.URL end
from dbo.ForSaleDetail f 
	join dbo.Retailers r on f.retailercode = r.retailercode

--ComputeDetailDollars
update dbo.ForSaleDetail set dollarsPer750Bottle = null, isTrue750Bottle = 0;

with a as (
	select f.*, milliLitres, USDollars, BottlesPerStockItem
    from dbo.ForSaleDetail f 
		join dbo.StdBottleSize b on f.BottleSize = b.WAlertBottleSize
		join dbo.CurrencyConversion c on c.alertCurrency = f.currency
	where f.currency is not null
)
update a set 
	dollarsPer750Bottle = case 
		when MilliLitres > 0 and BottlesPerStockItem > 0 then round(price * USDollars * 750 / MilliLitres / BottlesPerStockItem, 2)
		else 0
	end,
    isTrue750Bottle = case when milliLitres = 750 then 1 else 0 end;

update dbo.ForSaleDetail set errors = case when errors is null then '' else (errors + ',  ') end 
	+ 'E71. No Dollar Price'
where dollarsPer750Bottle is null;

/*
--Assumes that null currency is US dollars
with a as (
select f.*, milliLitres, BottlesPerStockItem 
     from dbo.ForSaleDetail f 
     join BottleSize b on f.BottleSize = b.WAlertBottleSize
     where f.currency is null
)
update a set dollarsPer750Bottle = round(price * 750 / MilliLitres / BottlesPerStockItem, 2);
*/

print '-- 7. Build ForSale -- ' + cast(getdate() as varchar(30))
exec LogMsg 'Import Stage 7';

delete from dbo.ForSale;
update dbo.ForSaleDetail set isAuction = 0 where isAuction is null;
update dbo.ForSaleDetail set isOverridePriceException = 0 where isOverridePriceException is null;

exec LogMsg 'Import Stage 8';

--cases where there are only 2 prices and the ratio is more that 3 to 1
with a1 as (
	Select row_number() over (order by wid, vintage, wineN, dollarsPer750Bottle) o ,
		wid, vintage,wineN,dollarsPer750Bottle cost, errors
    from dbo.ForSaleDetail 
    where wid is not null and errors is null and isAuction = 0 and isOverridePriceException = 0
), b1 as (
	select wid, vintage, wineN, floor(avg(o)) oAvg, min(cost) lo, max(cost) hi, count(*) cnt 
	from a1 
	group by wid, vintage, wineN
), c1 as (
	select a1.*, abs(o - oAvg) oDist, lo, hi, cnt 
	from b1 
		join a1 on a1.wid= b1.wid and a1.vintage = b1.vintage and isNull(a1.wineN, 0) = isNull(b1.wineN, 0)
), d1 as (
	select cnt, lo, hi, errors 
	from c1 
	where cnt = 2 and lo < (hi / 3)
)
update d1 set errors = case when errors is null then '' else errors + '   ' end 
	+ 'E47.  Bad Price - Only 2, High > 3x Low';

--cases where the low price is less than 1/3 of the median
with a1 as (
	Select row_number() over (order by wid, vintage, wineN, dollarsPer750Bottle) o,
		wid, vintage,wineN,dollarsPer750Bottle cost, errors
    from dbo.ForSaleDetail 
    where wid is not null and errors is null and isAuction = 0 and isOverridePriceException = 0
), b1 as (
	select wid, vintage, wineN, floor(avg(o)) oAvg, min(cost) lo, max(cost) hi, count(*) cnt 
	from a1 
	group by wid, vintage, wineN
), c1 as (
	select a1.*, abs(o - oAvg) oDist, lo, hi, cnt 
	from b1 
		join a1 on a1.wid= b1.wid and a1.vintage = b1.vintage and isNull(a1.wineN, 0) = isNull(b1.wineN, 0)
), d1 as (
	select wid, vintage, wineN, cost, oDist 
	from c1 
	where oDist = 0
), e1 as (
	select a1.*, d1.cost medianCost 
	from a1 
		join d1 on a1.wid = d1.wid and a1.vintage = d1.vintage and isNull(a1.wineN, 0) = isNull(d1.wineN, 0)
), f1 as (
	select e1.* 
	from e1 
	where cost < (medianCost / 3)
)
update f1 set errors = case when errors is null then '' else errors + '   ' end 
	+ 'E48.  Bad Price - Less than 1/3 median';

--another round for cases where the low price is less than 1/3 of the median (it still detects suspect entries)
with a1 as (
	Select row_number() over (order by wid, vintage, wineN, dollarsPer750Bottle) o, 
		wid, vintage,wineN,dollarsPer750Bottle cost, errors
    from dbo.ForSaleDetail 
    where wid is not null and errors is null and isAuction = 0 and isOverridePriceException = 0
), b1 as (
	select wid, vintage, wineN, floor(avg(o)) oAvg, min(cost) lo, max(cost) hi, count(*) cnt 
	from a1 
	group by wid, vintage, wineN
), c1 as (
	select a1.*, abs(o - oAvg) oDist, lo, hi, cnt 
	from b1 
		join a1 on a1.wid= b1.wid and a1.vintage = b1.vintage and isNull(a1.wineN, 0) = isNull(b1.wineN, 0)
), d1 as (
	select wid, vintage, wineN, cost, oDist 
	from c1 
	where oDist = 0
), e1 as (
	select a1.*, d1.cost medianCost 
	from a1 
		join d1 on a1.wid = d1.wid and a1.vintage = d1.vintage and isNull(a1.wineN, 0) = isNull(d1.wineN, 0)
), f1 as (
	select e1.* 
	from e1 
	where cost < (medianCost / 3)
)
update f1 set errors = case when errors is null then '' else errors + '   ' end 
	+ 'E48.  Bad Price - Less than 1/3 median';

--cases where the high price if more that 3 times the median
with a1 as (
	Select row_number() over (order by wid, vintage, wineN, dollarsPer750Bottle) o,
		wid, vintage,wineN,dollarsPer750Bottle cost, errors
    from dbo.ForSaleDetail 
    where wid is not null and errors is null and isAuction = 0 and isOverridePriceException = 0
), b1 as (
	select wid, vintage, wineN, floor(avg(o)) oAvg, min(cost) lo, max(cost) hi, count(*) cnt 
	from a1 
	group by wid, vintage, wineN
), c1 as (
	select a1.*, abs(o - oAvg) oDist, lo, hi, cnt 
	from b1 join a1 on a1.wid= b1.wid and a1.vintage = b1.vintage and isNull(a1.wineN, 0) = isNull(b1.wineN, 0)
), d1 as (
	select wid, vintage, wineN, cost, oDist 
	from c1 
	where oDist = 0
), e1 as (
	select a1.*, d1.cost medianCost 
	from a1 
		join d1 on a1.wid = d1.wid and a1.vintage = d1.vintage and isNull(a1.wineN, 0) = isNull(d1.wineN, 0)
), f1 as (
	select * 
	from e1 
	where cost > (medianCost * 3)
)
update f1 set errors = case when errors is null then '' else errors + '   ' end 
	+ 'E49.  Bad Price - More than 3x median';

--another round for cases where the high price if more that 3 times the median (it still detects suspect entries)
with a1 as (
	Select row_number() over (order by wid, vintage, wineN, dollarsPer750Bottle) o,
		wid, vintage,wineN,dollarsPer750Bottle cost, errors
    from dbo.ForSaleDetail 
    where wid is not null and errors is null and isAuction = 0 and isOverridePriceException = 0
), b1 as (
	select wid, vintage, wineN, floor(avg(o)) oAvg, min(cost) lo, max(cost) hi, count(*) cnt 
	from a1 
	group by wid, vintage, wineN
), c1 as (
	select a1.*, abs(o - oAvg) oDist, lo, hi, cnt 
	from b1 
		join a1 on a1.wid= b1.wid and a1.vintage = b1.vintage and isNull(a1.wineN, 0) = isNull(b1.wineN, 0)
), d1 as (
	select wid, vintage, wineN, cost, oDist 
	from c1 
	where oDist = 0
), e1 as (
	select a1.*, d1.cost medianCost 
	from a1 
		join d1 on a1.wid = d1.wid and a1.vintage = d1.vintage and isNull(a1.wineN, 0) = isNull(d1.wineN, 0)
), f1 as (
	select * 
	from e1 
	where cost > (medianCost * 3)
)
update f1 set errors = case when errors is null then '' else errors + '   ' end 
	+ 'E49.  Bad Price - More than 3x median';

--put prices into forSale when not auction (don't worry about isOverridePriceException since it's already had it's effect in the above error detection
with a as (
	select wid, vintage, min(wineN) wineN, min(DollarsPer750Bottle) price, max(DollarsPer750Bottle) priceHi, count(*) priceCnt
    from dbo.ForSaleDetail 
    where wid is not null and errors is null and isAuction = 0 and dollarsPer750Bottle is not null and dollarsPer750Bottle > 0 
    group by wid, vintage
)
insert into dbo.ForSale(wid, vintage, wineN, price, priceHi, priceCnt) 
select wid, vintage, wineN, price, priceHi, priceCnt 
from a 
order by wid, vintage, wineN;

--@@new stuff needs debugging
with a as (
	select wid, vintage, min(wineN) wineN, min(DollarsPer750Bottle) price, max(DollarsPer750Bottle) priceHi, count(*) priceCnt
    from dbo.ForSaleDetail z 
    where wid is not null and errors is null  and isAuction = 1  and dollarsPer750Bottle is not null and dollarsPer750Bottle > 0
		and not exists (select 1 from dbo.ForSale y where z.wid = y.wid and z.vintage = y.vintage and isNull(z.wineN, -1) = isNull(y.wineN, -1))
	group by wid, vintage
)
insert into dbo.ForSale(wid, vintage, wineN, auctionPrice, auctionPriceHi, auctionCnt) 
select wid, vintage, wineN, price, priceHi, priceCnt
from a 
order by wid, vintage, wineN;

--@@ have to consider cases where there are no prices but there is still an auction
with a1 as (
	select wid a1wid, vintage a1vintage, min(wineN) a1wineN, min(DollarsPer750Bottle) a1price, max(DollarsPer750Bottle) a1priceHi, count(*) a1priceCnt
    from dbo.ForSaleDetail 
    where wid is not null and errors is null and isAuction = 1 
    group by wid, vintage
), b1 as (
	select * 
	from dbo.ForSale z 
		join a1 on wid = a1wid and vintage = a1vintage and isNull(wineN, -1) = isNull(a1wineN, -1)
)
update b1 set auctionPrice = a1price, auctionPriceHi = a1PriceHi, auctionCnt = a1PriceCnt;

print '-- 8. BackFillVinns -- ' + cast(getdate() as varchar(30))
-- limit to dbo.ForSale where corresponding dbo.WAName doesn't have a Vinn
exec LogMsg 'Import Stage 8';

if @IsUseOldWineN = 1 begin
	with a as (
		select distinct wid from dbo.WAName where vinn is null
	), b as (
		select f.* from dbo.ForSale f join a on f.wid = a.wid where wineN is not null
	), c as (
		select WineN = oldWineN, 
			vinn = min(oldVinN)  
		from RPOWine.dbo.Wine_N 
		group by oldWineN
	), d as (
		select b.*, c.vinn from  b join c on b.wineN = c.wineN
	), e as (
		select wid, min(vinn) Vinn from d group by wid having count(*) = 1
	), f as (
		select n.*, e.vinn vinn2 from dbo.WAName n join e on n.wid = e.wid
	)
	update f set 
		 vinn = vinn2, 
		 IsVinnDeduced = 1, 
		 warnings = case when warnings  is null then ''else warnings + ',   ' end + 'Deduced Vinn';

	with a as (
		select distinct wid from dbo.WAName where vinn is null
	), b as (
		select f.* from dbo.ForSale f join a on f.wid = a.wid where wineN is not null
	), c as (
		select WineN = oldWineN, 
			vinn = min(oldVinN)
		from RPOWine.dbo.Wine_N 
		group by oldWineN
	), d as (
		select b.*, c.vinn from b join c on b.wineN = c.wineN
	), e as (
		select wid, min(vinn) Vinn from d group by wid having count(*) > 1
	), f as (
		select n.*, e.vinn vinn2 from dbo.WAName n join e on n.wid = e.wid
	)
	update f set 
		 warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E12.ForSale Leads To Conflicting Vinns'
end else begin
	with a as (
		select distinct wid from dbo.WAName where vinn is null
	), b as (
		select f.* from dbo.ForSale f join a on f.wid = a.wid where wineN is not null
	), c as (
		select WineN = ID, 
			vinn = min(Wine_VinN_ID)  
		from RPOWine.dbo.Wine_N 
		group by ID
	), d as (
		select b.*, c.vinn from  b join c on b.wineN = c.wineN
	), e as (
		select wid, min(vinn) Vinn from d group by wid having count(*) = 1
	), f as (
		select n.*, e.vinn vinn2 from dbo.WAName n join e on n.wid = e.wid
	)
	update f set 
		 vinn = vinn2, 
		 IsVinnDeduced = 1, 
		 warnings = case when warnings  is null then ''else warnings + ',   ' end + 'Deduced Vinn';

	with a as (
		select distinct wid from dbo.WAName where vinn is null
	), b as (
		select f.* from dbo.ForSale f join a on f.wid = a.wid where wineN is not null
	), c as (
		select WineN = ID, 
			vinn = min(Wine_VinN_ID)
		from RPOWine.dbo.Wine_N 
		group by ID
	), d as (
		select b.*, c.vinn from b join c on b.wineN = c.wineN
	), e as (
		select wid, min(vinn) Vinn from d group by wid having count(*) > 1
	), f as (
		select n.*, e.vinn vinn2 from dbo.WAName n join e on n.wid = e.wid
	)
	update f set 
		 warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E12.ForSale Leads To Conflicting Vinns'
end

print '-- 9. Deduce Producer, LabelName, Variety, etc through Vinn -- ' + cast(getdate() as varchar(30))
exec LogMsg 'Import Stage 9';
--9a Producer ----------------------------
update dbo.WAName set isVinnProducerAmbiguous = 0, isErpProducerOK = 0, isProducerTranslated = 0, erpProducer = null;

if @IsUseOldWineN = 1 begin
	with a as (
		select vinn = oldVinN, 
			producer = wp.Name
		from RPOWine.dbo.Wine_VinN vn 
			join RPOWine.dbo.WineProducer wp on vn.ProducerID = wp.ID
		group by oldVinN, wp.Name
	), b as (
		select vinn, count(*) cnt from a group by vinn having count(*) > 1
	), c as (
		select n.* from dbo.WAName n join b on n.vinn = b.vinn
	)
	update c set 
		warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E16.Ambiguous eRP Producer For This Vinn', 
		isVinnProducerAmbiguous = 1;

	with a as (
		select VinN = oldVinN,
			fixedId, sourceDate,
			Producer, ProducerShow
		from RPOWine.dbo.Wine
	), aa as (
		select * from a where vinn is NOT NULL
	), b as (
		select * from a where a.fixedId = 
			(select top(1) fixedId from aa where aa.vinn = a.vinn order by sourceDate desc)
	), c as (
		select n.erpProducer, n.eRPProducerShow, n.isErpProducerOK, b.* 
		from dbo.WAName n 
			join b on n.vinn = b.vinn 
		where isVinnProducerAmbiguous = 0
	)
	update c set erpProducer = producer, erpProducerShow = producerShow, isErpProducerOK = 1;
end else begin
	with a as (
		select vinn = vn.ID, 
			producer = wp.Name
		from RPOWine.dbo.Wine_VinN vn 
			join RPOWine.dbo.WineProducer wp on vn.ProducerID = wp.ID
		group by vn.ID, wp.Name
	), b as (
		select vinn, count(*) cnt from a group by vinn having count(*) > 1
	), c as (
		select n.* from dbo.WAName n join b on n.vinn = b.vinn
	)
	update c set 
		warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E16.Ambiguous eRP Producer For This Vinn', 
		isVinnProducerAmbiguous = 1;

	with a as (
		select VinN = VinN,
			fixedId, sourceDate,
			Producer, ProducerShow
		from RPOWine.dbo.Wine
	), aa as (
		select * from a where vinn is NOT NULL
	), b as (
		select * from a where a.fixedId = 
			(select top(1) fixedId from aa where aa.vinn = a.vinn order by sourceDate desc)
	), c as (
		select n.erpProducer, n.eRPProducerShow, n.isErpProducerOK, b.* 
		from dbo.WAName n 
			join b on n.vinn = b.vinn 
		where isVinnProducerAmbiguous = 0
	)
	update c set erpProducer = producer, erpProducerShow = producerShow, isErpProducerOK = 1;
end

--translate all producers where there is no ambiguity
; with a as (
	select producer, erpProducer, max(erpProducerShow) erpProducerShow 
	from dbo.WAName 
	where erpProducer is not null and isErpProducerOK = 1 and isVinnProducerAmbiguous = 0 
	group by producer, erpProducer
), b as (
	select producer from a group by producer having count(*)  = 1
), c as (
	select producer, erpProducer, erpProducerShow, isProducerTranslated 
	from dbo.WAName 
	where producer in (select * from b)
), d as (
	select c.*, a.erpProducer erpProducer2, a.erpProducerShow erpProducerShow2 
	from c 
		join a on c.producer = a.producer
)
update d set 
	eRPProducer = eRPProducer2, 
	eRPProducerShow = eRPProducerShow2,
    isProducerTranslated = case when isNull(d.Producer, '') = isNull(erpProducer2, '') then 0 else 1 end;

--When JLabelName is one of the eRp entries
if @IsUseOldWineN = 1 begin
	with a as (
		select vinn = oldVinN, 
			Producer = wp.Name
		from RPOWine.dbo.Wine_VinN vn 
			join RPOWine.dbo.WineProducer wp on vn.ProducerID = wp.ID
		group by oldVinN, wp.Name
	), b as (
		select z.* 
		from dbo.WAName z 
		where exists (select 1 from a where a.vinn = z.vinn and a.Producer = z.Producer)
	)
	update b set erpProducer = Producer, isErpProducerOK = 1
end else begin
	with a as (
		select vinn = vn.ID, 
			Producer = wp.Name
		from RPOWine.dbo.Wine_VinN vn 
			join RPOWine.dbo.WineProducer wp on vn.ProducerID = wp.ID
		group by vn.ID, wp.Name
	), b as (
		select z.* 
		from dbo.WAName z 
		where exists (select 1 from a where a.vinn = z.vinn and a.Producer = z.Producer)
	)
	update b set erpProducer = Producer, isErpProducerOK = 1
end

--fill in remainder from dbo.WAName itself - producer is the only field we jam into erpProducer so later operations work (they always use erp)
update dbo.WAName set 
	erpProducer  = producer, 
	erpProducerShow = producerShow, 
	isErpProducerOK = 0, 
	isVinnProducerAmbiguous = 0 
where erpProducer is null;

update dbo.WAName set
	warnings = case when warnings  is null then ''else warnings + ',   ' end 
		+ 'E15. Producer Filled In From eRP'
where Producer is null and eRPProducer is not null;

print '-- 9b. LabelName -- ' + cast(getdate() as varchar(30))
update dbo.WAName set 
	isVinnLabelNameAmbiguous = 0, 
	isErpLabelNameOK = 0, 
	isLabelNameTranslated = 0, 
	erpLabelName = null;

if @IsUseOldWineN = 1 begin
	--with a as (
	--	select vinn = oldVinN, 
	--		LabelName = wl.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineLabel wl on vn.LabelID = wl.ID
	--	group by oldVinN, wl.Name
	--), b as (
	--	select vinn, count(*) cnt 
	--	from a 
	--	group by vinn having count(*) > 1
	--), c as (
	--	select n.* 
	--	from dbo.WAName n 
	--		join b on n.vinn = b.vinn
	--)
	--update c set 
	--	warnings = case when warnings is null then ''else warnings + ',   ' end 
	--		+ 'E36.Ambiguous eRP LabelName For This Vinn', 
	--	isVinnLabelNameAmbiguous = 1;

	----When there is no ambiguity on erpSide
	--with a as (
	--	select vinn = oldVinN, 
	--		LabelName = wl.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineLabel wl on vn.LabelID = wl.ID
	--	group by oldVinN, wl.Name
	--), aa as (
	--	select vinn, max(LabelName) LabelName2 
	--	from a 
	--	group by vinn having count(*) = 1
	--), b as (
	--	select z.*, aa.LabelName2 
	--	from dbo.WAName z 
	--		join aa on z.vinn = aa.vinn
	--)
	--update b set 
	--	erpLabelName = LabelName2, 
	--	isErpLabelNameOK = 1, 
	--	isLabelNameTranslated = case when isNull(b.LabelName, '')  = isNull(LabelName2, '') then 0 else 1 end;

	----When JLabelName is one of the eRp entries
	--with a as (
	--	select vinn = oldVinN, 
	--		LabelName = wl.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineLabel wl on vn.LabelID = wl.ID
	--	group by oldVinN, wl.Name
	--), b as (
	--	select z.* 
	--	from dbo.WAName z 
	--	where exists (select 1 from a where a.vinn = z.vinn and a.labelname = z.labelname)
	--)
	--update b set erpLabelName = labelName, isErpLabelNameOK = 1;
	---
	update WAName set 
		warnings = case 
			when Cnt > 1 then 
				case when warnings is null then '' else warnings + ',   ' end + 'E27.Ambiguous eRP LabelName For This Vinn'
			else warnings
		end,
		isVinnLabelNameAmbiguous = case when Cnt > 1 then 1 else 0 end,
		erpLabelName = case when Cnt = 1 then LabelName2 else isnull(nullif(erpLabelName, ''), LabelName2) end, 
		isErpLabelNameOK = case when Cnt = 1 or LabelName = LabelName2 then 1 else 0 end, 
		isLabelNameTranslated = case when isNull(LabelName, '') = isNull(LabelName2, '') then 0 else 1 end
	from WAName 
		join (
			select	VinN = oldVinN, 
					LabelName2 = max(wl.Name),
					Cnt = count(distinct wl.Name)
			from RPOWine.dbo.Wine_VinN vn 
				join RPOWine.dbo.WineLabel wl on vn.LabelID = wl.ID
			where isnull(oldVinN, 0) > 0
			group by oldVinN
		) a on WAName.VinN = a.VinN
	
end else begin
	--with a as (
	--	select vinn = vn.ID, 
	--		LabelName = wl.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineLabel wl on vn.LabelID = wl.ID
	--	group by vn.ID, wl.Name
	--), b as (
	--	select vinn, count(*) cnt 
	--	from a 
	--	group by vinn having count(*) > 1
	--), c as (
	--	select n.* 
	--	from dbo.WAName n 
	--		join b on n.vinn = b.vinn
	--)
	--update c set 
	--	warnings = case when warnings is null then ''else warnings + ',   ' end 
	--		+ 'E36.Ambiguous eRP LabelName For This Vinn', 
	--	isVinnLabelNameAmbiguous = 1;

	----When there is no ambiguity on erpSide
	--with a as (
	--	select vinn = vn.ID, 
	--		LabelName = wl.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineLabel wl on vn.LabelID = wl.ID
	--	group by vn.ID, wl.Name
	--), aa as (
	--	select vinn, max(LabelName) LabelName2 
	--	from a 
	--	group by vinn having count(*) = 1
	--), b as (
	--	select z.*, aa.LabelName2 
	--	from dbo.WAName z 
	--		join aa on z.vinn = aa.vinn
	--)
	--update b set 
	--	erpLabelName = LabelName2, 
	--	isErpLabelNameOK = 1, 
	--	isLabelNameTranslated = case when isNull(b.LabelName, '')  = isNull(LabelName2, '') then 0 else 1 end;

	----When JLabelName is one of the eRp entries
	--with a as (
	--	select vinn = vn.ID, 
	--		LabelName = wl.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineLabel wl on vn.LabelID = wl.ID
	--	group by vn.ID, wl.Name
	--), b as (
	--	select z.* 
	--	from dbo.WAName z 
	--	where exists (select 1 from a where a.vinn = z.vinn and a.labelname = z.labelname)
	--)
	--update b set erpLabelName = labelName, isErpLabelNameOK = 1;

	update WAName set 
		warnings = case 
			when Cnt > 1 then 
				case when warnings is null then '' else warnings + ',   ' end + 'E27.Ambiguous eRP LabelName For This Vinn'
			else warnings
		end,
		isVinnLabelNameAmbiguous = case when Cnt > 1 then 1 else 0 end,
		erpLabelName = case when Cnt = 1 then LabelName2 else isnull(nullif(erpLabelName, ''), LabelName2) end, 
		isErpLabelNameOK = case when Cnt = 1 or LabelName = LabelName2 then 1 else 0 end, 
		isLabelNameTranslated = case when isNull(LabelName, '') = isNull(LabelName2, '') then 0 else 1 end
	from WAName 
		join (
			select	VinN = vn.ID, 
					LabelName2 = max(wl.Name),
					Cnt = count(distinct wl.Name)
			from RPOWine.dbo.Wine_VinN vn 
				join RPOWine.dbo.WineLabel wl on vn.LabelID = wl.ID
			group by vn.ID
		) a on WAName.VinN = a.VinN
end

update dbo.WAName set 
	warnings = case when warnings  is null then ''else warnings + ',   ' end 
		+ 'E38. LabelName Filled In From eRP'
where LabelName is null and eRPLabelName is not null;

print '-- 9c. Country -- ' + cast(getdate() as varchar(30))
update dbo.WAName set 
	isVinnCountryAmbiguous = 0, 
	isErpCountryOK = 0, 
	isCountryTranslated = 0, 
	erpCountry = null;

if @IsUseOldWineN = 1 begin
	--with a as (
	--	select vinn = oldVinN, 
	--		Country = lc.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.LocationCountry lc on vn.locCountryID = lc.ID
	--	group by oldVinN, lc.Name
	--), b as (
	--	select vinn, count(*) cnt 
	--	from a 
	--	group by vinn having count(*) > 1
	--), c as (
	--	select n.* 
	--	from dbo.WAName n 
	--		join b on n.vinn = b.vinn
	--)
	--update c set 
	--	warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E24.Ambiguous eRP Country For This Vinn', 
	--	isVinnCountryAmbiguous = 1;

	----When there is no ambiguity on erpSide
	--with a as (
	--	select vinn = oldVinN, 
	--		Country = lc.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.LocationCountry lc on vn.locCountryID = lc.ID
	--	group by oldVinN, lc.Name
	--), aa as (
	--	select vinn, max(Country) Country2 
	--	from a 
	--	group by vinn having count(*) = 1
	--), b as (
	--	select z.*, aa.Country2 
	--	from dbo.WAName z 
	--		join aa on z.vinn = aa.vinn
	--)
	--update b set 
	--	erpCountry = Country2, 
	--	isErpCountryOK = 1, 
	--	isCountryTranslated = case when isNull(b.Country, '')  = isNull(Country2, '') then 0 else 1 end;

	----When JCountry is one of the eRp entries
	--with a as (
	--	select vinn = oldVinN, 
	--		Country = lc.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.LocationCountry lc on vn.locCountryID = lc.ID
	--	group by oldVinN, lc.Name
	--), b as (
	--	select z.* 
	--	from dbo.WAName z 
	--	where exists (select 1 from a where a.vinn = z.vinn and a.Country = z.Country)
	--)
	--update b set erpCountry = Country, isErpCountryOK = 1
	
	update WAName set 
		warnings = case 
			when Cnt > 1 then 
				case when warnings is null then '' else warnings + ',   ' end + 'E27.Ambiguous eRP Country For This Vinn'
			else warnings
		end,
		isVinnCountryAmbiguous = case when Cnt > 1 then 1 else 0 end,
		erpCountry = case when Cnt = 1 then Country2 else isnull(nullif(erpCountry, ''), Country2) end, 
		isErpCountryOK = case when Cnt = 1 or Country = Country2 then 1 else 0 end, 
		isCountryTranslated = case when isNull(Country, '') = isNull(Country2, '') then 0 else 1 end
	from WAName 
		join (
			select	VinN = oldVinN, 
					Country2 = max(lc.Name),
					Cnt = count(distinct lc.Name)
			from RPOWine.dbo.Wine_VinN vn 
				join RPOWine.dbo.LocationCountry lc on vn.locCountryID = lc.ID
			where isnull(oldVinN, 0) > 0
			group by oldVinN
		) a on WAName.VinN = a.VinN
		
end else begin
	--with a as (
	--	select vinn = vn.ID, 
	--		Country = lc.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.LocationCountry lc on vn.locCountryID = lc.ID
	--	group by vn.ID, lc.Name
	--), b as (
	--	select vinn, count(*) cnt 
	--	from a 
	--	group by vinn having count(*) > 1
	--), c as (
	--	select n.* 
	--	from dbo.WAName n 
	--		join b on n.vinn = b.vinn
	--)
	--update c set 
	--	warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E24.Ambiguous eRP Country For This Vinn', 
	--	isVinnCountryAmbiguous = 1;

	----When there is no ambiguity on erpSide
	--with a as (
	--	select vinn = vn.ID, 
	--		Country = lc.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.LocationCountry lc on vn.locCountryID = lc.ID
	--	group by vn.ID, lc.Name
	--), aa as (
	--	select vinn, max(Country) Country2 
	--	from a 
	--	group by vinn having count(*) = 1
	--), b as (
	--	select z.*, aa.Country2 
	--	from dbo.WAName z 
	--		join aa on z.vinn = aa.vinn
	--)
	--update b set 
	--	erpCountry = Country2, 
	--	isErpCountryOK = 1, 
	--	isCountryTranslated = case when isNull(b.Country, '')  = isNull(Country2, '') then 0 else 1 end;

	----When JCountry is one of the eRp entries
	--with a as (
	--	select vinn = vn.ID, 
	--		Country = lc.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.LocationCountry lc on vn.locCountryID = lc.ID
	--	group by vn.ID, lc.Name
	--), b as (
	--	select z.* 
	--	from dbo.WAName z 
	--	where exists (select 1 from a where a.vinn = z.vinn and a.Country = z.Country)
	--)
	--update b set erpCountry = Country, isErpCountryOK = 1

	update WAName set 
		warnings = case 
			when Cnt > 1 then 
				case when warnings is null then '' else warnings + ',   ' end + 'E27.Ambiguous eRP Country For This Vinn'
			else warnings
		end,
		isVinnCountryAmbiguous = case when Cnt > 1 then 1 else 0 end,
		erpCountry = case when Cnt = 1 then Country2 else isnull(nullif(erpCountry, ''), Country2) end, 
		isErpCountryOK = case when Cnt = 1 or Country = Country2 then 1 else 0 end, 
		isCountryTranslated = case when isNull(Country, '') = isNull(Country2, '') then 0 else 1 end
	from WAName 
		join (
			select	VinN = vn.ID, 
					Country2 = max(lc.Name),
					Cnt = count(distinct lc.Name)
			from RPOWine.dbo.Wine_VinN vn 
				join RPOWine.dbo.LocationCountry lc on vn.locCountryID = lc.ID
			group by vn.ID
		) a on WAName.VinN = a.VinN

end

update dbo.WAName set
     warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E13. Country Filled In From eRP'
where Country is null and eRPCountry is not null;

print '-- 9d. Region -- ' + cast(getdate() as varchar(30))

update dbo.WAName set isVinnRegionAmbiguous = 0, isErpRegionOK = 0, isRegionTranslated = 0, erpRegion = null;

if @IsUseOldWineN = 1 begin
	--with a as (
	--	select vinn = oldVinN, 
	--		Region = lr.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.LocationRegion lr on vn.locRegionID = lr.ID
	--	group by oldVinN, lr.Name
	--), b as (
	--	select vinn, count(*) cnt 
	--	from a 
	--	group by vinn having count(*) > 1
	--), c as (
	--	select n.* 
	--	from dbo.WAName n 
	--		join b on n.vinn = b.vinn
	--)
	--update c set 
	--	warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E23.Ambiguous eRP Region For This Vinn', 
	--	isVinnRegionAmbiguous = 1;

	----When there is no ambiguity on erpSide
	--with a as (
	--	select vinn = oldVinN, 
	--		Region = lr.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.LocationRegion lr on vn.locRegionID = lr.ID
	--	group by oldVinN, lr.Name
	--), aa as (
	--	select vinn, max(Region) Region2 
	--	from a 
	--	group by vinn having count(*) = 1
	--), b as (
	--	select z.*, aa.Region2 
	--	from dbo.WAName z 
	--		join aa on z.vinn = aa.vinn
	--)
	--update b set 
	--	erpRegion = Region2, 
	--	isErpRegionOK = 1, 
	--	isRegionTranslated = case when isNull(b.Region, '')  = isNull(Region2, '') then 0 else 1 end;

	----When JRegion is one of the eRp entries
	--with a as (
	--	select vinn = oldVinN, 
	--		Region = lr.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.LocationRegion lr on vn.locRegionID = lr.ID
	--	group by oldVinN, lr.Name
	--), b as (
	--	select z.* 
	--	from dbo.WAName z 
	--	where exists (select 1 from a where a.vinn = z.vinn and a.Region = z.Region)
	--)
	--update b set erpRegion = Region, isErpRegionOK = 1

	update WAName set 
		warnings = case 
			when Cnt > 1 then 
				case when warnings is null then '' else warnings + ',   ' end + 'E27.Ambiguous eRP Region For This Vinn'
			else warnings
		end,
		isVinnRegionAmbiguous = case when Cnt > 1 then 1 else 0 end,
		erpRegion = case when Cnt = 1 then Region2 else isnull(nullif(erpRegion, ''), Region2) end, 
		isErpRegionOK = case when Cnt = 1 or Region = Region2 then 1 else 0 end, 
		isRegionTranslated = case when isNull(Region, '') = isNull(Region2, '') then 0 else 1 end
	from WAName 
		join (
			select	VinN = oldVinN, 
					Region2 = max(lr.Name),
					Cnt = count(distinct lr.Name)
			from RPOWine.dbo.Wine_VinN vn 
				join RPOWine.dbo.LocationRegion lr on vn.locRegionID = lr.ID
			where isnull(oldVinN, 0) > 0
			group by oldVinN
		) a on WAName.VinN = a.VinN
		
end else begin
	--with a as (
	--	select vinn = vn.ID, 
	--		Region = lr.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.LocationRegion lr on vn.locRegionID = lr.ID
	--	group by vn.ID, lr.Name
	--), b as (
	--	select vinn, count(*) cnt 
	--	from a 
	--	group by vinn having count(*) > 1
	--), c as (
	--	select n.* 
	--	from dbo.WAName n 
	--		join b on n.vinn = b.vinn
	--)
	--update c set 
	--	warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E23.Ambiguous eRP Region For This Vinn', 
	--	isVinnRegionAmbiguous = 1;

	----When there is no ambiguity on erpSide
	--with a as (
	--	select vinn = vn.ID, 
	--		Region = lr.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.LocationRegion lr on vn.locRegionID = lr.ID
	--	group by vn.ID, lr.Name
	--), aa as (
	--	select vinn, max(Region) Region2 
	--	from a 
	--	group by vinn having count(*) = 1
	--), b as (
	--	select z.*, aa.Region2 
	--	from dbo.WAName z 
	--		join aa on z.vinn = aa.vinn
	--)
	--update b set 
	--	erpRegion = Region2, 
	--	isErpRegionOK = 1, 
	--	isRegionTranslated = case when isNull(b.Region, '')  = isNull(Region2, '') then 0 else 1 end;

	----When JRegion is one of the eRp entries
	--with a as (
	--	select vinn = vn.ID, 
	--		Region = lr.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.LocationRegion lr on vn.locRegionID = lr.ID
	--	group by vn.ID, lr.Name
	--), b as (
	--	select z.* 
	--	from dbo.WAName z 
	--	where exists (select 1 from a where a.vinn = z.vinn and a.Region = z.Region)
	--)
	--update b set erpRegion = Region, isErpRegionOK = 1

	update WAName set 
		warnings = case 
			when Cnt > 1 then 
				case when warnings is null then '' else warnings + ',   ' end + 'E27.Ambiguous eRP Region For This Vinn'
			else warnings
		end,
		isVinnRegionAmbiguous = case when Cnt > 1 then 1 else 0 end,
		erpRegion = case when Cnt = 1 then Region2 else isnull(nullif(erpRegion, ''), Region2) end, 
		isErpRegionOK = case when Cnt = 1 or Region = Region2 then 1 else 0 end, 
		isRegionTranslated = case when isNull(Region, '') = isNull(Region2, '') then 0 else 1 end
	from WAName 
		join (
			select	VinN = vn.ID, 
					Region2 = max(lr.Name),
					Cnt = count(distinct lr.Name)
			from RPOWine.dbo.Wine_VinN vn 
				join RPOWine.dbo.LocationRegion lr on vn.locRegionID = lr.ID
			group by vn.ID
		) a on WAName.VinN = a.VinN

end

update dbo.WAName set 
	warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E39. Region Filled In From eRP'
where Region is null and eRPRegion is not null;

print '-- 9e. Location -- ' + cast(getdate() as varchar(30))
update dbo.WAName set isVinnLocationAmbiguous = 0, isErpLocationOK = 0, isLocationTranslated = 0, erpLocation = null;

if @IsUseOldWineN = 1 begin
	--with a as (
	--	select vinn = oldVinN, 
	--		Location = ll.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.LocationLocation ll on vn.locLocationID = ll.ID
	--	group by oldVinN, ll.Name
	--), b as (
	--	select vinn, count(*) cnt 
	--	from a 
	--	group by vinn having count(*) > 1
	--), c as (
	--	select n.* 
	--	from dbo.WAName n 
	--		join b on n.vinn = b.vinn
	--)
	--update c set 
	--	warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E22.Ambiguous eRP Location For This Vinn', 
	--	isVinnLocationAmbiguous = 1;

	----When there is no ambiguity on erpSide
	--with a as (
	--	select vinn = oldVinN, 
	--		Location = ll.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.LocationLocation ll on vn.locLocationID = ll.ID
	--	group by oldVinN, ll.Name
	--), aa as (
	--	select vinn, max(Location) Location2 
	--	from a 
	--	group by vinn having count(*) = 1
	--), b as (
	--	select z.*, aa.Location2 
	--	from dbo.WAName z 
	--		join aa on z.vinn = aa.vinn
	--)
	--update b set 
	--	erpLocation = Location2, 
	--	isErpLocationOK = 1, 
	--	isLocationTranslated = case when isNull(b.Location, '')  = isNull(Location2, '') then 0 else 1 end;

	----When JLocation is one of the eRp entries
	--with a as (
	--	select vinn = oldVinN, 
	--		Location = ll.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.LocationLocation ll on vn.locLocationID = ll.ID
	--	group by oldVinN, ll.Name
	--), b as (
	--	select z.* 
	--	from dbo.WAName z 
	--	where exists (select 1 from a where a.vinn = z.vinn and a.Location = z.Location)
	--)
	--update b set erpLocation = Location, isErpLocationOK = 1
	
	update WAName set 
		warnings = case 
			when Cnt > 1 then 
				case when warnings is null then '' else warnings + ',   ' end + 'E27.Ambiguous eRP Location For This Vinn'
			else warnings
		end,
		isVinnLocationAmbiguous = case when Cnt > 1 then 1 else 0 end,
		erpLocation = case when Cnt = 1 then Location2 else isnull(nullif(erpLocation, ''), Location2) end, 
		isErpLocationOK = case when Cnt = 1 or Location = Location2 then 1 else 0 end, 
		isLocationTranslated = case when isNull(Location, '') = isNull(Location2, '') then 0 else 1 end
	from WAName 
		join (
			select	VinN = oldVinN, 
					Location2 = max(ll.Name),
					Cnt = count(distinct ll.Name)
			from RPOWine.dbo.Wine_VinN vn 
				join RPOWine.dbo.LocationLocation ll on vn.locLocationID = ll.ID
			where isnull(oldVinN, 0) > 0
			group by oldVinN
		) a on WAName.VinN = a.VinN
		
end else begin
	--with a as (
	--	select vinn = vn.ID, 
	--		Location = ll.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.LocationLocation ll on vn.locLocationID = ll.ID
	--	group by vn.ID, ll.Name
	--), b as (
	--	select vinn, count(*) cnt 
	--	from a 
	--	group by vinn having count(*) > 1
	--), c as (
	--	select n.* 
	--	from dbo.WAName n 
	--		join b on n.vinn = b.vinn
	--)
	--update c set 
	--	warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E22.Ambiguous eRP Location For This Vinn', 
	--	isVinnLocationAmbiguous = 1;

	----When there is no ambiguity on erpSide
	--with a as (
	--	select vinn = vn.ID, 
	--		Location = ll.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.LocationLocation ll on vn.locLocationID = ll.ID
	--	group by vn.ID, ll.Name
	--), aa as (
	--	select vinn, max(Location) Location2 
	--	from a 
	--	group by vinn having count(*) = 1
	--), b as (
	--	select z.*, aa.Location2 
	--	from dbo.WAName z 
	--		join aa on z.vinn = aa.vinn
	--)
	--update b set 
	--	erpLocation = Location2, 
	--	isErpLocationOK = 1, 
	--	isLocationTranslated = case when isNull(b.Location, '')  = isNull(Location2, '') then 0 else 1 end;

	----When JLocation is one of the eRp entries
	--with a as (
	--	select vinn = vn.ID, 
	--		Location = ll.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.LocationLocation ll on vn.locLocationID = ll.ID
	--	group by vn.ID, ll.Name
	--), b as (
	--	select z.* 
	--	from dbo.WAName z 
	--	where exists (select 1 from a where a.vinn = z.vinn and a.Location = z.Location)
	--)
	--update b set erpLocation = Location, isErpLocationOK = 1
	
	update WAName set 
		warnings = case 
			when Cnt > 1 then 
				case when warnings is null then '' else warnings + ',   ' end + 'E27.Ambiguous eRP Location For This Vinn'
			else warnings
		end,
		isVinnLocationAmbiguous = case when Cnt > 1 then 1 else 0 end,
		erpLocation = case when Cnt = 1 then Location2 else isnull(nullif(erpLocation, ''), Location2) end, 
		isErpLocationOK = case when Cnt = 1 or Location = Location2 then 1 else 0 end, 
		isLocationTranslated = case when isNull(Location, '') = isNull(Location2, '') then 0 else 1 end
	from WAName 
		join (
			select	VinN = vn.ID, 
					Location2 = max(ll.Name),
					Cnt = count(distinct ll.Name)
			from RPOWine.dbo.Wine_VinN vn 
				join RPOWine.dbo.LocationLocation ll on vn.locLocationID = ll.ID
			group by vn.ID
		) a on WAName.VinN = a.VinN

end

update dbo.WAName set 
	warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E14.Location Filled In From eRP'
where Location is null and eRPLocation is not null;

print '-- 9f. Variety -- ' + cast(getdate() as varchar(30))
update dbo.WAName set isVinnVarietyAmbiguous = 0, isErpVarietyOK = 0, isVarietyTranslated = 0, erpVariety = null;

if @IsUseOldWineN = 1 begin
	--with a as (
	--	select vinn = oldVinN, 
	--		Variety = wv.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineVariety wv on vn.VarietyID = wv.ID
	--	group by oldVinN, wv.Name
	--), b as (
	--	select vinn, count(*) cnt 
	--	from a 
	--	group by vinn having count(*) > 1
	--), c as (
	--	select n.* 
	--	from dbo.WAName n 
	--		join b on n.vinn = b.vinn
	--)
	--update c set 
	--	warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E20.Ambiguous eRP Variety For This Vinn', 
	--	isVinnVarietyAmbiguous = 1;

	----When there is no ambiguity on erpSide
	--with a as (
	--	select vinn = oldVinN, 
	--		Variety = wv.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineVariety wv on vn.VarietyID = wv.ID
	--	group by oldVinN, wv.Name
	--), aa as (
	--	select vinn, max(Variety) Variety2 
	--	from a 
	--	group by vinn having count(*) = 1
	--), b as (
	--	select z.*, aa.Variety2 
	--	from dbo.WAName z 
	--		join aa on z.vinn = aa.vinn
	--)
	--update b set 
	--	erpVariety = Variety2, 
	--	isErpVarietyOK = 1, 
	--	isVarietyTranslated = case when isNull(b.Variety, '')  = isNull(Variety2, '') then 0 else 1 end;

	----When JVariety is one of the eRp entries
	--with a as (
	--	select vinn = oldVinN, 
	--		Variety = wv.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineVariety wv on vn.VarietyID = wv.ID
	--	group by oldVinN, wv.Name
	--), b as (
	--	select z.* 
	--	from dbo.WAName z 
	--	where exists (select 1 from a where a.vinn = z.vinn and a.Variety = z.Variety)
	--)
	--update b set erpVariety = Variety, isErpVarietyOK = 1;
	
	update WAName set 
		warnings = case 
			when Cnt > 1 then 
				case when warnings is null then '' else warnings + ',   ' end + 'E27.Ambiguous eRP Variety For This Vinn'
			else warnings
		end,
		isVinnVarietyAmbiguous = case when Cnt > 1 then 1 else 0 end,
		erpVariety = case when Cnt = 1 then Variety2 else isnull(nullif(erpVariety, ''), Variety2) end, 
		isErpVarietyOK = case when Cnt = 1 or Variety = Variety2 then 1 else 0 end, 
		isVarietyTranslated = case when isNull(Variety, '') = isNull(Variety2, '') then 0 else 1 end
	from WAName 
		join (
			select	VinN = oldVinN, 
					Variety2 = max(wv.Name),
					Cnt = count(distinct wv.Name)
			from RPOWine.dbo.Wine_VinN vn 
				join RPOWine.dbo.WineVariety wv on vn.VarietyID = wv.ID
			where isnull(oldVinN, 0) > 0
			group by oldVinN
		) a on WAName.VinN = a.VinN
		
end else begin
	--with a as (
	--	select vinn = vn.ID, 
	--		Variety = wv.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineVariety wv on vn.VarietyID = wv.ID
	--	group by vn.ID, wv.Name
	--), b as (
	--	select vinn, count(*) cnt 
	--	from a 
	--	group by vinn having count(*) > 1
	--), c as (
	--	select n.* 
	--	from dbo.WAName n 
	--		join b on n.vinn = b.vinn
	--)
	--update c set 
	--	warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E20.Ambiguous eRP Variety For This Vinn', 
	--	isVinnVarietyAmbiguous = 1;

	----When there is no ambiguity on erpSide
	--with a as (
	--	select vinn = vn.ID, 
	--		Variety = wv.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineVariety wv on vn.VarietyID = wv.ID
	--	group by vn.ID, wv.Name
	--), aa as (
	--	select vinn, max(Variety) Variety2 
	--	from a 
	--	group by vinn having count(*) = 1
	--), b as (
	--	select z.*, aa.Variety2 
	--	from dbo.WAName z 
	--		join aa on z.vinn = aa.vinn
	--)
	--update b set 
	--	erpVariety = Variety2, 
	--	isErpVarietyOK = 1, 
	--	isVarietyTranslated = case when isNull(b.Variety, '')  = isNull(Variety2, '') then 0 else 1 end;

	----When JVariety is one of the eRp entries
	--with a as (
	--	select vinn = vn.ID, 
	--		Variety = wv.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineVariety wv on vn.VarietyID = wv.ID
	--	group by vn.ID, wv.Name
	--), b as (
	--	select z.* 
	--	from dbo.WAName z 
	--	where exists (select 1 from a where a.vinn = z.vinn and a.Variety = z.Variety)
	--)
	--update b set erpVariety = Variety, isErpVarietyOK = 1;

	update WAName set 
		warnings = case 
			when Cnt > 1 then 
				case when warnings is null then '' else warnings + ',   ' end + 'E27.Ambiguous eRP Variety For This Vinn'
			else warnings
		end,
		isVinnVarietyAmbiguous = case when Cnt > 1 then 1 else 0 end,
		erpVariety = case when Cnt = 1 then Variety2 else isnull(nullif(erpVariety, ''), Variety2) end, 
		isErpVarietyOK = case when Cnt = 1 or Variety = Variety2 then 1 else 0 end, 
		isVarietyTranslated = case when isNull(Variety, '') = isNull(Variety2, '') then 0 else 1 end
	from WAName 
		join (
			select	VinN = vn.ID, 
					Variety2 = max(wv.Name),
					Cnt = count(distinct wv.Name)
			from RPOWine.dbo.Wine_VinN vn 
				join RPOWine.dbo.WineVariety wv on vn.VarietyID = wv.ID
			group by vn.ID
		) a on WAName.VinN = a.VinN

end

update dbo.WAName set 
	warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E40. Variety Filled In From eRP'
where Variety is null and eRPVariety is not null;

print '-- 9g. ColorClass -- ' + cast(getdate() as varchar(30))
update dbo.WAName set isVinnColorClassAmbiguous = 0, isErpColorClassOK = 0, isColorClassTranslated = 0, erpColorClass = null;

if @IsUseOldWineN = 1 begin
	--with a as (
	--	select vinn = oldVinN, 
	--		ColorClass = wc.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineColor wc on vn.ColorID = wc.ID
	--	group by oldVinN, wc.Name
	--), b as (
	--	select vinn, count(*) cnt 
	--	from a 
	--	group by vinn having count(*) > 1
	--), c as (
	--	select n.* 
	--	from dbo.WAName n 
	--		join b on n.vinn = b.vinn
	--)
	--update c set 
	--	warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E20.Ambiguous eRP ColorClass For This Vinn', 
	--	isVinnColorClassAmbiguous = 1;

	----When there is no ambiguity on erpSide
	--; with a as (
	--	select vinn = oldVinN, 
	--		ColorClass = wc.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineColor wc on vn.ColorID = wc.ID
	--	group by oldVinN, wc.Name
	--), aa as (
	--	select vinn, max(ColorClass) ColorClass2 
	--	from a 
	--	group by vinn having count(*) = 1
	--), b as (
	--	select z.*, aa.ColorClass2 
	--	from dbo.WAName z 
	--		join aa on z.vinn = aa.vinn
	--)
	--update b set 
	--	erpColorClass = ColorClass2, 
	--	isErpColorClassOK = 1, 
	--	isColorClassTranslated = case when isNull(b.ColorClass, '')  = isNull(ColorClass2, '') then 0 else 1 end;

	----When JColorClass is one of the eRp entries
	--; with a as (
	--	select vinn = oldVinN, 
	--		ColorClass = wc.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineColor wc on vn.ColorID = wc.ID
	--	group by oldVinN, wc.Name
	--), b as (
	--	select z.* 
	--	from dbo.WAName z 
	--	where exists (select 1 from a where a.vinn = z.vinn and a.ColorClass = z.ColorClass)
	--)
	--update b set erpColorClass = ColorClass, isErpColorClassOK = 1;
	
	update WAName set 
		warnings = case 
			when Cnt > 1 then 
				case when warnings is null then '' else warnings + ',   ' end + 'E27.Ambiguous eRP ColorClass For This Vinn'
			else warnings
		end,
		isVinnColorClassAmbiguous = case when Cnt > 1 then 1 else 0 end,
		erpColorClass = case when Cnt = 1 then ColorClass2 else isnull(nullif(erpColorClass, ''), ColorClass2) end, 
		isErpColorClassOK = case when Cnt = 1 or ColorClass = ColorClass2 then 1 else 0 end, 
		isColorClassTranslated = case when isNull(ColorClass, '') = isNull(ColorClass2, '') then 0 else 1 end
	from WAName 
		join (
			select	VinN = oldVinN, 
					ColorClass2 = max(wc.Name),
					Cnt = count(distinct wc.Name)
			from RPOWine.dbo.Wine_VinN vn 
				join RPOWine.dbo.WineColor wc on vn.ColorID = wc.ID
			where isnull(oldVinN, 0) > 0
			group by oldVinN
		) a on WAName.VinN = a.VinN
		
end else begin
	--; with a as (
	--	select vinn = vn.ID, 
	--		ColorClass = wc.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineColor wc on vn.ColorID = wc.ID
	--	group by vn.ID, wc.Name
	--), b as (
	--	select vinn, count(*) cnt 
	--	from a 
	--	group by vinn having count(*) > 1
	--), c as (
	--	select n.* 
	--	from dbo.WAName n 
	--		join b on n.vinn = b.vinn
	--)
	--update c set 
	--	warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E20.Ambiguous eRP ColorClass For This Vinn', 
	--	isVinnColorClassAmbiguous = 1;

	----When there is no ambiguity on erpSide
	--; with a as (
	--	select vinn = vn.ID, 
	--		ColorClass = wc.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineColor wc on vn.ColorID = wc.ID
	--	group by vn.ID, wc.Name
	--), aa as (
	--	select vinn, max(ColorClass) ColorClass2 
	--	from a 
	--	group by vinn having count(*) = 1
	--), b as (
	--	select z.*, aa.ColorClass2 
	--	from dbo.WAName z 
	--		join aa on z.vinn = aa.vinn
	--)
	--update b set 
	--	erpColorClass = ColorClass2, 
	--	isErpColorClassOK = 1, 
	--	isColorClassTranslated = case when isNull(b.ColorClass, '')  = isNull(ColorClass2, '') then 0 else 1 end;

	----When JColorClass is one of the eRp entries
	--with a as (
	--	select vinn = vn.ID, 
	--		ColorClass = wc.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineColor wc on vn.ColorID = wc.ID
	--	group by vn.ID, wc.Name
	--), b as (
	--	select z.* 
	--	from dbo.WAName z 
	--	where exists (select 1 from a where a.vinn = z.vinn and a.ColorClass = z.ColorClass)
	--)
	--update b set erpColorClass = ColorClass, isErpColorClassOK = 1;

	update WAName set 
		warnings = case 
			when Cnt > 1 then 
				case when warnings is null then '' else warnings + ',   ' end + 'E27.Ambiguous eRP ColorClass For This Vinn'
			else warnings
		end,
		isVinnColorClassAmbiguous = case when Cnt > 1 then 1 else 0 end,
		erpColorClass = case when Cnt = 1 then ColorClass2 else isnull(nullif(erpColorClass, ''), ColorClass2) end, 
		isErpColorClassOK = case when Cnt = 1 or ColorClass = ColorClass2 then 1 else 0 end, 
		isColorClassTranslated = case when isNull(ColorClass, '') = isNull(ColorClass2, '') then 0 else 1 end
	from WAName 
		join (
			select	VinN = vn.ID, 
					ColorClass2 = max(wc.Name),
					Cnt = count(distinct wc.Name)
			from RPOWine.dbo.Wine_VinN vn 
				join RPOWine.dbo.WineColor wc on vn.ColorID = wc.ID
			group by vn.ID
		) a on WAName.VinN = a.VinN

end

update dbo.WAName set 
	warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E41. ColorClass Filled In From eRP'
where ColorClass is null and eRPColorClass is not null;

print '-- 9h. Dryness -- ' + cast(getdate() as varchar(30))
update dbo.WAName set isVinnDrynessAmbiguous = 0, isErpDrynessOK = 0, isDrynessTranslated = 0, erpDryness = null;

if @IsUseOldWineN = 1 begin
	--with a as (
	--	select vinn = oldVinN, 
	--		Dryness = wd.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineDryness wd on vn.DrynessID = wd.ID
	--	group by oldVinN, wd.Name
	--), b as (
	--	select vinn, count(*) cnt 
	--	from a 
	--	group by vinn having count(*) > 1
	--), c as (
	--	select n.* 
	--	from dbo.WAName n 
	--		join b on n.vinn = b.vinn
	--)
	--update c set 
	--	warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E27.Ambiguous eRP Dryness For This Vinn', 
	--	isVinnDrynessAmbiguous = 1;

	--When there is no ambiguity on erpSide
	--with a as (
	--	select vinn = oldVinN, 
	--		Dryness = wd.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineDryness wd on vn.DrynessID = wd.ID
	--	group by oldVinN, wd.Name
	--), aa as (
	--	select vinn, max(Dryness) Dryness2 
	--	from a 
	--	group by vinn having count(*) = 1
	--), b as (
	--	select z.*, aa.Dryness2 
	--	from dbo.WAName z 
	--		join aa on z.vinn = aa.vinn
	--)
	--update b set 
	--	erpDryness = Dryness2, 
	--	isErpDrynessOK = 1, 
	--	isDrynessTranslated = case when isNull(b.Dryness, '')  = isNull(Dryness2, '') then 0 else 1 end;

	update WAName set 
		warnings = case 
			when Cnt > 1 then 
				case when warnings is null then '' else warnings + ',   ' end + 'E27.Ambiguous eRP Dryness For This Vinn'
			else warnings
		end,
		isVinnDrynessAmbiguous = case when Cnt > 1 then 1 else 0 end,
		erpDryness = case when Cnt = 1 then Dryness2 else isnull(nullif(erpDryness, ''), Dryness2) end, 
		isErpDrynessOK = case when Cnt = 1 or Dryness = Dryness2 then 1 else 0 end, 
		isDrynessTranslated = case when isNull(Dryness, '') = isNull(Dryness2, '') then 0 else 1 end
	from WAName 
		join (
			select	VinN = oldVinN, 
					Dryness2 = max(wd.Name),
					Cnt = count(distinct wd.Name)
			from RPOWine.dbo.Wine_VinN vn 
				join RPOWine.dbo.WineDryness wd on vn.DrynessID = wd.ID
			where isnull(oldVinN, 0) > 0
			group by oldVinN
		) a on WAName.VinN = a.VinN
end else begin
	--with a as (
	--	select vinn = vn.ID, 
	--		Dryness = wd.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineDryness wd on vn.DrynessID = wd.ID
	--	group by vn.ID, wd.Name
	--), b as (
	--	select vinn, count(*) cnt 
	--	from a 
	--	group by vinn having count(*) > 1
	--), c as (
	--	select n.* 
	--	from dbo.WAName n 
	--		join b on n.vinn = b.vinn
	--)
	--update c set 
	--	warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E27.Ambiguous eRP Dryness For This Vinn', 
	--	isVinnDrynessAmbiguous = 1;

	--When there is no ambiguity on erpSide
	--with a as (
	--	select vinn = vn.ID, 
	--		Dryness = wd.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineDryness wd on vn.DrynessID = wd.ID
	--	group by vn.ID, wd.Name
	--), aa as (
	--	select vinn, max(Dryness) Dryness2 
	--	from a 
	--	group by vinn having count(*) = 1
	--), b as (
	--	select z.*, aa.Dryness2 
	--	from dbo.WAName z 
	--		join aa on z.vinn = aa.vinn
	--)
	--update b set 
	--	erpDryness = Dryness2, 
	--	isErpDrynessOK = 1, 
	--	isDrynessTranslated = case when isNull(b.Dryness, '')  = isNull(Dryness2, '') then 0 else 1 end;

	-- THIS problem does NOT exist in the new structure!
	update WAName set 
		warnings = case 
			when Cnt > 1 then 
				case when warnings is null then '' else warnings + ',   ' end + 'E27.Ambiguous eRP Dryness For This Vinn'
			else warnings
		end,
		isVinnDrynessAmbiguous = case when Cnt > 1 then 1 else 0 end,
		erpDryness = case when Cnt = 1 then Dryness2 else isnull(nullif(erpDryness, ''), Dryness2) end, 
		isErpDrynessOK = case when Cnt = 1 or Dryness = Dryness2 then 1 else 0 end, 
		isDrynessTranslated = case when isNull(Dryness, '') = isNull(Dryness2, '') then 0 else 1 end
	from WAName 
		join (
			select	VinN = vn.ID, 
					Dryness2 = max(wd.Name),
					Cnt = count(distinct wd.Name)
			from RPOWine.dbo.Wine_VinN vn 
				join RPOWine.dbo.WineDryness wd on vn.DrynessID = wd.ID
			group by vn.ID
		) a on WAName.VinN = a.VinN
end

update dbo.WAName set 
	warnings = case when warnings  is null then '' else warnings + ',   ' end + 'E28.Dryness Filled In From eRP'
where Dryness is null and eRPDryness is not null;

print '-- 9i. WineType -- ' + cast(getdate() as varchar(30))
update dbo.WAName set isVinnWineTypeAmbiguous = 0, isErpWineTypeOK = 0, isWineTypeTranslated = 0, erpWineType = null;

if @IsUseOldWineN = 1 begin
	--with a as (
	--	select vinn = oldVinN, 
	--		Dryness = wt.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineType wt on vn.TypeID = wt.ID
	--	group by oldVinN, wt.Name
	--), b as (
	--	select vinn, count(*) cnt 
	--	from a 
	--	group by vinn having count(*) > 1
	--), c as (
	--	select n.* 
	--	from dbo.WAName n 
	--		join b on n.vinn = b.vinn
	--)
	--update c set 
	--	warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E25.Ambiguous eRP WineType For This Vinn', 
	--	isVinnWineTypeAmbiguous = 1;

	----When there is no ambiguity on erpSide
	--with a as (
	--	select vinn = oldVinN, 
	--		WineType = wt.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineType wt on vn.TypeID = wt.ID
	--	group by oldVinN, wt.Name
	--), aa as (
	--	select vinn, max(WineType) WineType2 
	--	from a 
	--	group by vinn having count(*) = 1
	--), b as (
	--	select z.*, aa.WineType2 
	--	from dbo.WAName z 
	--		join aa on z.vinn = aa.vinn
	--)
	--update b set 
	--	erpWineType = WineType2, 
	--	isErpWineTypeOK = 1, 
	--	isWineTypeTranslated = case when isNull(b.WineType, '')  = isNull(WineType2, '') then 0 else 1 end;

	----When JWineType is one of the eRp entries
	--with a as (
	--	select vinn = oldVinN, 
	--		WineType = wt.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineType wt on vn.TypeID = wt.ID
	--	group by oldVinN, wt.Name
	--), b as (
	--	select z.* 
	--	from dbo.WAName z 
	--	where exists (select 1 from a where a.vinn = z.vinn and a.WineType = z.WineType)
	--)
	--update b set erpWineType = WineType, isErpWineTypeOK = 1;

	update WAName set 
		warnings = case 
			when Cnt > 1 then 
				case when warnings is null then '' else warnings + ',   ' end + 'E27.Ambiguous eRP WineType For This Vinn'
			else warnings
		end,
		isVinnWineTypeAmbiguous = case when Cnt > 1 then 1 else 0 end,
		erpWineType = case when Cnt = 1 then WineType2 else isnull(nullif(erpWineType, ''), WineType2) end, 
		isErpWineTypeOK = case when Cnt = 1 or WineType = WineType2 then 1 else 0 end, 
		isWineTypeTranslated = case when isNull(WineType, '') = isNull(WineType2, '') then 0 else 1 end
	from WAName 
		join (
			select	VinN = oldVinN, 
					WineType2 = max(wt.Name),
					Cnt = count(distinct wt.Name)
			from RPOWine.dbo.Wine_VinN vn 
				join RPOWine.dbo.WineType wt on vn.TypeID = wt.ID
			where isnull(oldVinN, 0) > 0
			group by oldVinN
		) a on WAName.VinN = a.VinN
		
end else begin
	--with a as (
	--	select vinn = vn.ID, 
	--		Dryness = wt.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineType wt on vn.TypeID = wt.ID
	--	group by vn.ID, wt.Name
	--), b as (
	--	select vinn, count(*) cnt 
	--	from a 
	--	group by vinn having count(*) > 1
	--), c as (
	--	select n.* 
	--	from dbo.WAName n 
	--		join b on n.vinn = b.vinn
	--)
	--update c set 
	--	warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E25.Ambiguous eRP WineType For This Vinn', 
	--	isVinnWineTypeAmbiguous = 1;

	----When there is no ambiguity on erpSide
	--with a as (
	--	select vinn = vn.ID, 
	--		WineType = wt.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineType wt on vn.TypeID = wt.ID
	--	group by vn.ID, wt.Name
	--), aa as (
	--	select vinn, max(WineType) WineType2 
	--	from a 
	--	group by vinn having count(*) = 1
	--), b as (
	--	select z.*, aa.WineType2 
	--	from dbo.WAName z 
	--		join aa on z.vinn = aa.vinn
	--)
	--update b set 
	--	erpWineType = WineType2, 
	--	isErpWineTypeOK = 1, 
	--	isWineTypeTranslated = case when isNull(b.WineType, '')  = isNull(WineType2, '') then 0 else 1 end;

	----When JWineType is one of the eRp entries
	--with a as (
	--	select vinn = vn.ID, 
	--		WineType = wt.Name
	--	from RPOWine.dbo.Wine_VinN vn 
	--		join RPOWine.dbo.WineType wt on vn.TypeID = wt.ID
	--	group by vn.ID, wt.Name
	--), b as (
	--	select z.* 
	--	from dbo.WAName z 
	--	where exists (select 1 from a where a.vinn = z.vinn and a.WineType = z.WineType)
	--)
	--update b set erpWineType = WineType, isErpWineTypeOK = 1;

	update WAName set 
		warnings = case 
			when Cnt > 1 then 
				case when warnings is null then '' else warnings + ',   ' end + 'E27.Ambiguous eRP WineType For This Vinn'
			else warnings
		end,
		isVinnWineTypeAmbiguous = case when Cnt > 1 then 1 else 0 end,
		erpWineType = case when Cnt = 1 then WineType2 else isnull(nullif(erpWineType, ''), WineType2) end, 
		isErpWineTypeOK = case when Cnt = 1 or WineType = WineType2 then 1 else 0 end, 
		isWineTypeTranslated = case when isNull(WineType, '') = isNull(WineType2, '') then 0 else 1 end
	from WAName 
		join (
			select	VinN = vn.ID, 
					WineType2 = max(wt.Name),
					Cnt = count(distinct wt.Name)
			from RPOWine.dbo.Wine_VinN vn 
				join RPOWine.dbo.WineType wt on vn.TypeID = wt.ID
			group by vn.ID
		) a on WAName.VinN = a.VinN

end

update dbo.WAName set 
	warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E26.WineType Filled In From eRP'
where WineType is null and eRPWineType is not null;

print '-- 9j. Unresovable Vinns -- ' + cast(getdate() as varchar(30))
if @IsUseOldWineN = 1 begin
	--; with a as (
	--	select distinct 
	--		vinn = oldVinN
	--	from RPOWine.dbo.Wine_VinN vn
	--), b as (
	--	select z.* 
	--	from dbo.WAName z 
	--	where isNull(isTempVinn, 0) = 0 and exists (select 1 from a where a.vinn = z.vinn)
	--)
	--update b set 
	--	errors = case when errors is null then '' else errors + '   ' end + 'E42.  Vinn Producer Unresolvable'
	--where isErpProducerOK = 0;

	--with a as (
	--	select distinct 
	--		vinn = oldVinN
	--	from RPOWine.dbo.Wine_VinN vn
	--), b as (
	--	select z.* 
	--	from dbo.WAName z 
	--	where isNull(isTempVinn,0) = 0 and exists (select 1 from a where a.vinn = z.vinn)
	--)
	--update b set 
	--	errors = case when errors is null then '' else errors + '   ' end + 'E43.  Vinn LabelName Unresolvable'  
	--where isErpLabelNameOK = 0;

	--with a as (
	--	select distinct 
	--		vinn = oldVinN
	--	from RPOWine.dbo.Wine_VinN vn
	--), b as (
	--	select z.* 
	--	from dbo.WAName z 
	--	where isNull(isTempVinn,0) = 0 and exists (select 1 from a where a.vinn = z.vinn)
	--)
	--update b set 
	--	errors = case when errors is null then '' else errors + '   ' end + 'E44.  Vinn ColorClass Unresolvable'  
	--where isErpColorClassOK = 0
	
	update WAName set 
		errors = case when errors is null then '' else errors + '   ' end 
			+ case when isErpProducerOK = 0 then 'E42.  Vinn Producer Unresolvable  ' else ' ' end
			+ case when isErpLabelNameOK = 0 then 'E43.  Vinn LabelName Unresolvable  ' else ' ' end
			+ case when isErpColorClassOK = 0 then 'E44.  Vinn ColorClass Unresolvable  ' else ' ' end
	from WAName wan
		join RPOWine.dbo.Wine_VinN vn on wan.VinN = vn.oldVinN
	where isNull(isTempVinn,0) = 0 and isnull(vn.oldVinN, 0) > 0
	
end else begin
	--; with a as (
	--	select distinct 
	--		vinn = vn.ID 
	--	from RPOWine.dbo.Wine_VinN vn
	--), b as (
	--	select z.* 
	--	from dbo.WAName z 
	--	where isNull(isTempVinn, 0) = 0 and exists (select 1 from a where a.vinn = z.vinn)
	--)
	--update b set 
	--	errors = case when errors is null then '' else errors + '   ' end + 'E42.  Vinn Producer Unresolvable'
	--where isErpProducerOK = 0;

	--with a as (
	--	select distinct 
	--		vinn = vn.ID 
	--	from RPOWine.dbo.Wine_VinN vn
	--), b as (
	--	select z.* 
	--	from dbo.WAName z 
	--	where isNull(isTempVinn,0) = 0 and exists (select 1 from a where a.vinn = z.vinn)
	--)
	--update b set 
	--	errors = case when errors is null then '' else errors + '   ' end + 'E43.  Vinn LabelName Unresolvable'  
	--where isErpLabelNameOK = 0;

	--with a as (
	--	select distinct 
	--		vinn = vn.ID
	--	from RPOWine.dbo.Wine_VinN vn
	--), b as (
	--	select z.* 
	--	from dbo.WAName z 
	--	where isNull(isTempVinn,0) = 0 and exists (select 1 from a where a.vinn = z.vinn)
	--)
	--update b set 
	--	errors = case when errors is null then '' else errors + '   ' end + 'E44.  Vinn ColorClass Unresolvable'  
	--where isErpColorClassOK = 0
	
	update WAName set 
		errors = case when errors is null then '' else errors + '   ' end 
			+ case when isErpProducerOK = 0 then 'E42.  Vinn Producer Unresolvable  ' else ' ' end
			+ case when isErpLabelNameOK = 0 then 'E43.  Vinn LabelName Unresolvable  ' else ' ' end
			+ case when isErpColorClassOK = 0 then 'E44.  Vinn ColorClass Unresolvable  ' else ' ' end
	from WAName wan
		join RPOWine.dbo.Wine_VinN vn on wan.VinN = vn.ID
	where isNull(isTempVinn,0) = 0
end

print '-- 10 AssignVinnAndWineToForSale -- ' + cast(getdate() as varchar(30))
exec LogMsg 'Import Stage 11';

--create new Vinn
update dbo.WAName set isTempVinn = 0;
update dbo.WAName set vinn = -idN, isTempVinn = 1 where vinn is null or vinn < 0;

--Deduce WineN
if @IsUseOldWineN = 1 begin
	with a as (
		select 
			vinn = oldVinN, 
			vintage, 
			wineN = oldWineN
		from RPOWine.dbo.Wine 
		where vinn is not null and vintage is not null and wineN is not null 
		group by 
			oldVinN, vintage, oldWineN
	), b as (
		select vinn, vintage, min(wineN) wineN 
		from a 
		group by vinn, vintage having count(*) >1
	), c as (
		select n.* 
		from dbo.WAName n 
			join b on n.vinn = b.vinn
	)
	update c set 
		warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E17.Ambiguous eRP WineN For Some Vintages';

	with a as (
		select 
			vinn = oldVinN, 
			vintage, 
			wineN = oldWineN
		from RPOWine.dbo.Wine
		where vinn is not null and vintage is not null and wineN is not null 
		group by oldVinN, vintage, oldWineN
	), b as (
		select vinn, vintage, min(wineN) wineN 
		from a 
		group by vinn, vintage having count(*) >1
	), c as (
		select s.*, vinN 
		from dbo.ForSale s 
			left join dbo.WAName n on s.wid = n.wid
	), d as (
		select c.* 
		from c 
			join b on c.vinn = b.vinn and c.vintage = b.vintage
	)
	update d set 
		warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E18.Ambiguous eRP WineN Given WineAlertId=>Vinn';

	with a as (
		select 
			vinn = oldVinN, 
			vintage, 
			wineN = oldWineN
		from RPOWine.dbo.Wine
		where vinn is not null and vintage is not null and wineN is not null 
		group by oldVinN, vintage, oldWineN
	), b as (
		select vinn, vintage, min(wineN) wineN 
		from a 
		group by vinn, vintage having count(*) = 1
	), c as (
		select s.*, vinn 
		from dbo.ForSale s 
			left join dbo.WAName n on s.wid = n.wid 
		where n.errors is null and wineN is null and vinn > 0
	), d as (
		select c.*, b.wineN bWineN 
		from c 
			join b on c.vinn = b.vinn and c.vintage = b.vintage
	)
	update d set wineN = bWineN, isWineNDeduced = 1;
end else begin
	with a as (
		select 
			vinn = VinN, 
			vintage, 
			wineN = WineN
		from RPOWine.dbo.Wine 
		where vinn is not null and vintage is not null and wineN is not null 
		group by VinN, vintage, WineN
	), b as (
		select vinn, vintage, min(wineN) wineN 
		from a 
		group by vinn, vintage having count(*) >1
	), c as (
		select n.* 
		from dbo.WAName n 
			join b on n.vinn = b.vinn
	)
	update c set 
		warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E17.Ambiguous eRP WineN For Some Vintages';

	with a as (
		select 
			vinn = VinN, 
			vintage, 
			wineN = WineN
		from RPOWine.dbo.Wine
		where vinn is not null and vintage is not null and wineN is not null 
		group by VinN, vintage, WineN
	), b as (
		select vinn, vintage, min(wineN) wineN 
		from a 
		group by vinn, vintage having count(*) >1
	), c as (
		select s.*, vinN 
		from dbo.ForSale s 
			left join dbo.WAName n on s.wid = n.wid
	), d as (
		select c.* 
		from c 
			join b on c.vinn = b.vinn and c.vintage = b.vintage
	)
	update d set 
		warnings = case when warnings  is null then ''else warnings + ',   ' end + 'E18.Ambiguous eRP WineN Given WineAlertId=>Vinn';

	with a as (
		select 
			vinn = VinN, 
			vintage, 
			wineN = WineN
		from RPOWine.dbo.Wine
		where vinn is not null and vintage is not null and wineN is not null 
		group by VinN, vintage, WineN
	), b as (
		select vinn, vintage, min(wineN) wineN 
		from a 
		group by vinn, vintage having count(*) = 1
	), c as (
		select s.*, vinn 
		from dbo.ForSale s 
			left join dbo.WAName n on s.wid = n.wid 
		where n.errors is null and wineN is null and vinn > 0
	), d as (
		select c.*, b.wineN bWineN 
		from c 
			join b on c.vinn = b.vinn and c.vintage = b.vintage
	)
	update d set wineN = bWineN, isWineNDeduced = 1;
end

update dbo.ForSale set isTempWineN = 0;
update dbo.ForSale set wineN = - idN, isTempWineN = 1 where wineN is null;

print '-- 10a. Set isActiveForSaleWineN -- ' + cast(getdate() as varchar(30))
--This is tricky to set correctly.  We need this to choose when Julian has multiple Wid that lead to the same WineN

update dbo.ForSale set isActiveForSaleWineN = 0;

--when there is only one wineN, make it active (even if it's deduced)
with a as (
	select WineN 
	from dbo.ForSale 
	group by wineN having count(*) = 1
), b as (
	select s.* 
	from dbo.ForSale s 
		join a on s.wineN = a.wineN
)
update b set isActiveForSaleWineN = 1;

--look for wineN where there is only one non deduced record
with a as (
	select wineN 
	from dbo.ForSale 
	where isWineNDeduced = 0 
	group by wineN having count(*) = 1
), b as (
	select s.* 
	from dbo.ForSale s 
		join a on s.wineN = a.wineN 
	where isActiveForSaleWineN = 0
)
update b set isActiveForSaleWineN = 1;

--Flag the ambiguous ones
with a as (
	select wineN 
	from dbo.ForSale 
	where isActiveForSaleWineN = 1 
	group by wineN
), b as (
	select s.wineN 
	from dbo.ForSale s 
		left join a on s.wineN = a.wineN 
	where a.wineN is null 
	group by s.wineN
), c as (
	select s.* 
	from dbo.ForSale s 
		join b on s.wineN = b.wineN
)
update c set 
	warnings = case when warnings is null then '' else warnings + ' ' end + 'E33.  Ambiguous choice of isActiveForSaleWineN';

--Set one with max priceCnt----------
with a as (
	select wineN 
	from dbo.ForSale 
	where isActiveForSaleWineN = 1 
	group by wineN
), b as (
	select distinct s.wineN 
	from dbo.ForSale s 
		left join a on s.wineN = a.wineN 
	where a.wineN is null
), c as (
	select s.wineN, max(priceCnt) maxPriceCnt 
	from dbo.ForSale s 
		join b on s.wineN = b.wineN 
	group by s.wineN
), d as (
	select max(idN) idN 
	from dbo.ForSale s 
		join c on c.wineN = s.wineN and s.priceCnt = c.maxPriceCnt 
	group by s.wineN
), e as (
	select isActiveForSaleWineN 
	from dbo.ForSale s 
		join d on s.idN = d.idN
)
update e set isActiveForSaleWineN = 1;

print '-- 11a. Recreate dbo.Wine from RPOWineData -- ' + cast(getdate() as varchar(30))
--CopyToSearchWine
--exec LogMsg 'Import Stage 12';
exec LogMsg 'Import Stage 13';

delete from dbo.Wine;

--add in activeWineN (erp reviews)
insert into dbo.Wine(
	--ArticleId, ArticleIdNKey, ArticleOrder, BottleSize, BottlesPerCosting, 
	ClumpName, ColorClass, 
	--combinedLocation, DateUpdated, erpTastingCount, EstimatedCost_Hi, 
	Country, DrinkDate, DrinkDate_Hi, Dryness, encodedKeyWords, EstimatedCost, FixedId, 
	--hasAGalloniTasting, hasDSchildknechtTasting,hasDThomasesTasting, hasErpTasting, hasJMillerTasting, 
	--hasMSquiresTasting, hasMultipleWATastings, hasNMartinTasting, HasProducerWebSite, hasPRovaniTasting, hasRParkerTasting, 
	hasWjTasting, 
	--IsActiveTasting, IsActiveWineN_old, IsBarrelTasting, isBorrowedDrinkDate, 
	IsActiveWineN, Issue, isErpTasting, isWJTasting, 
	LabelName, Locale, Location, Maturity, Notes, 
	--Pages, 
	Places, Producer, producerProfileFileName, ProducerShow,
	ProducerURL, Publication, Rating, 
	--Rating_Hi, RatingQ, shortLabelName, SomeYearHasPrices,TastingCount,ThisYearHasPrices,WhoUpdated,
	Region,ReviewerIdN,shortTitle,Site,
	Source,SourceDate,Variety,VinN,Vintage,WineN,WineType, oldWineN) 
select --ArticleId,ArticleIdNKey,ArticleOrder,BottleSize,BottlesPerCosting,
	ClumpName, ColorClass,
	--combinedLocation, DateUpdated, erpTastingCount, EstimatedCost_Hi,
	Country, DrinkDate,DrinkDate_Hi,Dryness,encodedKeyWords, EstimatedCost, FixedId,
	--hasAGalloniTasting,hasDSchildknechtTasting,hasDThomasesTasting,hasErpTasting,hasJMillerTasting,
	--hasMSquiresTasting,hasMultipleWATastings,hasNMartinTasting,HasProducerWebSite,hasPRovaniTasting,hasRParkerTasting,
	hasWjTasting,
	--IsActiveTasting, IsActiveWineN_old,IsBarrelTasting, isBorrowedDrinkDate, 
	IsActiveWineN, Issue, isErpTasting, isWJTasting,
	LabelName,Locale,Location,Maturity,Notes,
	--Pages,
	Places,Producer,producerProfileFileName,ProducerShow,
	ProducerURL,Publication,Rating,
	--Rating_Hi,RatingQ, shortLabelName, SomeYearHasPrices, TastingCount,ThisYearHasPrices, WhoUpdated,
	Region,ReviewerIdN,shortTitle,Site, 
	Source,SourceDate,Variety,VinN,Vintage,WineN,WineType, oldWineN
from RPOWine.dbo.Wine
where isActiveWineN = 1;

--------- TODO: check optimization! Last time took 4:28:13 to run.
--------- DONE! Took 1 sec on real data on 4/13/14
with w as (
	select wineN=wn.ID, fixedId=tn.oldFixedId, SourceDate=tn.oldSourceDate 
	from RPOWine.dbo.TasteNote tn (nolock) 
		join RPOWine.dbo.Wine_N wn (nolock) on wn.ID = tn.Wine_N_ID
	where tn.oldReviewerIdN = 2
), b as (
	select wineN, fixedid = min(fixedid), sourceDate from w group by wineN, sourceDate
), c as (
	select wineN, sourceDate = max(sourceDate) from b group by wineN
)
--,fixed as (select fixedId from b join c on b.wineN = c.wineN and b.sourceDate = c.sourceDate)
,d as (
	select fixedId 
	from b join c on b.wineN = c.wineN and isNull(b.sourceDate, '1/1/2000') = isNull(c.sourceDate, '1/1/2000')
), e as (
	select wineN from dbo.Wine where source like '%martin%' group by wineN
)
insert into dbo.Wine(
	--ArticleId, ArticleIdNKey, ArticleOrder, BottleSize, BottlesPerCosting, 
	ClumpName, ColorClass, 
	--combinedLocation, DateUpdated, erpTastingCount, EstimatedCost_Hi, 
	Country, DrinkDate, DrinkDate_Hi, Dryness, encodedKeyWords, EstimatedCost, FixedId, 
	--hasAGalloniTasting, hasDSchildknechtTasting,hasDThomasesTasting, hasErpTasting, hasJMillerTasting, 
	--hasMSquiresTasting, hasMultipleWATastings, hasNMartinTasting, HasProducerWebSite, hasPRovaniTasting, hasRParkerTasting, 
	hasWjTasting, 
	--IsActiveTasting, IsActiveWineN_old, IsBarrelTasting, isBorrowedDrinkDate, 
	IsActiveWineN, Issue, isErpTasting, isWJTasting, 
	LabelName, Locale, Location, Maturity, Notes, 
	--Pages, 
	Places, Producer, producerProfileFileName, ProducerShow,
	ProducerURL, Publication, Rating, 
	--Rating_Hi, RatingQ, shortLabelName, SomeYearHasPrices,TastingCount,ThisYearHasPrices,WhoUpdated,
	Region,ReviewerIdN,shortTitle,Site,
	Source,SourceDate,Variety,VinN,Vintage,WineN,WineType, oldWineN)
select 	
	ClumpName, ColorClass,
	--combinedLocation, DateUpdated, erpTastingCount, EstimatedCost_Hi,
	Country, DrinkDate,DrinkDate_Hi,Dryness,encodedKeyWords, EstimatedCost, FixedId,
	--hasAGalloniTasting,hasDSchildknechtTasting,hasDThomasesTasting,hasErpTasting,hasJMillerTasting,
	--hasMSquiresTasting,hasMultipleWATastings,hasNMartinTasting,HasProducerWebSite,hasPRovaniTasting,hasRParkerTasting,
	hasWjTasting,
	--IsActiveTasting, IsActiveWineN_old,IsBarrelTasting, isBorrowedDrinkDate, 
	IsActiveWineN, Issue, isErpTasting, isWJTasting,
	LabelName,Locale,Location,Maturity,Notes,
	--Pages,
	Places,Producer,producerProfileFileName,ProducerShow,
	ProducerURL,Publication,Rating,
	--Rating_Hi,RatingQ, shortLabelName, SomeYearHasPrices, TastingCount,ThisYearHasPrices, WhoUpdated,
	Region,ReviewerIdN,shortTitle,Site, 
	Source,SourceDate,Variety,VinN,Vintage,WineN,WineType, oldWineN
from RPOWine.dbo.Wine --(noexpand)
where fixedId in (select fixedId from d) and WineN not in (select wineN from e);

-----------------------------------------------------------------------------------------------
--!!! Eventually we need to recover prior MostRecentPrice based on static (Non negative WineN)
-----------------------------------------------------------------------------------------------
update dbo.Wine set 
     isERPName = 1
     ,mostRecentPrice = EstimatedCost
     ,mostRecentPriceHi = estimatedCost_hi
     ,mostRecentPriceCnt = 0
     ,isCurrentlyForSale = 0 ;

exec LogMsg 'Import Stage 14';

print '-- 11. Insert Julian Into ERPSearchD Wine -- ' + cast(getdate() as varchar(30))
--insert new wines based on Julian (note use of the erpProducer field from Julian
/*OLD
with
f as (select * from dbo.ForSale where errors is null and wineN not in (select distinct wineN from dbo.Wine))
,n as (select * from dbo.WAName where errors is null)
,a as (select n.*, WineN,isWineNDeduced,Vintage,Price,PriceHi,PriceCnt from f join n on f.wid = n.wid)
insert into dbo.Wine(ColorClass,Country,Dryness,isErpLocationOK,isERPProducerOK, isProducerTranslated, isErpRegionOK,isErpVarietyOK,IsVinnDeduced,isWineNDeduced,LabelName,Location,Producer,ProducerShow,Region,Variety,VinN,Vintage,Wid,WineN,WineType)
     select ColorClass,Country,Dryness,isErpLocationOK,isERPProducerOK, isProducerTranslated, isErpRegionOK,isErpVarietyOK,IsVinnDeduced,isWineNDeduced,LabelName,Location,eRpProducer,erpProducerShow,Region,Variety,VinN,Vintage,Wid,WineN,WineType
     from a;

with
f as (select * from dbo.ForSale where errors is null and wineN not in (select distinct wineN from dbo.Wine))
,n as (select * from dbo.WAName where errors is null)
,a as (select n.*, WineN,isWineNDeduced,Vintage,Price,PriceHi,PriceCnt from f join n on f.wid = n.wid)
insert into dbo.Wine(ColorClass,Country,Dryness,isErpLocationOK,isERPProducerOK, isProducerTranslated, isErpRegionOK,isErpVarietyOK,IsVinnDeduced,isWineNDeduced,LabelName,Location,Producer,ProducerShow,Region,Variety,VinN,Vintage,Wid,WineN,WineType)
     select erpColorClass,erpCountry,erpDryness,isErpLocationOK,isERPProducerOK, isProducerTranslated, isErpRegionOK,isErpVarietyOK,IsVinnDeduced,isWineNDeduced,erpLabelName,erpLocation,eRpProducer,erpProducerShow,erpRegion,erpVariety,VinN,Vintage,Wid,WineN,WineType
     from a;
*/

--add the ones where there is Vinn so we can map to the eRP names (which we fill in if there is no ambiguity or one of the ambiguous ones matches Julian's
if @IsUseOldWineN = 1 begin
	; with a as (
		select * 
		from dbo.ForSale z 
		where errors is null and not exists (select wineN from dbo.Wine y 
			where z.wineN = y.oldWineN)
	), b as (
		select * 
		from dbo.WAName z 
		where errors is null and  exists (select vinn from dbo.Wine y where z.vinN = y.vinN)
	), c as (
		select b.*, wineN, isWineNDeduced, Vintage,Price,PriceHi,PriceCnt 
		from a 
			join b on a.wid = b.wid
	)
	--select * from c
	insert into dbo.Wine(ColorClass,Country,Dryness,isErpLocationOK,isERPProducerOK, isProducerTranslated, isErpRegionOK,isErpVarietyOK,IsVinnDeduced,isWineNDeduced,LabelName,Location,Producer,ProducerShow,Region,Variety,VinN,Vintage,Wid,WineN,WineType)
	select erpColorClass,erpCountry,erpDryness,isErpLocationOK,isERPProducerOK, isProducerTranslated, isErpRegionOK,isErpVarietyOK,IsVinnDeduced,isWineNDeduced,erpLabelName,erpLocation,eRpProducer,erpProducerShow,erpRegion,erpVariety,VinN,Vintage,Wid,WineN,WineType
	from c;
end else begin
	; with a as (
		select * 
		from dbo.ForSale z 
		where errors is null and not exists (select wineN from dbo.Wine y 
			where z.wineN = y.WineN)
	), b as (
		select * 
		from dbo.WAName z 
		where errors is null and  exists (select vinn from dbo.Wine y where z.vinN = y.vinN)
	), c as (
		select b.*, wineN, isWineNDeduced, Vintage,Price,PriceHi,PriceCnt 
		from a 
			join b on a.wid = b.wid
	)
	--select * from c
	insert into dbo.Wine(ColorClass,Country,Dryness,isErpLocationOK,isERPProducerOK, isProducerTranslated, isErpRegionOK,isErpVarietyOK,IsVinnDeduced,isWineNDeduced,LabelName,Location,Producer,ProducerShow,Region,Variety,VinN,Vintage,Wid,WineN,WineType)
	select erpColorClass,erpCountry,erpDryness,isErpLocationOK,isERPProducerOK, isProducerTranslated, isErpRegionOK,isErpVarietyOK,IsVinnDeduced,isWineNDeduced,erpLabelName,erpLocation,eRpProducer,erpProducerShow,erpRegion,erpVariety,VinN,Vintage,Wid,WineN,WineType
	from c;
end

--add the ones where there is no eRP Vinn, so we have to use Julian's names (except for Producer)
if @IsUseOldWineN = 1 begin
	with a as (
		select * 
		from dbo.ForSale z 
		where errors is null and not exists (select wineN from dbo.Wine y 
			where z.wineN = y.oldWineN)
	), b as (
		select * 
		from dbo.WAName z 
		where errors is null and not exists (select vinn from dbo.Wine y where z.vinN = y.vinN)
	), c as (
		select b.*, wineN, isWineNDeduced, Vintage,Price,PriceHi,PriceCnt 
		from a 
			join b on a.wid = b.wid
	)
	insert into dbo.Wine(ColorClass,Country,Dryness,isErpLocationOK,isERPProducerOK, isProducerTranslated, isErpRegionOK,isErpVarietyOK,IsVinnDeduced,isWineNDeduced,LabelName,Location,Producer,ProducerShow,Region,Variety,VinN,Vintage,Wid,WineN,WineType)
	select ColorClass,Country,Dryness,isErpLocationOK,isERPProducerOK, isProducerTranslated, isErpRegionOK,isErpVarietyOK,IsVinnDeduced,isWineNDeduced,LabelName,Location,eRpProducer,erpProducerShow,Region,Variety,VinN,Vintage,Wid,WineN,WineType
	from c;
end else begin
	with a as (
		select * 
		from dbo.ForSale z 
		where errors is null and not exists (select wineN from dbo.Wine y 
			where z.wineN = y.WineN)
	), b as (
		select * 
		from dbo.WAName z 
		where errors is null and not exists (select vinn from dbo.Wine y where z.vinN = y.vinN)
	), c as (
		select b.*, wineN, isWineNDeduced, Vintage,Price,PriceHi,PriceCnt 
		from a 
			join b on a.wid = b.wid
	)
	insert into dbo.Wine(ColorClass,Country,Dryness,isErpLocationOK,isERPProducerOK, isProducerTranslated, isErpRegionOK,isErpVarietyOK,IsVinnDeduced,isWineNDeduced,LabelName,Location,Producer,ProducerShow,Region,Variety,VinN,Vintage,Wid,WineN,WineType)
	select ColorClass,Country,Dryness,isErpLocationOK,isERPProducerOK, isProducerTranslated, isErpRegionOK,isErpVarietyOK,IsVinnDeduced,isWineNDeduced,LabelName,Location,eRpProducer,erpProducerShow,Region,Variety,VinN,Vintage,Wid,WineN,WineType
	from c;
end

update dbo.Wine set encodedKeywords = 
     case when vintage is null then '' else vintage + ' ' end
     + case when producerShow is null then '' else producerShow + ' ' end
     + case when labelName is null then '' else labelName + ' ' end
     + case when dryness is null then '' else dryness + ' ' end
     + case when colorClass is null then '' else colorClass + ' ' end
     + case when wineType is null then '' else wineType + ' ' end
     + case when variety is null then '' else variety + ' ' end
     + case when country is null then '' else country + ' ' end
     + case when region is null then '' else region + ' ' end
     + case when location is null then '' else location + ' ' end
     + case when locale is null then '' else locale + ' ' end
     + case when site is null then '' else site + ' ' end;

--set prices currently for sale
update dbo.Wine set isCurrentlyForSale = 0, isCurrentlyOnAuction = 0;

if @IsUseOldWineN = 1 begin
	with a as (
		select w.*, price, priceHi, priceCnt 
		from dbo.Wine w 
			left join dbo.ForSale f on f.wineN = w.oldWineN
		where f.isActiveForSaleWineN = 1
	)
	update a set 
		 isCurrentlyForSale = 1
		 ,mostRecentPriceCnt = priceCnt 
		 ,mostRecentPrice = price
		 ,mostRecentPriceHi = priceHi
	where priceCnt is not null;

	with a as (
		select w.*, AuctionPrice, AuctionPriceHi, AuctionCnt 
		from dbo.Wine w 
			left join dbo.ForSale f on f.wineN = w.oldWineN
		where f.isActiveForSaleWineN = 1
	)
	update a set 
		 isCurrentlyOnAuction = 1
		 ,mostRecentAuctionPriceCnt = AuctionCnt 
		 ,mostRecentAuctionPrice = AuctionPrice
		 ,mostRecentAuctionPriceHi = AuctionPriceHi
	where AuctionCnt is not null;
end else begin
	with a as (
		select w.*, price, priceHi, priceCnt 
		from dbo.Wine w 
			left join dbo.ForSale f on f.wineN = w.WineN
		where f.isActiveForSaleWineN = 1
	)
	update a set 
		 isCurrentlyForSale = 1
		 ,mostRecentPriceCnt = priceCnt 
		 ,mostRecentPrice = price
		 ,mostRecentPriceHi = priceHi
	where priceCnt is not null;

	with a as (
		select w.*, AuctionPrice, AuctionPriceHi, AuctionCnt 
		from dbo.Wine w 
			left join dbo.ForSale f on f.wineN = w.WineN
		where f.isActiveForSaleWineN = 1
	)
	update a set 
		 isCurrentlyOnAuction = 1
		 ,mostRecentAuctionPriceCnt = AuctionCnt 
		 ,mostRecentAuctionPrice = AuctionPrice
		 ,mostRecentAuctionPriceHi = AuctionPriceHi
	where AuctionCnt is not null;
end

exec LogMsg 'Import Stage 11.5';
print '-- 11.5. Import Stage 15 -- ' + cast(getdate() as varchar(30));

--11a Update mostRecentPrice in erpSearch-----------------------------------------------
if @IsUseOldWineN = 1 begin
	with a as (
		select WineN fWineN, Price, PriceHi 
		from dbo.ForSale 
		where isActiveForSaleWineN = 1
	), b as (
		select * 
		from dbo.Wine w 
			join a on a.fWineN = w.oldWineN
	)
	update b set 
		 isCurrentlyForSale = 1
		 , mostRecentPrice = Price
		 , mostRecentPriceHi = PriceHi;

	exec LogMsg 'Import Stage 15a';

	with a as (
		select WineN fWineN, Price, PriceHi 
		from dbo.ForSale 
		where isActiveForSaleWineN = 1
	), b as (
		select *
		from dbo.Wine w 
			left join a on a.fWineN = w.oldWineN
		where fWineN is null
	)
	update b set isCurrentlyForSale = 0;
end else begin
	with a as (
		select WineN fWineN, Price, PriceHi 
		from dbo.ForSale 
		where isActiveForSaleWineN = 1
	), b as (
		select * 
		from dbo.Wine w 
			join a on a.fWineN = w.WineN
	)
	update b set 
		 isCurrentlyForSale = 1
		 , mostRecentPrice = Price
		 , mostRecentPriceHi = PriceHi;

	exec LogMsg 'Import Stage 15a';

	with a as (
		select WineN fWineN, Price, PriceHi 
		from dbo.ForSale 
		where isActiveForSaleWineN = 1
	), b as (
		select *
		from dbo.Wine w 
			left join a on a.fWineN = w.WineN
		where fWineN is null
	)
	update b set isCurrentlyForSale = 0;
end

--erpSearchD.dbo.logmsg 'Import Stage 15b';

/*
H		H				S		S
E		N				E		N
-		-       -		-		-		-
0		0				1		1		1229
0		0		$		1		1		34114
0		1				0		1		961
0		1		$		1		1		496
1		0		1		0				15507
1		0		$		1		1		60885
1		1				0		1		398			****
1		1				1		0		194
1		1		$		0		1		2200
1		1		$		1		0		2404
*/
---------4
--Fields useful for retrievals
/* June 19, 2007
update dbo.Wine set showForWJ = 1 where
     (revieweridN = 2 or ((reviewerIdN is null) or (reviewerIdN = 1 and hasWjTasting = 0) and (mostRecentPrice is not null and mostRecentPrice > 0)));
update dbo.Wine set showForWJ = 0 where not
     (revieweridN = 2 or ((reviewerIdN is null) or (reviewerIdN = 1 and hasWjTasting = 0) and (mostRecentPrice is not null and mostRecentPrice > 0)));
update dbo.Wine set showForERP = 1 where
     (revieweridN = 1 or ((reviewerIdN is null) or (reviewerIdN = 2 and hasERPTasting = 0)  and (mostRecentPrice is not null and mostRecentPrice > 0)));
update dbo.Wine set showForERP = 0 where not
     (revieweridN = 1 or ((reviewerIdN is null) or (reviewerIdN = 2 and hasERPTasting = 0)  and (mostRecentPrice is not null and mostRecentPrice > 0)));
*/
/*
with 
b as (select
          case when ((isWJTasting = 1) or (((reviewerIdN is null) or (0 = isWjTasting and hasERPTasting = 0)) and (mostRecentPrice is not null and mostRecentPrice > 0)))
               then 1 else 0 end xShowForWj
          ,case when ((isERPTasting = 1) or (((reviewerIdN is null) or (0 = isErpTasting and hasERPTasting = 0)) and (mostRecentPrice is not null and mostRecentPrice > 0)))
               then 1 else 0 end xShowForErp
          , * from erpSearchD..wine)
update b set showForErp = xShowForErp, showForWJ = xShowForWJ
*/

--update bits
update dbo.Wine set isErpTasting = 0 where isErpTasting is null;
--erpSearchD.dbo.logmsg 'Import Stage 15c';

update dbo.Wine set isWjTasting = 0 where isWjTasting is null;
--erpSearchD.dbo.logmsg 'Import Stage 15d';

with 
b as (select
          case when ((isWJTasting = 1) or (((reviewerIdN is null) or (0 = isWjTasting and hasERPTasting = 0)) and 
                    ((mostRecentPrice is not null and mostRecentPrice > 0) or(mostRecentAuctionPrice is not null and mostRecentAuctionPrice > 0))))
               then 1 else 0 end xShowForWj
          ,case when ((isERPTasting = 1) or (((reviewerIdN is null) or (0 = isErpTasting and hasERPTasting = 0)) and 
                    ((mostRecentPrice is not null and mostRecentPrice > 0) or(mostRecentAuctionPrice is not null and mostRecentAuctionPrice > 0))))
               then 1 else 0 end xShowForErp
          , * 
		from dbo.Wine)
update b set showForErp = xShowForErp, showForWJ = xShowForWJ
--erpSearchD.dbo.logmsg 'Import Stage 15e';


--set ratingShow
/* OLD
update dbo.Wine set ratingShow = null where rating is null and rating_Hi is null;
go
--erpSearchD.dbo.logmsg 'Import Stage 15f';
update dbo.Wine set ratingShow = rating where rating is not null and rating_Hi is null and IsBarrelTasting = 0;
go
--erpSearchD.dbo.logmsg 'Import Stage 15g';
update dbo.Wine set ratingShow = '(' + cast(rating as varchar) + ')' where rating is not null and rating_Hi is null and IsBarrelTasting = 1;
go
--erpSearchD.dbo.logmsg 'Import Stage 15h';
update dbo.Wine set ratingShow = cast(rating as varchar) + '-' + cast(rating_hi as varchar) where rating is not null and rating_Hi is not null and IsBarrelTasting = 0;
go
--erpSearchD.dbo.logmsg 'Import Stage 15i';
update dbo.Wine set ratingShow = '(' + cast(rating as varchar) + '-' + cast(rating_hi as varchar) +')' where rating is not null and rating_Hi is not null and IsBarrelTasting = 1;
go
--erpSearchD.dbo.logmsg 'Import Stage 15j';
update dbo.Wine set ratingShow = '?-' + cast(rating_hi as varchar) where rating is null and rating_Hi is not null and IsBarrelTasting = 0;
go
--erpSearchD.dbo.logmsg 'Import Stage 15k';
update dbo.Wine set ratingShow = '(?-' + cast(rating_hi as varchar) +')' where rating is null and rating_Hi is not null and IsBarrelTasting = 1;
*/

--Currently we replicate this calculation in the nightly update prodcess
update dbo.Wine set ratingShow = null 
where rating is null and rating_Hi is null;

update dbo.Wine set ratingShow = cast(rating as varchar) + isNull(ratingQ, '')
where rating is not null and rating_Hi is null and IsBarrelTasting = 0;

update dbo.Wine set ratingShow = '(' + cast(rating as varchar) + isNull(ratingQ, '') +  ')' 
where rating is not null and rating_Hi is null and IsBarrelTasting = 1;

update dbo.Wine set ratingShow = cast(rating as varchar) + '-' + cast(rating_hi as varchar)  + isNull(ratingQ, '') 
where rating is not null and rating_Hi is not null and IsBarrelTasting = 0;

update dbo.Wine set ratingShow = '(' + cast(rating as varchar) + '-' + cast(rating_hi as varchar)  + isNull(ratingQ, '') +')' 
where rating is not null and rating_Hi is not null and IsBarrelTasting = 1;

update dbo.Wine set ratingShow = '?-' + cast(rating_hi as varchar) + isNull(ratingQ, '')  
where rating is null and rating_Hi is not null and IsBarrelTasting = 0;

update dbo.Wine set ratingShow = '(?-' + cast(rating_hi as varchar)  + isNull(ratingQ, '') +')' 
where rating is null and rating_Hi is not null and IsBarrelTasting = 1;

--erpSearchD.dbo.logmsg 'Import Stage 15L (giant delay on previous run)';
--Giant 30 minute delay between 15L and 16

/* ------ SKIPPED - has producer profile determined differently now -------------
--set hasProducerProfile
-- be careful here - there are multiple neal entries per erp producer.  If you don't group this, it takes one thousand times as long !!!!
with
a as (select erp from erpSearchD..NealProducerToErp where Neal is not null and erp is not null group by erp)
,b as (select hasProducerProfile, a.erp from dbo.Wine w left join a on w.producer = a.erp)
update b set hasProducerProfile = case when erp is null then 0 else 1 end;
*/

--exec LogMsg 'Import Stage 16';

print '-- 12. BuildWineName -- ' + cast(getdate() as varchar(30))
delete from dbo.WineName;

Insert into dbo.WineName(ColorClass,Country,Dryness,LabelName,Locale,Location,ProducerShow,Region,Site,Variety,WineType 
	)
     select ColorClass,Max(Country),max(Dryness),LabelName,max(Locale),max(Location),ProducerShow,max(Region),max(Site),max(Variety),max(WineType)
     from dbo.Wine
     group by ColorClass,LabelName,ProducerShow;

--update dbo.WineNameIdN (needed for the Count fields below
update dbo.Wine set wineNameIdN = null;
with 
a as (select
     case when ProducerShow is Null then '[<NULL>]' else ProducerShow end xProducerShow
     , case when LabelName is Null then '[<NULL>]' else LabelName end xLabelName
     , case when ColorClass is Null then '[<NULL>]' else ColorClass end xColorClass
     , idN idNx
     , *
     from dbo.WineName)
,b as (select
     case when ProducerShow is Null then '[<NULL>]' else ProducerShow end xProducerShow
     , case when LabelName is Null then '[<NULL>]' else LabelName end xLabelName
     , case when ColorClass is Null then '[<NULL>]' else ColorClass end xColorClass
     , *
     from dbo.Wine)
,c as (select b.WineNameIdN, a.* from a join b on a.xProducerShow = b.xProducerShow and a.xLabelName = b.xLabelName and a.xColorClass = b.xColorClass)
update c set wineNameIdN = idNx;

--Calculate the Count Fields
with a as (select wineNameIdN, count(*) cnt from dbo.Wine where showForERP = 1 group by wineNameIdN)
     ,b as (select * from dbo.WineName n left join a on n.idN = a.wineNameIdN)
     update b set cntWine = case when cnt is null then 0 else cnt end;
with a as (select wineNameIdN, count(*) cnt from dbo.Wine where  showForERP = 1 and isCurrentlyForSale = 1 group by wineNameIdN)
     ,b as (select * from dbo.WineName n left join a on n.idN = a.wineNameIdN)
     update b set cntForSale = case when cnt is null then 0 else cnt end;
with a as (select wineNameIdN, count(*) cnt from dbo.Wine where ( showForERP = 1 and reviewerIdN is not null) group by wineNameIdN)
     ,b as (select * from dbo.WineName n left join a on n.idN = a.wineNameIdN)
     update b set cntHasTasting = case when cnt is null then 0 else cnt end;
with a as (select wineNameIdN, count(*) cnt from dbo.Wine where  showForERP = 1 and reviewerIdN is not null and isCurrentlyForSale = 1 group by wineNameIdN)
     ,b as (select * from dbo.WineName n left join a on n.idN = a.wineNameIdN)
     update b set cntForSaleAndHasTasting = case when cnt is null then 0 else cnt end;
--Vintage Counts
with a as (select wineNameIdN, count(distinct vintage) cnt from dbo.Wine where  showForERP = 1 group by wineNameIdN)
     ,b as (select * from dbo.WineName n left join a on n.idN = a.wineNameIdN)
     update b set cntVintage = case when cnt is null then 0 else cnt end;
with a as (select wineNameIdN, count(distinct vintage) cnt from dbo.Wine where  showForERP = 1 and isCurrentlyForSale = 1 group by wineNameIdN)
     ,b as (select * from dbo.WineName n left join a on n.idN = a.wineNameIdN)
     update b set cntVintageForSale = case when cnt is null then 0 else cnt end;
with a as (select wineNameIdN, count(distinct vintage) cnt from dbo.Wine where ( showForERP = 1 and reviewerIdN is not null) group by wineNameIdN)
     ,b as (select * from dbo.WineName n left join a on n.idN = a.wineNameIdN)
     update b set cntVintageHasTasting = case when cnt is null then 0 else cnt end;
with a as (select wineNameIdN, count(distinct vintage) cnt from dbo.Wine where ( showForERP = 1 and reviewerIdN is not null) and isCurrentlyForSale = 1 group by wineNameIdN)
     ,b as (select * from dbo.WineName n left join a on n.idN = a.wineNameIdN)
     update b set cntVintageForSaleAndHasTasting = case when cnt is null then 0 else cnt end;

--Calculate the WJ Count Fields
with a as (select wineNameIdN, count(*) cnt from dbo.Wine where showForWJ = 1 group by wineNameIdN)
     ,b as (select * from dbo.WineName n left join a on n.idN = a.wineNameIdN)
     update b set WJcntWine = case when cnt is null then 0 else cnt end;
with a as (select wineNameIdN, count(*) cnt from dbo.Wine where  showForWJ = 1and isCurrentlyForSale = 1 group by wineNameIdN)
     ,b as (select * from dbo.WineName n left join a on n.idN = a.wineNameIdN)
     update b set WJcntForSale = case when cnt is null then 0 else cnt end;
with a as (select wineNameIdN, count(*) cnt from dbo.Wine where ( showForWJ = 1 and reviewerIdN = 2) group by wineNameIdN)
     ,b as (select * from dbo.WineName n left join a on n.idN = a.wineNameIdN)
     update b set WJcntHasTasting = case when cnt is null then 0 else cnt end;
with a as (select wineNameIdN, count(*) cnt from dbo.Wine where  showForWJ = 1 and reviewerIdN = 2 and isCurrentlyForSale = 1 group by wineNameIdN)
     ,b as (select * from dbo.WineName n left join a on n.idN = a.wineNameIdN)
     update b set WJcntForSaleAndHasTasting = case when cnt is null then 0 else cnt end;
--Vintage Counts
with a as (select wineNameIdN, count(distinct vintage) cnt from dbo.Wine where  showForWJ = 1 group by wineNameIdN)
     ,b as (select * from dbo.WineName n left join a on n.idN = a.wineNameIdN)
     update b set WJcntVintage = case when cnt is null then 0 else cnt end;
with a as (select wineNameIdN, count(distinct vintage) cnt from dbo.Wine where  showForWJ = 1 and isCurrentlyForSale = 1 group by wineNameIdN)
     ,b as (select * from dbo.WineName n left join a on n.idN = a.wineNameIdN)
     update b set WJcntVintageForSale = case when cnt is null then 0 else cnt end;
with a as (select wineNameIdN, count(distinct vintage) cnt from dbo.Wine where ( showForWJ = 1 and reviewerIdN = 2) group by wineNameIdN)
     ,b as (select * from dbo.WineName n left join a on n.idN = a.wineNameIdN)
     update b set WJcntVintageHasTasting = case when cnt is null then 0 else cnt end;
with a as (select wineNameIdN, count(distinct vintage) cnt from dbo.Wine where ( showForWJ = 1 and reviewerIdN = 2) and isCurrentlyForSale = 1 group by wineNameIdN)
     ,b as (select * from dbo.WineName n left join a on n.idN = a.wineNameIdN)
     update b set WJcntVintageForSaleAndHasTasting = case when cnt is null then 0 else cnt end;

--erpSearchD.dbo.logmsg 'Import Stage 17';

print '-- 12a. Fill in Variety alternatives -- ' + cast(getdate() as varchar(30))
; with
a as (select w.variety wVariety, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + variety + ' ') not like ('% ' + wVariety + ' %'))
update b set variety = variety + ' ' + wVariety, isMultiVariety = 1;
with
a as (select w.variety wVariety, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + variety + ' ') not like ('% ' + wVariety + ' %'))
update b set variety = variety + ' ' + wVariety, isMultiVariety = 1;
with
a as (select w.variety wVariety, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + variety + ' ') not like ('% ' + wVariety + ' %'))
update b set variety = variety + ' ' + wVariety, isMultiVariety = 1;
with
a as (select w.variety wVariety, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + variety + ' ') not like ('% ' + wVariety + ' %'))
update b set variety = variety + ' ' + wVariety, isMultiVariety = 1;


print '-- 12b. Fill in Dryness alternatives -- ' + cast(getdate() as varchar(30))
; with
a as (select w.Dryness wDryness, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Dryness + ' ') not like ('% ' + wDryness + ' %'))
update b set Dryness = Dryness + ' ' + wDryness, isMultiDryness = 1;
with
a as (select w.Dryness wDryness, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Dryness + ' ') not like ('% ' + wDryness + ' %'))
update b set Dryness = Dryness + ' ' + wDryness, isMultiDryness = 1;
with
a as (select w.Dryness wDryness, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Dryness + ' ') not like ('% ' + wDryness + ' %'))
update b set Dryness = Dryness + ' ' + wDryness, isMultiDryness = 1;
with
a as (select w.Dryness wDryness, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Dryness + ' ') not like ('% ' + wDryness + ' %'))
update b set Dryness = Dryness + ' ' + wDryness, isMultiDryness = 1;

print '-- 12c. Fill in WineType alternatives -- ' + cast(getdate() as varchar(30))
; with
a as (select w.WineType wWineType, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + WineType + ' ') not like ('% ' + wWineType + ' %'))
update b set WineType = WineType + ' ' + wWineType, isMultiWineType = 1;
with
a as (select w.WineType wWineType, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + WineType + ' ') not like ('% ' + wWineType + ' %'))
update b set WineType = WineType + ' ' + wWineType, isMultiWineType = 1;
with
a as (select w.WineType wWineType, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + WineType + ' ') not like ('% ' + wWineType + ' %'))
update b set WineType = WineType + ' ' + wWineType, isMultiWineType = 1;
with
a as (select w.WineType wWineType, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + WineType + ' ') not like ('% ' + wWineType + ' %'))
update b set WineType = WineType + ' ' + wWineType, isMultiWineType = 1;

print '-- 12d. Fill in Country alternatives -- ' + cast(getdate() as varchar(30))
; with
a as (select w.Country wCountry, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Country + ' ') not like ('% ' + wCountry + ' %'))
update b set Country = Country + ' ' + wCountry, isMultiCountry = 1;
with
a as (select w.Country wCountry, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Country + ' ') not like ('% ' + wCountry + ' %'))
update b set Country = Country + ' ' + wCountry, isMultiCountry = 1;
with
a as (select w.Country wCountry, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Country + ' ') not like ('% ' + wCountry + ' %'))
update b set Country = Country + ' ' + wCountry, isMultiCountry = 1;
with
a as (select w.Country wCountry, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Country + ' ') not like ('% ' + wCountry + ' %'))
update b set Country = Country + ' ' + wCountry, isMultiCountry = 1;

print '-- 12e. Fill in Region alternatives -- ' + cast(getdate() as varchar(30))
; with
a as (select w.Region wRegion, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Region + ' ') not like ('% ' + wRegion + ' %'))
update b set Region = Region + ' ' + wRegion, isMultiRegion = 1;
with
a as (select w.Region wRegion, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Region + ' ') not like ('% ' + wRegion + ' %'))
update b set Region = Region + ' ' + wRegion, isMultiRegion = 1;
with
a as (select w.Region wRegion, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Region + ' ') not like ('% ' + wRegion + ' %'))
update b set Region = Region + ' ' + wRegion, isMultiRegion = 1;
with
a as (select w.Region wRegion, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Region + ' ') not like ('% ' + wRegion + ' %'))
update b set Region = Region + ' ' + wRegion, isMultiRegion = 1;

print '-- 12f. Fill in Location alternatives -- ' + cast(getdate() as varchar(30))
; with
a as (select w.Location wLocation, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Location + ' ') not like ('% ' + wLocation + ' %'))
update b set Location = Location + ' ' + wLocation, isMultiLocation = 1;
with
a as (select w.Location wLocation, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Location + ' ') not like ('% ' + wLocation + ' %'))
update b set Location = Location + ' ' + wLocation, isMultiLocation = 1;
with
a as (select w.Location wLocation, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Location + ' ') not like ('% ' + wLocation + ' %'))
update b set Location = Location + ' ' + wLocation, isMultiLocation = 1;
with
a as (select w.Location wLocation, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Location + ' ') not like ('% ' + wLocation + ' %'))
update b set Location = Location + ' ' + wLocation, isMultiLocation = 1;
with
a as (select w.Location wLocation, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Location + ' ') not like ('% ' + wLocation + ' %'))
update b set Location = Location + ' ' + wLocation, isMultiLocation = 1;

print '-- 12g. Fill in Locale alternatives -- ' + cast(getdate() as varchar(30))
; with
a as (select w.Locale wLocale, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Locale + ' ') not like ('% ' + wLocale + ' %'))
update b set Locale = Locale + ' ' + wLocale, isMultiLocale = 1;
with
a as (select w.Locale wLocale, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Locale + ' ') not like ('% ' + wLocale + ' %'))
update b set Locale = Locale + ' ' + wLocale, isMultiLocale = 1;
with
a as (select w.Locale wLocale, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Locale + ' ') not like ('% ' + wLocale + ' %'))
update b set Locale = Locale + ' ' + wLocale, isMultiLocale = 1;
with
a as (select w.Locale wLocale, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Locale + ' ') not like ('% ' + wLocale + ' %'))
update b set Locale = Locale + ' ' + wLocale, isMultiLocale = 1;

print '-- 12f. Fill in Site alternatives -- ' + cast(getdate() as varchar(30))
; with
a as (select w.Site wSite, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Site + ' ') not like ('% ' + wSite + ' %'))
update b set Site = Site + ' ' + wSite, isMultiSite = 1;
with
a as (select w.Site wSite, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Site + ' ') not like ('% ' + wSite + ' %'))
update b set Site = Site + ' ' + wSite, isMultiSite = 1;
with
a as (select w.Site wSite, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Site + ' ') not like ('% ' + wSite + ' %'))
update b set Site = Site + ' ' + wSite, isMultiSite = 1;
with
a as (select w.Site wSite, n.* from dbo.WineName n join dbo.Wine w on n.idN = w.wineNameIdN)
,b as (select * from a where (' ' + Site + ' ') not like ('% ' + wSite + ' %'))
update b set Site = Site + ' ' + wSite, isMultiSite = 1;

update dbo.WineName set encodedKeywords = 
     case when producerShow is null then '' else producerShow + ' ' end
     + case when labelName is null then '' else labelName + ' ' end
     + case when dryness is null then '' else dryness + ' ' end
     + case when colorClass is null then '' else colorClass + ' ' end
     + case when wineType is null then '' else wineType + ' ' end
     + case when variety is null then '' else variety + ' ' end
     + case when country is null then '' else country + ' ' end
     + case when region is null then '' else region + ' ' end
     + case when location is null then '' else location + ' ' end
     + case when locale is null then '' else locale + ' ' end
     + case when site is null then '' else site + ' ' end;

--erpSearchD.dbo.logmsg 'Import Stage 18';

print '-- 13. UpdateDetailWineN -- ' + cast(getdate() as varchar(30))
--transfer wineN from dbo.WAName
;with
d as (select * from dbo.ForSaleDetail where errors is null and wid is not null and vintage is not null and wineN is null)
,f as (select * from dbo.ForSale where errors is null and wid is not null and vintage is not null and wineN is not null)
,a as (select d.*, f.wineN fWineN, f.isWineNDeduced fIsWineNDeduced, f.isTempWineN fIsTempWineN from d left join f on d.wid = f.wid and d.vintage = f.vintage)
update a set wineN = fWineN, wineN2 = fWineN, isWineNDeduced = fIsWineNDeduced, isTempWineN = fIsTempWineN;

print '-- 14. Update RpoWineData -- ' + cast(getdate() as varchar(30))
--update RpoWineData.wine.wineNameIdN
/* --- prev version ---
update RpoWineData.dbo.wine set wineNameIdN = null;

with 
a as (select
     case when ProducerShow is Null then '[<NULL>]' else ProducerShow end xProducerShow
     , case when LabelName is Null then '[<NULL>]' else LabelName end xLabelName
     , case when ColorClass is Null then '[<NULL>]' else ColorClass end xColorClass
     , idN idNx
     , *
     from dbo.WineName)
,b as (select
     case when ProducerShow is Null then '[<NULL>]' else ProducerShow end xProducerShow
     , case when LabelName is Null then '[<NULL>]' else LabelName end xLabelName
     , case when ColorClass is Null then '[<NULL>]' else ColorClass end xColorClass
     , *
     from RpoWineData.dbo.wine)
,c as (select b.WineNameIdN, a.* from a join b on a.xProducerShow = b.xProducerShow and a.xLabelName = b.xLabelName and a.xColorClass = b.xColorClass)
update c set wineNameIdN = idNx;
*/

--------- RPOWine UPDATES START HERE ---------

if @IsUpdateWineDB = 0 begin
	print '      ... skipped.'
end else begin

	update RPOWine.dbo.Wine_N set oldWineNameIdN = null;

	; with 
	a as (select
		 case when ProducerShow is Null then '[<NULL>]' else ProducerShow end xProducerShow
		 , case when LabelName is Null then '[<NULL>]' else LabelName end xLabelName
		 , case when ColorClass is Null then '[<NULL>]' else ColorClass end xColorClass
		 , idNx = idN 
		 from dbo.WineName)
	,b as (
		select
			oldWineNameIdN,
			xProducerShow = case when nullif(wp.NameToShow, '') is Null then '[<NULL>]' else wp.NameToShow end,
			xLabelName = case when nullif(wl.Name, '') is Null then '[<NULL>]' else wl.Name end,
			xColorClass = case when nullif(wc.Name, '') is Null then '[<NULL>]' else wc.Name end
		from RPOWine.dbo.Wine_N wn
			join RPOWine.dbo.Wine_VinN vn on wn.Wine_VinN_ID = vn.ID
			join RPOWine.dbo.WineProducer wp on vn.ProducerID = wp.ID
			join RPOWine.dbo.WineLabel wl on vn.LabelID = wl.ID
			join RPOWine.dbo.WineColor wc on vn.ColorID = wc.ID
	)
	,c as (
		select b.oldWineNameIdN, a.* 
			from a 
				join b on a.xProducerShow = b.xProducerShow and a.xLabelName = b.xLabelName and a.xColorClass = b.xColorClass
	)
	update c set oldWineNameIdN = idNx;

	exec LogMsg 'Import Stage 19';

	--14a Update RPOWineData from eRPWineData---------------------------------------------------------------------------------------
	/* ---- SKIPPED - isERPName is not in use in the new version -------
	update RpoWineData.dbo.wine set isERPName = 1;
	*/

	/* --- prev version ---
	with
	a as (select min(idN) idN from dbo.Wine where fixedId is not null group by FixedId)
	,c as (select b.* from dbo.Wine b  join a on b.idn = a.idN)
	,e as (select d.*, c.showForERP showForERP2, c.showForWJ showForWJ2 from RpoWineData.dbo.wine d join c on d.fixedId = c.fixedId)
	update e set showForERP = showForERP2, showForWJ = showForWJ2;

	with
	a as (select min(idN) idN from dbo.Wine where wineN is not null and WineN > 0 group by WineN)
	,c as (select b.* from dbo.Wine b  join a on b.idn = a.idN)
	,e as (select d.*, c.mostRecentPriceCnt mostRecentPriceCnt2 from RpoWineData.dbo.wine d join c on d.wineN = c.wineN)
	--select * from e
	update e set mostRecentPriceCnt = mostRecentPriceCnt2;
	------------  ^^^^^^^^^^^^^^^^^ it is strange, because next update will set it's value to 0

	--update RpoWineData.dbo.wine set mostRecentPrice = estimatedCost, mostRecentPriceHi = estimatedCost_Hi, isCurrentlyForSale = 0 ;
	update RpoWineData.dbo.wine set mostRecentPrice = estimatedCost, mostRecentPriceHi = estimatedCost_Hi, isCurrentlyForSale = 0, mostRecentPriceCnt = 0;
	*/

	with a as (
		select idN = min(idN) from dbo.Wine where fixedId is not null group by FixedId
	), c as (
		select b.* from dbo.Wine b join a on b.idn = a.idN
	), e as (
		select d.oldFixedId, d.oldShowForERP, d.oldShowForWJ,
			showForERP2 = c.showForERP, showForWJ2 = c.showForWJ
		from RPOWine.dbo.TasteNote d 
			join c on d.oldFixedId = c.fixedId
	)
	update e set oldShowForERP = showForERP2, oldShowForWJ = showForWJ2;

	--update RPOWine.dbo.Wine_N set 
	--	MostRecentPrice = estimatedCost, 
	--	MostRecentPriceHi = estimatedCost, 
	--	IsCurrentlyForSale = 0, 
	--	MostRecentPriceCnt = 0;

/* --- prev version ---
	with
	a as (select wineN eWineN, min(mostRecentPrice) eMostRecentPrice, min(mostRecentPriceHi) eMostRecentPriceHi, min(mostRecentPriceCnt) eMostRecentPriceCnt
		 from dbo.Wine  where isCurrentlyForSale = 1 group by wineN)
	,b as (select wineN, isCurrentlyForSale, mostRecentPrice, mostRecentPriceHi, mostRecentPriceCnt
		 from RpoWineData.dbo.wine)
	,c as (select * from b join a on b.wineN = a.ewineN)
	update c set isCurrentlyForSale = 1, mostRecentPrice = eMostRecentPrice, mostRecentPriceHi = eMostRecentPriceHi, mostRecentPriceCnt = eMostRecentPriceCnt;

	with
	a1 as (select wineN eWineN, min(mostRecentAuctionPrice) eMostRecentAuctionPrice, min(mostRecentAuctionPriceHi) eMostRecentAuctionPriceHi, min(mostRecentAuctionPriceCnt) eMostRecentAuctionPriceCnt
		 from dbo.Wine  where isCurrentlyOnAuction = 1 group by wineN)
	,b2 as (select wineN, isCurrentlyOnAuction, mostRecentAuctionPrice, mostRecentAuctionPriceHi, mostRecentAuctionPriceCnt
		 from RpoWineData.dbo.wine)
	,c12 as (select * from b2 join a1 on b2.wineN = a1.ewineN)
	update c12 set isCurrentlyOnAuction = 1, mostRecentAuctionPrice = eMostRecentAuctionPrice, mostRecentAuctionPriceHi = eMostRecentAuctionPriceHi, mostRecentAuctionPriceCnt = eMostRecentAuctionPriceCnt;
*/

	with a as (
		select eWineN = wineN, eMostRecentPrice = min(mostRecentPrice), 
			eMostRecentPriceHi = min(mostRecentPriceHi), eMostRecentPriceCnt = min(mostRecentPriceCnt)
		from dbo.Wine
		where isCurrentlyForSale = 1 
		group by wineN
	), b as (
		select wineN = ID, IsCurrentlyForSale, MostRecentPrice, MostRecentPriceHi, MostRecentPriceCnt
		from RPOWine.dbo.Wine_N
	), c as (
		select * 
		from b join a on b.wineN = a.ewineN
	)
	update c set 
		IsCurrentlyForSale = 1, 
		MostRecentPrice = eMostRecentPrice, 
		MostRecentPriceHi = eMostRecentPriceHi, 
		MostRecentPriceCnt = eMostRecentPriceCnt;

	with a1 as (
		select eWineN = wineN, eMostRecentAuctionPrice = min(mostRecentAuctionPrice), 
			eMostRecentAuctionPriceHi = min(mostRecentAuctionPriceHi), eMostRecentAuctionPriceCnt = min(mostRecentAuctionPriceCnt)
		from dbo.Wine
		where isCurrentlyOnAuction = 1 
		group by wineN
	), b2 as (
		select wineN = ID, IsCurrentlyOnAuction, MostRecentAuctionPrice, MostRecentAuctionPriceHi, MostRecentAuctionPriceCnt
		from RPOWine.dbo.Wine_N
	), c12 as (
		select * from b2 join a1 on b2.wineN = a1.ewineN
	)
	update c12 set 
		IsCurrentlyOnAuction = 1, 
		MostRecentAuctionPrice = eMostRecentAuctionPrice, 
		MostRecentAuctionPriceHi = eMostRecentAuctionPriceHi, 
		MostRecentAuctionPriceCnt = eMostRecentAuctionPriceCnt;

/*
	--update RpoWineData..wine set isWJTasting = z.isWJTasting, isErpTasting = z.isErpTasting
	update z set z.isWJTasting = y.isWJTasting, z.isErpTasting = y.isErpTasting
		 from RpoWineData.dbo.wine z left join dbo.Wine y on z.wineN = y.wineN;
*/

--mostRecentPrice mostRecentPriceHi mostRecentPriceCnt Currently

	with a as (
		select eWineN = wineN from dbo.Wine where isCurrentlyForSale = 0 group by wineN
	), b as (
		select wineN = ID, isCurrentlyForSale = IsCurrentlyForSale from RPOWine.dbo.Wine_N
	), c as (
		select * from b join a on b.wineN = a.ewineN
	)
	update c set isCurrentlyForSale = 0;

	with a1 as (
		select eWineN = wineN from dbo.Wine where isCurrentlyForSale = 0 group by wineN
	), b2 as (
		select wineN = ID, isCurrentlyOnAuction = IsCurrentlyOnAuction from RPOWine.dbo.Wine_N
	), c12 as (
		select * from b2 join a1 on b2.wineN = a1.ewineN
	)
	update c12 set isCurrentlyOnAuction = 0;

	exec LogMsg 'Import Stage 20';
	print 'Import Stage 20 ' + cast(getdate() as varchar(30));

	--RatingShow
	--should already have been done in the separate SQL query group that creates eRPSearch.wine
	/* --- prev version - incorporated in RPOWine..Wine view ---
	update RpoWineData.dbo.wine set ratingShow = null where rating is null and rating_Hi is null;
	update RpoWineData.dbo.wine set ratingShow = cast(rating as varchar) + isNull(ratingQ, '')where rating is not null and rating_Hi is null and IsBarrelTasting = 0;
	update RpoWineData.dbo.wine set ratingShow = '(' + cast(rating as varchar) + isNull(ratingQ, '') +  ')' where rating is not null and rating_Hi is null and IsBarrelTasting = 1;
	update RpoWineData.dbo.wine set ratingShow = cast(rating as varchar) + '-' + cast(rating_hi as varchar)  + isNull(ratingQ, '') where rating is not null and rating_Hi is not null and IsBarrelTasting = 0;
	update RpoWineData.dbo.wine set ratingShow = '(' + cast(rating as varchar) + '-' + cast(rating_hi as varchar)  + isNull(ratingQ, '') +')' where rating is not null and rating_Hi is not null and IsBarrelTasting = 1;
	update RpoWineData.dbo.wine set ratingShow = '?-' + cast(rating_hi as varchar) + isNull(ratingQ, '')  where rating is null and rating_Hi is not null and IsBarrelTasting = 0;
	update RpoWineData.dbo.wine set ratingShow = '(?-' + cast(rating_hi as varchar)  + isNull(ratingQ, '') +')' where rating is null and rating_Hi is not null and IsBarrelTasting = 1;
	*/

	--set hasProducerProfile - TODO: removed, we are using producer profile in a different way now.
	/*
	with
	a as (select hasProducerProfile, p.erp from RpoWineData.dbo.wine w left join erpSearchD.dbo.NealProducerToErp p on w.producer = p.erp)
	update a set hasProducerProfile = case when erp is null then 0 else 1 end;
	*/

--set various bits
	update z set 
		z.oldShowForERP = y.showForErp, 
		z.oldShowForWJ = y.showForWj
	from RPOWine.dbo.TasteNote z 
		join dbo.Wine y on z.oldFixedId = y.fixedId;

	--15 Restore ArticleHandle -------------------------------------------------------------------------------------------------------------------------------------------------------------
	/* - NOT IN USE --
	with
	a as (select z.articleHandle, y.articleHandle yArticleHandle from RpoWineData.dbo.wine z join erpSearchD.dbo.keep y on z.fixedId = y.fixedId)
	update a set articleHandle = yArticleHandle where isNull(articleHandle,-1) <> isNull(yArticleHandle, -1)
	*/

end

exec LogMsg 'Import Stage 21';
print 'Import Stage 21 ' + cast(getdate() as varchar(30));

--16 Get Update Statistics-------------------------------------------------------------------------------------------------------------------------------------------------------------
insert into DatabaseStats 
	(action, date, forSaleCnt, forSaleDetailCnt,forSaleDetailErrorCnt,forSaleErrorCnt,retailerCnt,retailerErrorCnt,
	rpoWineCnt,waNameCnt,waNameErrorCnt,wineCnt,wineNameCnt)
select 'newPrices',
     getDate(),
     (select count(*) from dbo.ForSale),
     (select count(*) from dbo.ForSaleDetail),
     (select count(*) from dbo.ForSaleDetail where len(rtrim(isnull(errors, ''))) > 1),
     (select count(*) from dbo.ForSale where len(rtrim(isnull(errors, ''))) > 1),
     (select count(*) from dbo.Retailers),
     (select count(*) from dbo.Retailers where len(rtrim(isnull(errors, ''))) > 1),
     
     (select count(*) from RPOWine.dbo.Wine),
     (select count(*) from dbo.WAName),
     (select count(*) from dbo.WAName where len(rtrim(isnull(errors, ''))) > 1),
     (select count(*) from dbo.Wine),
     (select count(*) from dbo.WineName)

exec LogMsg 'Import Stage 22';
print 'Import Stage 22 ' + cast(getdate() as varchar(30));

--17 Enable Indexes-------------------------------------------------------------------------------------------------------------------------------------------------------------
--alter Index all on dbo.ForSaleDetail rebuild
--alter Index all on dbo.Wine rebuild
--alter Index all on dbo.WineName rebuild
--alter Index all on RpoWineData.dbo.wine rebuild

--Add a test forSaleDetail item so we can check the source of this update
insert into dbo.ForSaleDetail (retailerDescriptionOfWine, currency, country, isAuction) 
select 'xxverify' + cast(getDate() as nvarChar), '$', 'USA', 0

begin try
	alter fullText Index on dbo.ForSaleDetail enable
	alter fullText Index on dbo.Wine enable;
	alter fullText Index on dbo.WineName enable;
	--alter fullText Index on RpoWineData.dbo.wine enable;
end try
begin catch
end catch

/* ---- NO NEED for now ------
exec LogMsg 'Import Stage 23';
print 'Import Stage 23';
go
USE [eRPSearchD]
--BACKUP LOG erpSearchD WITH TRUNCATE_ONLY;
DBCC SHRINKDATABASE(N'eRPSearchD' );
DBCC SHRINKFILE (N'erpSearchD3' , 10);
DBCC SHRINKFILE (N'eRPSearchD3_log' , 10);
--BACKUP LOG erpSearchD WITH TRUNCATE_ONLY;
GO

USE [RpoWineDataD]
--BACKUP LOG RpoWineDataD WITH TRUNCATE_ONLY;
DBCC SHRINKDATABASE(N'RpoWineDataD' );
DBCC SHRINKFILE (N'RpoWineDataD_Data' , 10);
DBCC SHRINKFILE (N'RpoWineDataD_Log' , 10);
--BACKUP LOG RpoWineDataD WITH TRUNCATE_ONLY;
GO

-- not on erp3
USE [Keep]
--BACKUP LOG Keep WITH TRUNCATE_ONLY;
DBCC SHRINKDATABASE(N'Keep' );
DBCC SHRINKFILE (N'Keep3' , 10);
DBCC SHRINKFILE (N'Keep3_Log' , 10);
--BACKUP LOG Keep WITH TRUNCATE_ONLY;
GO

erpSearchD.dbo.logmsg 'Import Stage 24';
print 'Import Stage 24';
*/

select top 6 * 
from DatabaseStats 
order by date desc;
select 'DONE EXCEPT FOR FULL TEXT POPULATION'

--08Mar13
declare @s varChar(max)
select @s = (select top(1) 
     'ForSale(' + cast(forSaleDetailCnt as varchar) 
     + ')....RpoWines(' + cast(rpoWineCnt as varchar) 
     + ')....Retailers(' + cast(retailerCnt as varchar) 
     + ')' 
     from DatabaseStats order by date desc);
exec LogMsg @s

exec LogMsg 'Import Stage 25';
print 'Import Stage 25 ' + cast(getdate() as varchar(30));

--alter fullText Index on dbo.ForSaleDetail start full population;
--alter fullText Index on dbo.Wine start full population;
--alter fullText Index on dbo.WineName start full population;
--alter fullText Index on RpoWineData.dbo.wine start full population;

-- no need for now
--exec utility..updateProducerURLFromDatabase;		--08Jun10
exec LogMsg 'Import Stage 26 - updated Producer URL database';

/*
--New as of Dec 23, 2010
truncate table RpoWineData.dbo.issueToc
set identity_insert RpoWineData.dbo.issueToc On;
insert into RpoWineData..issueToc(issueTocN, issue,articleIdnKey,title,source,cntProducer,cntWine)
	select issueTocN, issue,articleIdnKey,title,source,cntProducer,cntWine
		from rpowinedata2..issueToc
set identity_insert RpoWineData.dbo.issueToc off;
*/

--1106Jun29
--exec RpoWineData.dbo.updateArticles
exec RPOWine.srv.UpdateArticles

--exec RpoWineData.dbo.updateIssueToc		-- IssueTop is not in use
--exec RpoWineData.dbo.ReComputePrices		-- table prices is not in use
--exec RpoWineData.dbo.UpdateTopBarginMap	-- table tocbargainmap is not in use

if @IsUpdateWineDB = 1 begin
	print '-- N. RPOWine.srv calls -- ' + cast(getdate() as varchar(30))
	-- Alex B. - reload Wine table
	exec RPOWine.srv.Wine_UpdatePrices
	exec RPOWine.srv.Wine_UpdateIsActiveWineN
	exec RPOWine.srv.Wine_Reload
end

exec LogMsg 'Update of all files finished';
print 'Update of all files finished ' + cast(getdate() as varchar(30));

/*

SELECT '1' Title, OBJECTPROPERTYEX(OBJECT_ID(N'erpSearchD.forSaleDetail'), 'TableFullTextPopulateStatus') Foo
Union SELECT '2' Title, OBJECTPROPERTYEX(OBJECT_ID(N'erpSearchD.Retailers'), 'TableFullTextPopulateStatus') Foo
Union SELECT '3' Title, OBJECTPROPERTYEX(OBJECT_ID(N'erpSearchD.wine'), 'TableFullTextPopulateStatus') Foo
Union SELECT '4' Title, OBJECTPROPERTYEX(OBJECT_ID(N'erpSearchD.wineName'), 'TableFullTextPopulateStatus') Foo
Union SELECT '5' Title, OBJECTPROPERTYEX(OBJECT_ID(N'RpoWineData.wine'), 'TableFullTextPopulateStatus') Foo
Union SELECT Top 1 '6 Full Text xxVerify' Title, RetailerDescriptionOfWine Foo From dbo.ForSaleDetail where contains(retailerDescriptionOfWine,' "xxVerify*"  ')
Union SELECT Top 1 '7 Full Text erpSearchD' Title, (vintage + producerShow) Foo From dbo.Wine where contains(encodedkeywords,' "erpSearchD*"  ')
Union SELECT '8' Title, 'Line 6 above line should show Full Text xxVerify and line 7 should show Full Text erpSearchD verify'

*/

RETURN 1
