CREATE proc [dbo].[dougFunctions]
as begin
set noCount off
/*
begin try drop proc ovv end try begin catch end catch
begin try drop proc ov end try begin catch end catch
begin try drop proc ooi end try begin catch end catch 
begin try drop proc ooo end try begin catch end catch
begin try drop proc oon end try begin catch end catch
begin try drop proc oo end try begin catch end catch



--coding utility		[=]
CREATE FUNCTION [dbo].[ooFun]
(@1 varChar(50) = null, @2 varChar(50) = null, @3 varChar(50) = '')
RETURNS 
@TT TABLE (nm varchar(max),col varchar(max),	typ varchar(max),ord int)
AS
BEGIN
 
--	a	All					Show all types of object
--	c	Constraints	Include constraint objects
--	d	Definition		Include definition in search - columns for tables and views, function definition
--	e	Extended		Search all object types, full definition
--	f	Function		Include functions and procedures
--	g	debuG			Show argument summar as first line of output
--	i	InOrder			Sort in order of field definition
-- k	Keywords		Search only in the keyword prefix
-- n	Names			Just show object names
-- m	NamesOnly	Just search in the name field and show the names (defaults the 2nd arg to '')
-- o	NoArg			same as entering null
--	r	Recent			Sort with most recent first
--	rr	Recent			Sort with most recent first, put date after name
--	s	ColSort			Sort by col then table
--	t	Table				Include table objects
-- u	Unify				Search by or-ing table and column fields
-- v	View				Include view objects
-- x	indeXes			Show indexes
 
declare @T TABLE (nm varchar(max),col varchar(max),typ varchar(max), ord int, uDate dateTime)
declare @unify bit; set @unify = 0
declare @arg varChar(50); set @arg = ''
declare @name varChar(200); set @name = ''
declare @match varChar(200); set @name = ''
declare @col varChar(50); set @col = ''
declare @includeDefinition bit; set @includeDefinition = 0
 
--insert into @TT(nm)  select '@1='+isnull(@1, 'null')+'    @2='+isNull(@2, 'null')+'     @3='+isnull(@3, 'null')
--oo c
 
if @1 = 'o' set @1 = null
if @2 = 'o' set @2 = null
if @3 = 'o' set @3 = ''
 
select @name = @1, @col = @2, @arg = @3
 
set @match = @name
 
---------------
if @arg like '%g%' insert into @TT(nm)  select '11arg='+isNull(@arg, 'null')+'     nm='+isNull(@name, 'null')+'     col='+isNull(@col, 'null')+'     unify=' + cast(@unify as varchar)+'     includeDefinition=' + cast(@includeDefinition as varchar) 
---------------
 
--if @arg not like '%d%' set @arg = @arg + 'n'
if @arg like '%r%' and @arg not like '%[cftvx]%' set @arg = @arg + 'a'
if @arg like '%m%' begin
	--set @arg = replace(@arg, 'd', '')
	--set @arg = @arg + 'n'
	if isNull(@col, '') not like '%[0-9a-zA-Z]%' set @col = ''
	end
else begin
	if @arg like '%i%' and @arg not like '%d%' set @arg = @arg +'d'
	if @arg like '%e%' set @arg = @arg +'da'
	end
 
if @arg like '%u%' or @col is null set @unify = 1
 
 
set @arg = replace(@arg, '*', '%')
if @arg like '%a%' and @arg not like '%[cftvx]%'set @arg = @arg + 'cftvx'
if @arg not like '%[cftvx]%' set @arg = @arg + 't'
 
if @name is null set @name = ''; 
if @name = 'a' set @name = '*'
set @name = replace(@name, '*', '%')
 
/*
if @name like ' %' set @name = '_' + ltrim(@name)
if @name like '% ' set @name = rtrim(@name) + '_'
if @name like '[_]%[_]' 
	set @name = Ltrim(RTrim(@name))
else if @name like '[_]%'
	set @name = Ltrim(@name)	+ '%'
else if @name like '%[_]'
	set @name = '%' + Rtrim(@name)
else
	set @name = '%' + (@name) + '%'
if @name like '%[_]%' begin
	set @name = replace(@name, '[_]', '[%%]')
	set @name = replace(@name, '_', '')
	set @name = replace(@name, '[%%]', '[_]')
end
 
 	if @col is null set @col = ''; 
 
	if @col = 'a' set @col = '*'
	set @col = replace(@col, '*', '%')
	if @col like ' %' set @col = '_' + ltrim(@col)
	if @col like '% ' set @col = rtrim(@col) + '_'
 
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
*/
 
 
------------------------------------------------------------------------------------------
-- Experimental
------------------------------------------------------------------------------------------
if @name like ' %'
	set @name = ltrim(@name)
else
	set @name = '%' + ltrim(@name)
	
if @name like '% '
	set @name = rtrim(@name)
else
	set @name = rtrim(@name) +'%'
 
if @col like ' %'
	set @col = ltrim(@col)
else
	set @col = '%' + ltrim(@col)
	
if @col like '% '
	set @col = rtrim(@col)
else
	set @col = rtrim(@col) +'%'
------------------------------------------------------------------------------------------
-- Experimental END
------------------------------------------------------------------------------------------
 
 
if @arg like '%u%' set @unify = 1
 
if @arg like '%k%' begin
	--if @arg like '%g%' insert into @TT(nm)  select @match
	insert into @T(nm, typ, ord)
		select [name] nm, lower('(' + type_desc + ')') col, null
			from sys.objects z left join sys.sql_modules y on z.object_id = y.object_id
			where 
				--dbo.getKeywordLine(y.definition) like @name
				1 = dbo.utilRegexMatch(dbo.getKeywordLine(y.definition),@match,'')
				and [type] not in ('D', 'IT', 'PK', 'S')
 
	goto AllObjectsConsidered
	end
 
if @arg like '%n%' begin
		if @arg like '%g%' insert into @TT(nm)  select '4arg='+isNull(@arg, 'null')+'     nm='+isNull(@name, 'null')+'     col='+isNull(@col, 'null')+'     unify=' + cast(@unify as varchar)+'     includeDefinition=' + cast(@includeDefinition as varchar)
		if @arg like '%t%' begin
			insert into @T(nm, col, typ, ord)
					select table_name nm, '', '(table)', 0 
					from information_schema.columns
					where ((column_name like @col and table_name like @name)
						or (@unify = 1 and (column_name like @name or table_name like @name)))
						and table_name not in (select table_name from information_schema.views)	
			end
 
		if @arg like '%v%' begin
			insert into @T(nm, col, typ, ord)
					select table_name nm, '', '(view)', 0 
					from information_schema.columns
					where ((column_name like @col and table_name like @name)
						or (@unify = 1 and (column_name like @name or table_name like @name)))
						and table_name in (select table_name from information_schema.views)	
			end
 
	end
else begin
	if @arg like '%t%' or @arg like '%v%'
		insert into @T(nm, col, typ, ord)
				--select table_name nm, column_name, data_type, ordinal_position ord 
				select table_name nm, column_name
					,data_type + case when character_maximum_length is null then '' else '(' + cast(character_maximum_length as varchar) + ')' end
					,ordinal_position ord 
				from information_schema.columns
				where (column_name like @col and table_name like @name)
					or (@unify = 1 and (column_name like @name or table_name like @name))
		if @arg not like '%v%'
		delete from @T where nm in (select table_name from information_schema.views)	
	if @arg not like '%t%'
		delete from @T where nm not in (select table_name from information_schema.views)	
end
 
if @arg like '%f%' begin
	if @arg like '%d%' and @arg not like '%n%'  set @includeDefinition = 1 else set @includeDefinition = 0
	insert into @T(nm, typ, ord)
		select [name] nm, lower('(' + type_desc + ')') col, null
			from sys.objects z left join sys.sql_modules y on z.object_id = y.object_id
			where 
				(([name] like @name and (@includeDefinition = 0 or (@includeDefinition = 1 and y.definition like @col) ))
					or (@Unify = 1 and ([name] like @name or (@includeDefinition = 1 and y.definition like @name))))
				and [type] not in ('D', 'IT', 'PK', 'S', 'V', 'U')
	end
 
if @arg like '%c%'
	insert into @T(nm, typ, ord)
		select [name] nm, lower('(' + type_desc + ')') col, null
			from sys.default_constraints
			where 
				(([name] like @name and definition like @col)
					or (@unify = 1 and (([name] like @name or definition like @name))))
				and [type] in ('D');
 
AllObjectsConsidered:
if @arg like '%g%' insert into @TT(nm)  select 'arg='+isNull(@arg, 'null')+'     nm='+isNull(@name, 'null')+'     col='+isNull(@col, 'null')+'     unify=' + cast(@unify as varchar)+'     includeDefinition=' + cast(@includeDefinition as varchar)
 
if @arg	like '%r%' begin
	update z set z.uDate = y.modify_date
		from @T z
			join sys.objects y
				on z.nm = y.name
 
	if @arg like '%rr%'
		update @T set nm += ' (' + convert(varchar,uDate) + ')'
	
	if @arg like '%n%' begin
		insert into @TT(nm,col,typ,ord) select nm,min(col),min(typ), '' from @T group by uDate,  nm order by uDate desc, nm
	end
	else if @arg like '%i%' begin
		insert into @TT(nm,col,typ, ord) select nm,col,typ,ord from @T order by uDate desc, nm, ord
	end
	else if @arg like '%s%' or (@arg like '%f%' and @arg not like '%tv%') begin
		insert into @TT(nm,col,typ,ord) select nm,col,typ, ord from @T order by uDate desc, col, typ, nm
	end
	else begin
		insert into @TT(nm,col,typ, ord) select nm,col,typ, ord from @T where udate is not null order by uDate desc, nm, col, typ
	end
end
else begin
	if @arg like '%g%' insert into @TT(nm)  select '5 arg='+isNull(@arg, 'null')+'     nm='+isNull(@name, 'null')+'     col='+isNull(@col, 'null')+'     unify=' + cast(@unify as varchar)+'     includeDefinition=' + cast(@includeDefinition as varchar)
 
	if @arg like '%n%'
		insert into @TT(nm,col,typ,ord) select nm,min(col),min(typ), '' from @T group by nm order by nm
	else if @arg like '%i%'
		insert into @TT(nm,col,typ, ord) select nm,col,typ,ord from @T order by nm, ord
	else if @arg like '%s%' or (@arg like '%f%' and @arg not like '%tv%')
		insert into @TT(nm,col,typ,ord) select nm,col,typ, ord from @T order by col, typ, nm
	else
		insert into @TT(nm,col,typ, ord) select nm,col,typ, ord from @T order by nm, col, typ
end
 
RETURN 
END
 
 


=gg

create  procedure oo
	 @1 varchar(99) = ''
	,@2 varchar(99)=null
	,@3 varchar(99)=null
as begin
	select * from ooFun (@2, @3, @1) 
end
=gg 


CREATE  procedure oon @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'n', @1, @2
end
=gg

CREATE  procedure ooi @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'i', @1, @2
end
=gg

CREATE  procedure oofr @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'fr', @1, @2
end
=gg

CREATE  procedure ooo @1 varchar(99) = '', @2 varchar(99)=null
as begin 
	exec oo 'o', @1, @2
end
=gg

=gg



=gg


CREATE function superTrim(@s nvarchar(max))
returns nvarchar(max)
as begin
	declare @s2 nvarchar(max) = ltrim(rtrim(@s))
	while 0 < charIndex('  ', @s2)
		set @s2 = replace(@s2, '  ', ' ')
	return	 @s2
end
 

=gg


/*
use erp
od tasting
*/
CREATE proc od(@table varchar(max), @fields varchar(max)=null, @where varchar(max) = '', @byFrequency bit = 0)
as begin
	declare @q nvarchar(max) = 'Select @fields, count(*) cnt from @table group by @fields '
	if @where like '%[^ ]%' set @q = replace(@q, '@table', '@table where ' + @where)
	if @fields is null or @fields not like '%[^ ]%'
		begin
			exec ('Select count(*) cnt from ' + @table)
			return
		end
 
	set @fields = replace(@fields, ',', ' ')
      set @fields = dbo.superTrim(@fields)
	set @fields = replace (@fields, ' ', ',')
	if @byFrequency = 0 
		set @q += ' order by @fields'
	else
		set @q += ' order by cnt desc'
	
	set @q = replace(@q, '@table', @table)
	set @q = replace(@q, '@fields', @fields)
	exec (@q)
end
 
 
 
 

=gg
--use erp
--select top 1000 * into tt from maywine
 
CREATE proc [dbo].[ovv] (@tableName nvarChar(max),  @fields nvarchar(max) = '', @where nvarChar(max) = '', @outTable nvarchar(max) = '', @maxRows int = 100, @minValueCount int = 2)
as begin
--declare @tableName nvarChar(max)='tasting', @where nvarChar(max) = '', @fields varchar(max) = 'foo _fixedIdDeleted',@maxRows int = 5, @minValueCount int = 1, @outTable nvarchar(max) = ''
set noCount on
 
set @fields = '  ' + isNull(@fields,'') + '  '
if ISNULL(@minValueCount, 0) < 1 set @minValueCount = 2
 
declare @s nvarchar(max), @r int,@columns nvarchar(max) = '', @columnsPadded nvarchar(max) = '', @columnCount int, @i int = 1, @z int, @columnName nvarchar(200), @createTemp nvarchar(max), @dataType nvarChar(30)
declare @countZeros bit = 0, @mapWh bit = 0, @value nvarchar(max) = '', @useFields bit
 
set @tableName = ltrim(rtrim(@tableName))
set @where = ltrim(rtrim(@where))
 
if @where like '%[^ ]%' set @where = 'where '+ @where
set @r = patIndex(N'%where%', @where)
if @r > 0
	begin
		set @s = ' ' + left(@where, @r-1)
		set @where = right(@where, len(@where) - @r + 1)
	end
else
	begin
		set @s = @where
		set @where = ''
	end
if @s like '%[Zz]%' set @countZeros = 1
if @s like '%[Nn]%' set @mapWh = 1
 
 
begin try
	if not @minValueCount >=  1 set @minValueCount = 2
end try
begin catch
	set @minValueCount = 2
end catch
 
set @createTemp = ('Select Top ' + convert(nvarchar,@maxRows) + ' 12345 ii, ')
 
declare @where1 nvarChar(200), @where2 nvarChar(200)
select @columnCount = MAX(ordinal_position) from INFORMATION_SCHEMA.columns where table_name = @tableName
 
------------------------------------------------------------------------------------------
-- get explicit field order
------------------------------------------------------------------------------------------ 
 
declare @TF table (idN int identity(1,1), colName varchar(200))
insert into @TF(colName) select part from dbo.oSplit(@fields, ' ')
 
/*select * from dbo.oSplit(@fields, ' ')
select * from dbo.oSplit(@fields, ' ')
return*/
 
select @z = count(*) from @TF
if @z > 0
	select @useFields=1
else
	select @useFields=0, @z=@columnCount
 
------------------------------------------------------------------------------------------ 
--Get occupied columns
------------------------------------------------------------------------------------------ 
set @i = 1
while @i <= @z
	begin
		if @useFields = 1
			begin
				select @columnName = colName from @TF where idN=@i
				--print @columnName
				select @where2 = '', @dataType = data_type  from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @tableName and column_name = @columnName
			end
		else
			select @where2 = '', @columnName = column_name, @dataType = data_type  from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @tableName and ORDINAL_POSITION = @i
		if @dataType not in ('rowVersion','timeStamp') and @columnName <> 'ii'
			begin
				if @dataType in ('bigint','bit','decimal','float','int','money','numeric','real','smallint','smallmoney','tinyint')
					set @where2 = ' '+@columnName+' is not null'					--                 ' isNull(' + @columnName + ',0) <> 0'
				else
					begin
						If @dataType in ('char','nchar','ntext','nvarchar','text','varchar')
							set @where2 = ' len(' + @columnName + ') > 0'
						else
							set @where2 = ' ' +  @columnName + ' is not null '
					end
				
				if LEN(@where2) > 0
					begin
						if @where like '%where%'
							set @where1 = @where + ' and ' + @where2 
						else
							set @where1 = ' where ' +	@where2
					end
				else
					set @s = @where1 + ' ' + @columnName + ' is not null '
			
				select @s = 'select @r = count(distinct('+@columnName+')) from '+@tableName+' ' + @where1
				
				exec sp_executeSQL @s, N'@r int output', @r output;
				
				if @r >= @minValueCount
					begin
						set @columnsPadded += convert(nchar(100),@columnName)
						set @createTemp += ' convert(nvarchar(max), '''') ' + @columnName + ','
					end
			end		
 
		set @i += 1
	end
 
 
set @s = 'begin try
	drop table dbo.ovv_temp1
end try begin catch 
		print ''could not drop dbo.ovv_temp1''
end catch
begin try
	' + LEFT(@createTemp, len(@createTemp) - 1) + ' into dbo.ovv_temp1 from ' + @tableName +'
end try begin catch
	print ''could not create dbo.ovv_temp1''
end catch';
 
Execute(@s);
 
with 
	a as (select ROW_NUMBER() over (order by ii) iRow2, * from dbo.ovv_temp1)
update a set ii = iRow2
			
-----------------------------------------------------------------------------------------------------------
--Fill in the values for each column
-----------------------------------------------------------------------------------------------------------
set @i = 1
while @i <= @columnCount
	begin
		set @columnName = rTrim(SUBSTRING(@columnsPadded, 1 + 100 * (@i - 1), 100));
		if len(@columnName) = 0 break
		
		set @value =	   'b.v';
		if @mapWh = 1 and @columnName in ('whN', '_bottleWhN', 'pubN', 'pubGN', 'masterPubN','defaultPubN', 'createWhN', 'updateWhN', 'tasterN','trustedN', 'toN' )
				set @value = ' dbo.getName2(b.v)'
 
		set @s = 
				'with
					 d as (select * from '+@tableName+' '+@where+')
					,a as (select isNull(convert(nvarchar,'+@columnName+'), ''(null)'') v, count(*) cnt from d group by '+@columnName+') 
					,b as (select row_number() over (order by cnt desc) ii, v, cnt from a)
				update c set c.'+@columnName+' = (convert(nvarchar,'+@value+') + ''  ('' + convert(nvarchar,cnt) + '')'') 
					from dbo.ovv_temp1 c 
						join b	 on c.ii = b.ii'		
 
		begin try
			exec (@s)
		end try
		begin catch
			set @r = @r
		end catch
 
		set @i += 1
	end
 
if @outTable like '%[^ ]%' 
	begin
		if @outTable <> 'dbo.ovv_temp1'
			begin	
				set @s='	begin try drop table @@@ end try begin catch end catch
					begin try select * into @@@ from dbo.ovv_temp1 end try begin catch print ''Could not create table @@@'' end catch'
				set @s = replace(@s, '@@@', @outTable)
				exec (@s)
			end
	end
else
	begin
		select * from dbo.ovv_temp1			 
	end
 
set noCount off
end
 
 
 
 
 
 

=gg


CREATE proc [dbo].[ov] (@tableName nvarChar(max),  @fields nvarchar(max) = '', @where nvarChar(max) = '', @outTable nvarchar(max) = '', @maxRows int = 100, @minValueCount int = 2)
as begin
--select @where = 'N ' + @where, @fields  = 'N ' + @fields, @outTable  = 'N ' + @outTable
exec erp..ovv @tableName, @fields, @where, @outTable, @maxRows, @minValueCount
end
 
 
*/
end