create FUNCTION getSubSummary_before1001Jan29 (
/*
select dbo.getSubSummary('Bottle', 2,4,3,0, 'my cellar')
	3 Bottles: 2 cellared in my cellar; 1 not yet cellared; (1 consumed)
select dbo.getSubSummary('Bottle', 2,7,3,1, 'my cellar')
     3 Bottles: 2 cellared in my cellar; 1 on order; 1 not yet cellared
*/
		 @bottleSizeDescription varchar(max)
		,@cellarCount int
		,@purchaseCount int
		,@remainingCount int
		,@notDeliveredCount int
		,@compactLocationSummary varchar(max))
returns varchar(max)
as begin
	declare	 @consumedCount int = case when @notDeliveredCount > 0 then 0 else @purchaseCount - @remainingCount end
			,@notCellaredCount int = @remainingCount - isNull(@cellarCount, 0)
			,@s varchar(max) = ''
			,@parts int = 0;
	
	if @cellarCount > 0 set @parts += 1;
	if @notDeliveredCount > 0 set @parts += 1;
	if @notCellaredCount > 0 set @parts += 1;
	if @consumedCount > 0 set @parts += 1;
		
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
				+ case when @parts > 1 then '' else @bottleSizeDescription + case when @consumedCount > 1 then 's' else '' end end
				+ 'consumed)'
		end
	
	if  @parts > 1
		begin
			set @s = 
				--convert(varchar, @purchaseCount) + ' '
				convert(varchar, @remainingCount) + ' '
				+ @bottleSizeDescription + case when @purchaseCount > 1 then 's' else '' end
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
