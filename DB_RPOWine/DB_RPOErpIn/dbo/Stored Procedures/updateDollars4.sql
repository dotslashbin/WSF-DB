--use erpin
CREATE proc updateDollars4
as begin
 
------------------------------------------------------------------------------------------
-- Get a wineN for everything forSale
------------------------------------------------------------------------------------------
 
/*
update vForSale set errors = null where errors like '%E47%' or  errors like '%E48%' or  errors like '%E49%'
 
alter view vForSalePlus as 
	select c.bottlesperCase, c.litersperBottle
			, d.USDollars
			, ((price * USDollars) / (convert(float,bottlesperCase) * convert(float,litersperBottle)   )) dollarsPerLiter
			, a.*
		from vForSale a
			join erp..bottleSizes c
				on a.bottleSize = c.bottleSize
			join erp..currencyConversion d
				on a.Currency=d.alertCurrency
		where auction is null or auction not like '%[aA]%'
 

alter view vForSalePlusOK as select * from vForSalePlus where errors is null


create view vForSalePriceOK as
	select * from vForSale
	where
		errors is null 
			or (     (     errors like '%[[E47]%' or errors like '%[[E48]%' or errors like '%[[E49]%'     )
					and
					OveridePriceException is not null     )

*/
 
update a
	set a.dollarsPerLiter = ((price * USDollars) / (convert(float,bottlesperCase) * convert(float,litersperBottle)   ))
	from vForSale a
		join erp..bottleSizes c
			on a.bottleSize = c.bottleSize
		join erp..currencyConversion d
			on a.Currency=d.alertCurrency;
 
 
update a set wineNN = b.wineN
	from vForSale a
		join (select wid, vintage, wineN, dateHi, row_number() over (partition by wid, vintage order by dateHi desc) ii from idUse) b 			
			on a.wid = b.wid				
				and a.vintage=b.vintage
				and b.ii = 1;
	
------------------------------------------------------------------------------------------
-- Special case with only 2 prices has to be processed first
------------------------------------------------------------------------------------------
with
a as (select wineNN, min(dollarsPerLiter) minDollars, max(dollarsPerLiter) maxDollars
		from vForSale --vForSalePlus 
		group by wineNN 
		having count(*) = 2     )
,b as (select * from a where maxDollars > (3 * minDollars)     )
update c
	set errors = isNull(errors + ';  ', '') + '[E47]  Bad Price - Only 2 items, High > 3x Low' 
	from vForSalePriceOK c     --vForSalePlus
		join b
			on c.wineNN = b.wineNN
											 
 
--use erpin
truncate table medianDollars;
with
a as (select 
		  wineNN
		,  row_number() over(partition by wineNN order by dollarsPerLiter) ii
		,  dollarsPerLiter
		, auction
	from vForSaleOK		     )     --vForSalePlusOK
,b as (select wineNN
		, convert(int,max(ii) *.5) m1
		, count(*) cnt
	from a
	group by wineNN     )
,c as (select 
			  a.*
			,  case when 0 = cnt % 2 then m1 else m1+1 end m1
			,  (m1 + 1) m2
			, b.cnt 
		from
			a
				join b
					on a.wineNN = b.wineNN     )
insert into medianDollars(wineN, dollarsPerLiter)
	select wineNN, avg(dollarsPerLiter) 
		from c
		where ii between m1 and m2
		group by wineNN
		order by wineNN
	
 
------------------------------------------------------------------------------------------
-- Remove outliers 1
------------------------------------------------------------------------------------------
 
update a set errors = isNull(errors + ';  ', '') + '[E48]  Bad Price - Less than 1/3 of the median' 
	from vForSalePriceOK a     --vForSalePlus
		join medianDollars b
			on a.wineNN = b.wineN
	where (a.dollarsPerLiter * 3) < b.dollarsPerLiter
 
update a set errors = isNull(errors + ';  ', '') + '[E49]  Bad Price - More than 3 times the median' 
	from vForSalePriceOK a     --vForSalePlus
		join medianDollars b
			on a.wineNN = b.wineN
	where a.dollarsPerLiter  > (3 *b.dollarsPerLiter)
 
------------------------------------------------------------------------------------------
-- Do a 2nd round after throwing out the problem items from the 1st round
------------------------------------------------------------------------------------------
truncate table medianDollars;
with
a as (select 
		  wineNN
		,  row_number() over(partition by wineNN order by dollarsPerLiter) ii
		,  dollarsPerLiter
		, auction
	from vForSaleOK     --vForSalePlusOK
		where auction is null or auction not like '%[aA]%'
		     )
,b as (select wineNN
		, convert(int,max(ii) *.5) m1
		, count(*) cnt
	from a
	group by wineNN     )
,c as (select 
			  a.*
			,  case when 0 = cnt % 2 then m1 else m1+1 end m1
			,  (m1 + 1) m2
			, b.cnt 
		from
			a
				join b
					on a.wineNN = b.wineNN     )
insert into medianDollars(wineN, dollarsPerLiter)
	select wineNN, avg(dollarsPerLiter) 
		from c
		where ii between m1 and m2
		group by wineNN
		order by wineNN
 
update a set errors = isNull(errors + ';  ', '') + '[E48b]  Bad Price - Less than 1/3 of the median (pass 2)' 
	from vForSalePriceOK a     --vForSalePlus
		join medianDollars b
			on a.wineNN = b.wineN
	where (a.dollarsPerLiter * 3) < b.dollarsPerLiter and errors not like '%[[]E48%'
 
update a set errors = isNull(errors + ';  ', '') + '[E49b]  Bad Price - More than 3 times the median (pass 2)' 
	from vForSalePriceOK a     --vForSalePlus a     --vForSalePlus
		join medianDollars b
			on a.wineNN = b.wineN
		where a.dollarsPerLiter  > (3 *b.dollarsPerLiter) and errors not like '%[[]E49%';


------------------------------------------------------------------------------------------
-- Views
------------------------------------------------------------------------------------------
/*
ALTER view vDollars as 
	with
	a as      (select priceGN, wineNN, row_number() over(partition by wineNN order by dollarsPerLiter) ii, dollarsPerLiter
		from vForSalePriceOK aa
			join erp..priceGToSeller bb
				on aa.retailerN = bb.sellerN     
		where wineNN is not null)
	, b as     (select priceGN, wineNN
				, convert(int,max(ii) *.5) m1raw
				, count(*) cnt
		from a
		group by priceGN, wineNN     )
	, c as     (select a.*
				,  case when 0 = cnt % 2 then m1raw else m1raw+1 end m1
				,  (m1raw + 1) m2
				, b.cnt
			from a
				join b
					on a.priceGN = b.priceGN and a.wineNN = b.wineNN     )
select priceGN, wineNN
		, avg(dollarsPerLiter) dollarsPerLiterMedian
		, min(dollarsPerLiter) dollarsPerLiterLo
		, max(dollarsPerLiter) dollarsPerLiterHi
		, count(*) cnt
	from c
		group by priceGN, wineNN
		
--oodef vDollars
 

CREATE view vPrice as select * from priceTest


ALTER view vPrice2 as 
	select
		priceGN
		,wineN
		,wineNameN nameN
		,isForSaleNow live
		,convert(date, mostRecentDate) [date]
		,mostRecentPriceCnt cnt
		,convert(int,mostRecentPriceLo) lo
		,convert(int, mostRecentPriceMedian) median
		,convert(int,mostRecentPriceHi) hi
		,convert(date, createDate) created
		,includesAuction auction
	from vPrice
*/
 
 

------------------------------------------------------------------------------------------
-- Update grouped prices
------------------------------------------------------------------------------------------
declare @date smalldatetime = getDate();
merge vPrice as a
	using (select aa.*
		, bb.wineNameN 
		from vDollars aa 
			join wine bb 
				on aa.wineNN
				=
				bb.wineN) as b
	on a.priceGN=b.priceGN and a.wineN=b.wineNN
when matched and (isForSaleNow is null or isForSaleNow <> 1 or mostRecentDate is null or mostRecentDate <> @date) then
	update set isForSaleNow = 1, mostRecentDate = @date
when not matched by source and (isForSaleNow is null or isForSaleNow<> 0) then
	update set isForSaleNow = 0
when not matched by target then
	insert     (
		  priceGN
		, wineN
		, wineNameN
		, isForSaleNow											   
		, includesNotForSaleNow
		, includesAuction
		, mostRecentPriceMedian
		, mostRecentPriceLo
		, mostRecentPriceHi
		, mostRecentPriceCnt
		, createDate 
		, mostRecentDate
		, isFake     )
	values (
			  b.priceGN
			, b.wineNN
			, b.wineNameN
			, 1
			, 0
			, 0
			, b.dollarsPerLiterMedian
			, b.dollarsPerLiterLo
			, b.dollarsPerLiterHi
			, b.cnt
			, @date
			, @date
			, 0     );
 
	
 
	
	
	
	
	
	
	
 
 
 
 
 
 
	
	
	
	 
			 
------------------------------------------------------------------------------------------
-- Test code
------------------------------------------------------------------------------------------
/*
problem wine
priceGN	wineN	nameN	live	date	cnt	lo	median	hi	created	auction
18220	107132	41518	1	2010-05-02	35	19	121	322	2010-05-01	0

select errors, count(*) cnt from vForSale group by errors
 
select wineNN, wid, vintage, dollarsPerLiter, price, bottleSize, currency, errors from vForSalePlus where wineNN in 
		(select distinct(wineNN) from vForSalePlus where errors like '%E47]%' or  errors like '%E48]%' or  errors like '%E49]%')
	order by wineNN, dollarsPerLiter
 
select wineNN, wid, vintage, dollarsPerLiter, price, bottleSize, currency, errors from vForSalePlus where wid = 'am1205104' and vintage = '1991'
	order by wineNN, dollarsPerLiter
	
select wid, vintage, price, bottleSize, currency, errors from vForSale where wid = 'am1205104' and vintage = '1991'
 
select * from medianDollars where wineNN = 1209
 
--oo iv, vforsaleplus
*/
 
end
 
