create function isTable(@tableName varchar(max))
returns bit
begin
	declare @r bit
	if exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = @tableName)
		set @r=1
	else 
		set @r = 0
return @r
end
