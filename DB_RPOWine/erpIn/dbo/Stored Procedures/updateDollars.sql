--use erpin

CREATE proc updateDollars
as begin

------------------------------------------------------------------------------------------
-- Get a wineN for everything forSale
------------------------------------------------------------------------------------------

	
/*
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

xxx alter view vForSalePlus as 
	select c.bottlesperCase, c.litersperBottle
			, d.USDollars
			, ((price * USDollars) / (convert(float,bottlesperCase) * convert(float,litersperBottle)   )) dollarsPerLiter
			, a.*
		from vForSale a
			join (select wid, vintage, wineN, dateHi, row_number() over (partition by wid, vintage order by dateHi desc) ii from idUse) b 			
				on a.wid = b.wid				
					and a.vintage=b.vintage
					and b.ii = 1
			join erp..bottleSizes c
				on a.bottleSize = c.bottleSize
			join erp..currencyConversion d
				on a.Currency=d.alertCurrency

alter view vForSalePlusOK as select * from vForSalePlus where errors is null
*/

update a set wineNN = b.wineN
	from vForSale a
		join (select wid, vintage, wineN, dateHi, row_number() over (partition by wid, vintage order by dateHi desc) ii from idUse) b 			
			on a.wid = b.wid				
				and a.vintage=b.vintage
				and b.ii = 1
	
--use erpin
truncate table medianDollars;
with
a as (select 
		  wineNN
		,  row_number() over(partition by wineNN order by dollarsPerLiter) ii
		,  dollarsPerLiter
		, auction
	from vForSalePlusOK
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
	

------------------------------------------------------------------------------------------
-- Remove outliers 1
------------------------------------------------------------------------------------------

update a set errors = isNull(errors + ';  ', '') + '[E48]  Bad Price - Less than 1/3 of the median' 
	from vForSalePlus a
		join medianDollars b
			on a.wineNN = b.wineN
	where (a.dollarsPerLiter * 3) < b.dollarsPerLiter

update a set errors = isNull(errors + ';  ', '') + '[E49]  Bad Price - More than 3 times the median' 
	from vForSalePlus a
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
	from vForSalePlusOK
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
	from vForSalePlus a
		join medianDollars b
			on a.wineNN = b.wineN
	where (a.dollarsPerLiter * 3) < b.dollarsPerLiter

update a set errors = isNull(errors + ';  ', '') + '[E49b]  Bad Price - More than 3 times the median (pass 2)' 
	from vForSalePlus a
		join medianDollars b
			on a.wineNN = b.wineN
		where a.dollarsPerLiter  > (3 *b.dollarsPerLiter);

with
a as (select wineNN, min(dollarsPerLiter) minDollars, max(dollarsPerLiter) maxDollars
		from vForSalePlus 
		group by wineNN 
		having count(*) = 2     )
,b as (select * from a where maxDollars > (3 * minDollars)     )
update c
	set errors = isNull(errors + ';  ', '') + '[E47]  Bad Price - Only 2 items, High > 3x Low' 
	from vForSalePlus c
		join b
			on c.wineNN = b.wineNN

select errors, count(*) cnt from vForSale group by errors

select wineNN, wid, vintage, dollarsPerLiter, price, bottleSize, currency, errors from vForSalePlus where wineNN in 
		(select distinct(wineNN) from vForSalePlus where errors like '%E47]%' or  errors like '%E48]%' or  errors like '%E49]%')
	order by wineNN, dollarsPerLiter




--oo iv, vforsaleplus

end