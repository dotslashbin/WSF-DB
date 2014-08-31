CREATE function [dbo].[fieldExists] (@dataBaseName nvarchar(300),     @tableName nvarchar(300), @fieldName nvarchar(300))
returns int
as begin
return case when exists(select * from information_schema.columns where table_catalog=case when @dataBaseName like '%[0-z]%' then @databaseName else  db_name() end and table_name=@tableName and column_name=@fieldName) then 1 else 0 end
end
 
