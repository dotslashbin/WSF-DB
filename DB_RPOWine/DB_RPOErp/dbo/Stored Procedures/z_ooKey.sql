-- finds all functions that match a list of keywords / coding utility [=]
CREATE  procedure [dbo].[z_ooKey] (@1 varchar(99) = '', @2 varchar(99)='', @3 varchar(99)='', @4 varchar(99)='', @5 varchar(99)='', @6 varchar(99)='')
as begin 
set noCount on
declare @T as table(w varchar(99))
declare @TS as table(w varchar(99))
declare @s varchar(max)
 
	if len(@1) > 0 insert into @T(w) select @1
	if len(@2) > 0 insert into @T(w) select @2
	if len(@3) > 0 insert into @T(w) select @3
	if len(@4) > 0 insert into @T(w) select @4
	if len(@5) > 0 insert into @T(w) select @5
	if len(@6) > 0 insert into @T(w) select @6
 
	insert into @TS(w) select w  from @T order by w
	select @s = dbo.concatenate(w) from @TS
	select @s = replace(@s, ' ', '')
	select @s = replace(@s, ';', '*')
	--select @s = @s + '*[[]=]'
 
	--print @s
	--exec oo 'fd', @s
	exec oo 'k', @s
end
