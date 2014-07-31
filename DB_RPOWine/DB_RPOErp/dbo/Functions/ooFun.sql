--coding utility		[=]
CREATE FUNCTION [dbo].[ooFun]
(@1 varChar(50) = null, @2 varChar(50) = null, @3 varChar(50) = '')
RETURNS 
@TT TABLE (nm varchar(max),col varchar(max),	typ varchar(max),ord int)
AS
BEGIN
 
--	a	All					Show all types of object
--	b*	blank 2nd arg	Just search in the name field and show the names (defaults the 2nd arg to '')
--	c	Constraints		Include constraint objects
--	d	Definition			Include definition in search - columns for tables and views, function definition
--	e	Extended			Search all object types, full definition
--	f	Function			Include functions and procedures
--	g	debuG				Show argument summar as first line of output
--	i	InOrder			Sort in order of field definition
--	k	Keywords			Search only in the keyword prefix
--	n	Names				Just show object names
--	o	NoArg				same as entering null
--	r	Recent				Sort with most recent first
--	rr	Recent				Sort with most recent first, put date after name
--	s	ColSort			Sort by col then table
--	t	Table				Include table objects
--	u	Unify				Search by or-ing table and column fields
--	v	View				Include view objects
--	w*	Row Recent		Include table row modification in recent
--	ww*	Row Recent		Include table row modification in recent, put date after name
--	x	indeXes			Show indexes
 
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
if @arg like '%b%' begin
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
 
if @arg like '%w%' and @arg not like '%r%' set @arg += 'r'

if @arg	like '%r%' begin
	if @arg like '%w%'
		begin
			update z set z.uDate = y.modify_date
				from @T z
					join sys.objects y
						on z.nm = y.name
		end
	else
		begin
			update z set z.uDate = y.modify_date
				from @T z
					join sys.objects y
						on z.nm = y.name
		end
 
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
 
 
