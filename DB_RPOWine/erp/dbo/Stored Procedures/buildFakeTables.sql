CREATE proc buildFakeTables
as begin
	begin try
	drop table fakeWine;
	end try begin catch end catch;
	begin try
	drop table fakeSupplier;
	end try begin catch end catch;

	with
	a as (select wineN, max(rating) rating from tasting group by wineN)
	,b as (select row_number() over(order by rating desc) ii,  wineN from a)
	select top 300 ii,  wineN into fakeWine from b order by ii;

	with
	a as (select row_number() over(order by reverse(name)) ii, supplierN, name from supplier where name not like '%unk%')-- where name like '%[eo]%')
	select top 100 ii,supplierN, name into fakeSupplier from a order by ii
end
