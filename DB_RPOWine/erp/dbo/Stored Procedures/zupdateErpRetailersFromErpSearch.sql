--database update [=]
CREATE proc [zupdateErpRetailersFromErpSearch] as begin 
------------------------------------------------------------------------
-- Update Retailers=>Wh, retailerId in forSaleDetail
------------------------------------------------------------------------

update z set z.address=y.address,z.city=y.city,z.country=y.country,z.displayName=y.RetailerName,z.email=y.email
	,z.fax=y.fax,z.phone=y.phone,z.state=y.state,z.postalCode=y.Zip,z.isRetailer=1
from wh z join erpSearchD..retailers y 
		on z.shortname=y.RetailerCode
		where z.isRetailer = 1 and isGroup = 0

insert into wh (address,city,country,displayName,email,fax,phone,state,postalCode,shortname,isRetailer)
	select address,city,country,RetailerName,email,fax,phone,state,Zip,RetailerCode, 1
	from erpsearchD..retailers z
	where not exists (select * from wh y  where y.shortname = z.retailerCode and y.isRetailer = 1 and y.isGroup = 0)

--ood activ
update z set z.isInActive = 1
	from wh z left join erpSearchD..retailers y 
		on z.shortname=y.RetailerCode
	where z.isRetailer = 1 and isGroup = 0
		and y.RetailerCode is null

update z set z.retailerN = y.whN
	from erpsearchd..forsaledetail z 
		join wh y on z.retailerCode = y.shortname
		where y.isRetailer = 1 and y.isGroup = 0

update z set z.retailerN = y.whN
	from erpsearchd..retailers z 
		join wh y on z.retailerCode = y.shortname
		where y.isRetailer = 1 and y.isGroup = 0


/* 
(now done in step 207)

-- add a group for all retailers
declare @allRetailersN int
set @allRetailersN = (select top 1 whN from wh where tag = 'all' and isRetailer = 1);
with
a as (select b from mapPriceGToWh where fromPriceGroupN = @allRetailersN)
,b as (select whN b from wh where isRetailer = 1 and isGroup = 0 and isObsolete = 0)
insert into mapPriceGToWh(fromPriceGroupN, b)
select @allRetailersN, b from b where b not in (select b from a)
*/



end
