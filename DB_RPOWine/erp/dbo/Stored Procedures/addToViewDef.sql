--coding utility		[=] 
CREATE procedure addToViewDef
	 @viewShortName varchar(99)
	,@tableName varchar(99)
	,@tableOrder int = null
	,@where varchar(99) = ''
	,@viewTitle varchar(999) = ''
	,@commentsAboutView varchar(max) = ''
	,@renumber bit = 0
as begin set nocount on
-- xref 
/*
Declare @viewShortName varchar(99), @tableName varchar(99)	,@where varchar(99)	,@viewTitle varchar(999),@commentsAboutView varchar(max)
select @viewShortName =  'xxTaste', @tableName='Tasting'
select displayName, shortName, comments from wh where shortName like '%xx%'
addToViewDef xxTaste, tasting, 3, '', '', 'new comments'
*/

print 'NEED TO AUTOMATICALLY ADJUST COLALIAS WHEN CONFLICTS'

declare @viewN int, @existingComments varchar(max), @base int
set @viewShortName = replace(@viewShortName, ' ', '')
select @viewN = whN, @existingComments = replace(comments, ' ', '') from wh where shortName = @viewShortName and isView = 1
if @viewN is not null begin
		update wh
			set 
				 displayName = case when len(isNull(@viewTitle, '')) > 0 then @viewTitle else displayName end
				,comments = case when len(isNull(@commentsAboutView, '')) > 0 then @commentsAboutView else comments end
			where whN = @viewN
	end
else
	insert into wh(isView, shortName, displayName, comments) 
		select 1, @viewShortName, @viewTitle, @commentsAboutView

select @viewN = whN from wh where shortName = @viewShortName and isView = 1

if len(isNull(@tableName, '')) > 0 begin
	select @base = isNull(max(colOrder), 0) from viewdef where viewN = @viewN
	print '@viewN=' + isnull(cast(@viewN as varchar), 'null') + '     @base=' + isnull(cast(@base as varchar), 'null')

	insert into viewdef(viewN, tableName, tableOrder, colName, colOrder, isInactive)
		select @viewN, nm, @tableOrder, col, (ord + @base), 0
			from oofun(' ' + @tableName + ' ','','tvi')
		where not exists (select * from viewDef where viewN = @viewN and tableName = @tableName and colName = col)





		--fixup table order in case it's changed
		if @tableOrder is not null begin
			if exists (select * from viewDef 
						where viewN = @viewN and tableName = @tableName 
							and tableOrder is null or tableOrder <> @tableOrder) begin
				print 'reorder tables:  ' + @tableName + '   ' + cast(@tableOrder as varchar)
				update viewDef set tableOrder = 1 + tableOrder 
					where viewN = @viewN and tableOrder >= @tableOrder
				update viewDef set tableOrder = @tableOrder
					where viewN = @viewN and tableName = @tableName
				end
			end
			--addToViewDef xxTaste, tasting, 3




	end

--addToViewDef xxTaste, '', '', '', '', '', 1
print 'step 0'
if @renumber =1 begin
	print 'renumber'

	update z set z.tableOrder = y.x
		from viewDef z
			join (select tableName, row_number() over (order by tableOrder) x
						from (select tableName, max(tableOrder) tableOrder
									from viewdef 
									where viewN = @viewN
									group by tableName
									) x
						) y
				on z.tableName = y.tableName
			where z.viewN = @viewN
	
	
	if len(@tableName) = 0 begin
		print 'step 2'
		update z set colOrder = y.x
			from viewDef z
				join (select viewN, tableName, colName, row_number() over(order by tableOrder, colOrder) x
							from viewDef where viewN = @viewN) y
					on z.viewN = y.viewN and z.colName = y.colName
			where z.viewN = @viewN
		end
	end
end

