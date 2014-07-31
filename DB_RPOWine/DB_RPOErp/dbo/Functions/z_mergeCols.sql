--utility 			 [=]
CREATE function [dbo].[z_mergeCols] (@includeDups bit, @1 varchar(max), @2 varchar(max) = null, @3 varchar(max) = null, @4 varchar(max) = null)
returns varchar(max)
as begin
declare @r varchar(max), @prefix varchar(99), @tableName varchar(99), @suffix varchar(99)
declare @T table(col varchar(99), col2 varchar(99))
declare @N table(col varchar(99), col2 varchar(99))

if @1 like '%_%' begin
select @prefix = 'a.', @tableName = @1, @suffix = '_1'
insert into @T(col, col2) 
	select col, @prefix + col 
		from 	oofun((' ' +@tableName + ' '), '', 'tvi') where nm = @tableName
end

if @2 like '%_%' begin
	select @prefix = 'b.', @tableName = @2, @suffix = '_2'
	delete from @N

	insert into @N(col, col2) 
		select col, @prefix + col 
			from 	oofun((' ' +@tableName + ' '), '', 'tvi') where nm = @tableName

 	if @includeDups = 1 	update @N set col2 = @prefix + col + + ' ' + col + @suffix where col in (select col from @T)
	else delete from @N  where col in (select col from @T)

	insert into @T(col, col2) select col, col2 from @N
end

if @3 like '%_%' begin
	select @prefix = 'c.', @tableName = @3, @suffix = '_3'
	delete from @N

	insert into @N(col, col2) 
		select col, @prefix + col 
			from 	oofun((' ' +@tableName + ' '), '', 'tvi') where nm = @tableName

 	if @includeDups = 1 	update @N set col2 = @prefix + col + + ' ' + col + @suffix where col in (select col from @T)
	else delete from @N  where col in (select col from @T)

	insert into @T(col, col2) select col, col2 from @N
end

if @4 like '%_%' begin
	select @prefix = 'd.', @tableName = @4, @suffix = '_4'
	delete from @N

	insert into @N(col, col2) 
		select col, @prefix + col 
			from 	oofun((' ' +@tableName + ' '), '', 'tvi') where nm = @tableName

 	if @includeDups = 1 	update @N set col2 = @prefix + col + + ' ' + col + @suffix where col in (select col from @T)
	else delete from @N  where col in (select col from @T)

	insert into @T(col, col2) select col, col2 from @N
end


select @r = dbo.concatenate(col2) from @T

set @r = replace(@r, ';   ',';')
set @r = replace(@r, ';  ',';')
set @r = replace(@r, '; ',';')
set @r = replace(@r, ';',',')

if right(@r, 1) = ','  	set @r = left(@r, len(@r) - 1)

return @r
/*
print dbo.xxMergeCols('PubGtoPub', 'wineName', 'Tasting', null)
*/
end


