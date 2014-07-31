CREATE function [dbo].[append](@left nvarchar(max), @right nvarchar(max), @sep nvarchar(max)=null)
returns nvarchar(max)
as begin
if @sep is null set @sep='
'
if @left like '%[0-z]%'
	begin
		if @right like '%[0-z]%'
			return @left+@sep+@right
		else
			return @right
	end
else
	return @right
return  @left
end
