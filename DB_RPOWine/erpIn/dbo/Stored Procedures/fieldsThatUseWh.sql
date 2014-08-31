CREATE proc [dbo].[fieldsThatUseWh]
as begin
set noCount On
end

/*
set noCount on
--drop table whCross_b
--create table whCross_a (tName varchar(300), cName varchar(300))
--create table whCross_b (tName varchar(300), cName varchar(300), whN int, fullName varchar(300), cnt int)

truncate table whCross_a
truncate table whCross_b

insert into whCross_a(tName, cName)
	select a.table_name, a.column_name
	from information_schema.columns a
		join information_schema.tables b
			on a.table_catalog = b.table_catalog and a.table_name = b.table_name
	 where 
		 b.table_catalog='erp' 
		 and a.data_type in ('int','bigint','smallint')
		 and b.table_type = 'base table'
		 and a.table_name not in ('erpWine', 'BottleSizes', 'fakeLocation', 'junk', 'bottleLocation-old', 'mapPubGToWine', 'mapPubGToWineName', 'mapPubGToWineTasting', 'maywine', 'priceGToSeller','tasterWine','testQuery','tt','viewDef','wh','whCross_a','whCross_b','whex','whToCellarArea','whMay','mapPriceGToWineName','xxx','xxx', 'xx', 'xx')
		 and a.table_name not like 'z_%'
		 and a.column_name not in ('rating','Rating_Hi', 'currentBottleCount', 'pubIconN', 'articleHandle', 'ii', 'locationN', 'idN', 'bottleCount', 'purchaseN', 'bottleSizeN', 'iconN', 'xx', 'xx')
		 and a.column_name not like '%count';



declare @qTemplate varchar(max) = 'if not exists (     select *
					from [@tName@] a
						left join wh b
							on a.@cName@=b.whN
					where b.whN is null
						and a.@cName@ is not null     )
	begin
		insert into whCross_b(tName,cName, whN, fullName,cnt)
			select ''@tName@'', ''@cName@'', b.whN, b.fullName, count(*)
				from [@tName@] a
					left join wh b
						on a.@cName@=b.whN
				where b.whN is not null
				group by b.whN, b.fullName
	end'
			
declare @tName varchar(max), @cName varchar(max), @q varchar(max)
declare i cursor for select tName, cName from whCross_a order by tName, cName
open i
while 1=1
	begin
		fetch next from i into @tName, @cName
		if @@fetch_status <> 0 break
		
		set @q = replace(@qTemplate, '@tName@', @tName)
		set @q = replace(@q, '@cName@', @cName)
		
		--print @tName + '   ' + @cName
		--print (@q)
		exec (@q)
	end
close i
deallocate i



*/