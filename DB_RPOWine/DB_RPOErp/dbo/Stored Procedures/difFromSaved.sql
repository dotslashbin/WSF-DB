------------------------------------------------------------------------------------------------------------------------------
-- difFromSaved
------------------------------------------------------------------------------------------------------------------------------
CREATE proc difFromSaved(@tableName varchar(max), @db varchar(max) = 'SavedTables')
as begin
set noCount on
declare @s varchar(max), @s2 varchar(max);

begin try exec ('drop table _dif'+@tableName+'Add') end try begin catch end catch
begin try exec ('drop table _dif'+@tableName+'Update') end try begin catch end catch;

with 
a as	(
			select column_name from information_schema.columns where table_name = @tableName
			except
			select column_name from savedTables.information_schema.columns where table_name = @tableName     )
,b as     (
			select 'alter table '+@db+'..'+table_name+' add '+column_name+' '+data_type+ case when character_maximum_length is null then '' else '(' +convert(varchar,character_maximum_length  )+')' end x
			from information_schema.columns
			where table_name = @tableName and column_name in (select column_name from a)     )
select @s= replace(dbo.concatFF(x), char(12), '
')  from b;

with
a as	(
			select column_name from information_schema.columns where table_name = @tableName
			intersect
			select column_name from savedTables.information_schema.columns where table_name = @tableName     )
, b as     (
			select column_name, data_type, character_maximum_length  from information_schema.columns where table_name = @tableName and column_name in (select * from a)
			except
			select column_name, data_type, character_maximum_length  from savedTables.information_schema.columns where table_name = @tableName and column_name in (select * from a)     )
,c as     (
			select 'alter table '+@db+'..'+@tableName+' alter column '+column_name+' '+data_type+ case when character_maximum_length is null then '' else '(' +convert(varchar,character_maximum_length  )+')' end x
			from b
			where data_type not in ('rowVersion','timeStamp')     )
select @s2= replace(dbo.concatFF(x), char(12), '
')  from c;

set @s += '
' + @s2

if @s like '%*%'
	print @s
else
	print '--  ' + @tableName+' is OK'

end
/*
if '
' like '%*%' print 'not blank'

exec difFromSaved BottleConsumed
exec difFromSaved taosting
exec difFromSaved whToWine
exec difFromSaved whToTrustedTaster
exec difFromSaved whToTrustedPub
exec difFromSaved Location
exec difFromSaved Purchase
exec difFromSaved Supplier

alter table whToWine drop column rowVersion
alter table whToWine add rowVersion binary(8)

alter table BottleConsumed drop column rowVersion
alter table BottleConsumed add rowVersion binary(8)
alter table tasting drop column rowVersion
alter table tasting add rowVersion binary(8)
alter table whToWine drop column rowVersion
alter table whToWine add rowVersion binary(8)
alter table whToTrustedTaster drop column rowVersion
alter table whToTrustedTaster add rowVersion binary(8)
alter table whToTrustedPub drop column rowVersion
alter table whToTrustedPub add rowVersion binary(8)
alter table Location drop column rowVersion
alter table Location add rowVersion binary(8)
alter table Purchase drop column rowVersion
alter table Purchase add rowVersion binary(8)
alter table Supplier drop column rowVersion
alter table Supplier add rowVersion binary(8)


oofrr

saveUser 18297, Tobias
loadFromSave 18297, Tobias,20
select * from location where whN=20
select * from whToWine where whN=20

*/



