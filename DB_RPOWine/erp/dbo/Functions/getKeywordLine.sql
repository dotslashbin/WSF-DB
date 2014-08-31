--coding utility 			 [=]
CREATE function [dbo].[getKeywordLine](@def varchar(max))
returns varchar(max)
as begin

declare @i int, @r varchar(max)
set @i = charIndex('[=]', @def)
if @i > 0 begin
	set @r = left(@def, @i-1) 
	--set @r = rtrim(ltrim(replace(@r, '-', '')))
	end
else
	set @r = ''

return @r
end
