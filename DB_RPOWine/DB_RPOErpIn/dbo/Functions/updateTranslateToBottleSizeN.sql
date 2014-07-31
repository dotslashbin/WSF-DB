CREATE function [dbo].[updateTranslateToBottleSizeN](@bottleSize varchar(max))
returns int
as begin
	declare @bottleSizeN int
	if @bottleSize is null or not @bottleSize like '%[^ ]%'
	begin
		return 9	--Standard Bottle Size from BottleSize table
	end
	else
		begin
			select @bottleSizeN = bottleSizeN from RPOErp..bottleSize where name = @bottleSize
			if @bottleSizeN is null
				select @bottleSizeN = bottleSizeN from RPOErp..bottleSize where name = dbo.superTrim(@bottleSize)
		end
	return @bottleSizeN	
end
