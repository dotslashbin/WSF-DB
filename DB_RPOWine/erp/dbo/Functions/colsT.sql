CREATE FUNCTION [dbo].[colsT]
(
	@table varChar(50) = '',
	@col varChar(50) = '',
	@arg varChar(2) = 'tc'
	,@views varChar(2) = 't'
)
RETURNS 
@T TABLE 
(
	db varchar(max),
	tb varchar(max),
	col varchar(max),
	ord varchar(max)
)
AS
BEGIN

-------------------------------
--if @table like '_%' set @table = 'wh'
-------------------------------

if @table like ' %' set @table = '_' + ltrim(@table)
if @table like '% ' set @table = rtrim(@table) + '_'
if @table like '[_]%[_]' 
	set @table = Ltrim(RTrim(@table))
else if @table like '[_]%'
	set @table = Ltrim(@table)	+ '%'
else if @table like '%[_]'
	set @table = '%' + Rtrim(@table)
else
	set @table = '%' + (@table) + '%'
if @table like '%[_]%' begin
	set @table = replace(@table, '[_]', '[%%]')
	set @table = replace(@table, '_', '')
	set @table = replace(@table, '[%%]', '[_]')
end



if @col like ' %' set @col = '_' + ltrim(@col)
if @col like '% ' set @col = rtrim(@col) + '_'
if @col is null begin
	insert into @T(db, tb, col, ord)
			select table_catalog db, table_name tb, null col, null ord 
			from information_schema.columns
			where table_name like @table
				group by table_catalog, table_name
				order by table_catalog, table_name
end
else begin
	if @col like '[_]%[_]'
		set @col = Ltrim(RTrim(@col))
	else if @col like '[_]%'
		set @col = Ltrim(@col)	+ '%'
	else if @col like '%[_]'
		set @col = '%' + Rtrim(@col)
	else
		set @col = '%' + (@col) + '%'
	
	if @col like '%[_]%' begin
		set @col = replace(@col, '[_]', '[%%]')
		set @col = replace(@col, '_', '')
		set @col = replace(@col, '[%%]', '[_]')
	end
end

if @arg = 'i' or @arg = 'o' or @arg = '1'
	insert into @T(db, tb, col, ord)
			select table_catalog db, table_name tb, column_name col, ordinal_position ord 
			from information_schema.columns
			where column_name like @col
				and table_name like @table
				order by table_catalog, table_name, ordinal_position
else if @arg = 't'
	insert into @T(db, tb, col, ord)
			select table_catalog db, table_name tb, '' col, '' ord 
			from information_schema.columns
			where column_name like @col
				and table_name like @table
				group by table_catalog, table_name
				order by table_catalog, table_name 
else if @arg = 'tt'
	insert into @T(db, tb, col, ord)
			select table_catalog db, table_name tb, '' col, '' ord 
			from information_schema.columns
			where column_name like @col
				and table_name like @table and left(table_name, 2) in ('aa','bb','cc','dd','ee','ff','gg','hh','ii','jj','kk','ll','mm','nn','oo','pp','qq','rr','ss','tt','uu','vv','ww','xx','yy','zz')
				group by table_catalog, table_name
				order by table_catalog, table_name 
else if @arg = 'c'
	insert into @T(db, tb, col, ord)
			select table_catalog db, '' tb, column_name col, '' ord 
			from information_schema.columns
			where column_name like @col
				and table_name like @table
				group by table_catalog, column_name
				order by table_catalog, column_name 
else if @arg in ('ct')
	insert into @T(db, tb, col, ord)
			select table_catalog db, table_name tb, column_name col, '' ord 
			from information_schema.columns
			where column_name like @col
				and table_name like @table
				order by table_catalog, column_name, table_name
else --tc
	insert into @T(db, tb, col, ord)
			select table_catalog db, table_name tb, column_name col, '' ord 
			from information_schema.columns
			where column_name like @col
				and table_name like @table
				order by table_catalog, table_name, column_name

if @views = 't'
	delete from @T where tb in (select table_name from information_schema.views)	
else if @views = 'v'
	delete from @T where tb not in (select table_name from information_schema.views)	



  RETURN 
END
