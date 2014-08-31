CREATE FUNCTION getSummaryForSize (
/*
select dbo.getSummaryForSize(2,4,3,0, 'Bottle', 'my cellar')
	9 Bottles: 3 cellared in my cellar; 2 on order; 4 not yet cellared
select dbo.getSummaryForSize(2,4,3,13, 'Bottle', 'my cellar')
	9 Bottles: 3 cellared in my cellar; 2 on order; 4 not yet cellared; (13 consumed)
select dbo.getSummaryForSize(0,0,2,2, 'Bottle', 'my cellar') 
	2  Bottles in my cellar; (2 consumed)

select dbo.getSummaryForSize(1,4,3,0, 'Bottle', 'my cellar')
select dbo.getSummaryForSize(1,0,0,0, 'Bottle', 'my cellar')
select dbo.getSummaryForSize(0,1,0,0, 'Bottle', 'my cellar')
select dbo.getSummaryForSize(0,0,1,0, 'Bottle', 'my cellar')
select dbo.getSummaryForSize(1,0,0,3, 'Bottle', 'my cellar')



select dbo.getSummaryForSize(0,0,0,2, 'Bottle', 'my cellar') 
	(2 Bottles consumed)
select dbo.getSummaryForSize(0,0,0,1, 'Bottle', 'my cellar') 
	(1 Bottle consumed)
 
*/
		@notDeliveredCount int
		,@notCellaredCount int
		,@cellarCount int
		,@consumedCount int
		,@bottleSizeDescription varchar(max)
		,@compactLocationSummary varchar(max))
returns varchar(max)
as begin
	declare	@remainingCount int = @notDeliveredCount + @notCellaredCount + @cellarCount
			,@s varchar(max) = ''
			,@parts int = 0;
	
	if @notDeliveredCount > 0 set @parts += 1;
	if @notCellaredCount > 0 set @parts += 1;
	if @cellarCount > 0 set @parts += 1;
	--if @consumedCount > 0 set @parts += 1;
		
	if @cellarCount > 0
		begin
			set @s += 
				case when len(@s) > 1 then '; ' else '' end
				+ convert(varchar, @cellarCount) + ' '
				+ case when @parts > 1 then 'cellared ' else ' ' + @bottleSizeDescription + case when @cellarCount > 1 then 's ' else ' ' end end
				+ 'in ' + @compactLocationSummary
		end
	
	if @notDeliveredCount > 0
		begin
			set @s += 
				case when len(@s) > 1 then '; ' else '' end
				+ convert(varchar, @notDeliveredCount) + ' '
				+ case when @parts > 1 then '' else @bottleSizeDescription + case when @notDeliveredCount > 1 then 's ' else ' ' end end
				+ 'on order'
		end
	
	if @notCellaredCount > 0
		begin
			set @s += 
				case when len(@s) > 0 then '; ' else '' end
				+ convert(varchar, @notCellaredCount) + ' '
				+ case when @parts > 1 then '' else @bottleSizeDescription + case when @notCellaredCount > 1 then 's ' else ' ' end end
				+ 'not yet cellared'
		end
 
	if @consumedCount > 0
		begin
			set @s += 
				case when len(@s) > 1 then '; (' else '(' end
				+ convert(varchar, @consumedCount) + ' '
				+ case when len(@s) > 1 
					then 
						case when @consumedCount > 1 then 'others ' else 'other ' end
					else
						@bottleSizeDescription + case when @consumedCount > 1 then 's ' else ' ' end
					end
				--+ case when @parts >= 1 then '' else @bottleSizeDescription + case when @consumedCount > 1 then 's ' else ' ' end end
				+ 'consumed)'
		end
	
	if  @parts > 1
		begin
			set @s = 
				convert(varchar, @remainingCount) + ' '
				+ @bottleSizeDescription + case when @remainingCount > 1 then 's' else '' end
				+ ': '
				+ @s
		end
		
return @s
 
 
		-- count up parts, if more than 1 use colon prefix and replace XBottlesX with '' else name(s)
		-- 3XXX in asdfasdf; 1XXX
		-- 7 magnums: 3 in asdfsdaf;  1 on order; 3 not yet cellared.
		-- 3 magnums: 1 on order; 2 not yet cellared;  (1 consumed)
		-- 3 magnums: 1 on order; 2 not yet cellared;  3 consumed
		-- (3 magnums consumed)
 
end
 
--oodef oofun
 
