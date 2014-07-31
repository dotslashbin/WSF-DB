-- finds all functions that match a list of keywords / coding utility [=]
CREATE  procedure [dbo].[ooKey] (@1 varchar(99) = '', @2 varchar(99)='', @3 varchar(99)='', @4 varchar(99)='', @5 varchar(99)='', @6 varchar(99)='')
as begin 
set noCount on
declare @T as table(w varchar(99))
declare @TS as table(w varchar(99))
declare @s varchar(max)

	set @s = ''
	if len(@1) > 0 set @s = @s + '(?=.*\b' + @1 +')'
	if len(@2) > 0 set @s = @s + '(?=.*\b' + @2 +')'
	if len(@3) > 0 set @s = @s + '(?=.*\b' + @3 +')'
	if len(@4) > 0 set @s = @s + '(?=.*\b' + @4 +')'
	if len(@5) > 0 set @s = @s + '(?=.*\b' + @5 +')'
	if len(@6) > 0 set @s = @s + '(?=.*\b' + @6 +')'

	set @s = @s + '.*'
 
	exec oo 'k', @s
end
