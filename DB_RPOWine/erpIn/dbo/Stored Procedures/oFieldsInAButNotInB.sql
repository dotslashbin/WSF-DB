
CREATE proc oFieldsInAButNotInB (@a varchar(max), @b varchar(max) = null     )
as begin
 
declare @q varchar(max) = '
	select column_name from information_schema.columns where table_Name = ''@a''
'
set @q = replace (@q, '@a', @a)
 
if @b like '%[^ ]%' 
begin
	set @q += 'except
	select column_name from information_schema.columns where table_Name = ''@b''
	'
	--print @q
 
	set @q = replace (@q, '@b', @b)
end
exec (@q)
end
 
