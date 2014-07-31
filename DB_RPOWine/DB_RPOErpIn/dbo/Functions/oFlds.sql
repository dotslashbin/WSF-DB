CREATE function oFlds (@a varchar(max), @excludedFields varchar(max)='')
returns nvarchar(max)
as begin
	declare @c nvarchar(max);
	set @excludedFields = ' ' + replace(isNull(@excludedFields, ''), ',',' ')+ ' '
	select @c= replace(dbo.concatFF(column_name), char(12), ',') from information_schema.columns where table_name = @a and @excludedFields not like ('% ' + column_name + ' %')
	return @c
end
 
 
 
 