CREATE function [dbo].[showCellarInfo1](@bottleLocations nvarchar(max) ,@userComments nvarchar(max))
returns nvarchar(max)
as begin
 
if @bottleLocations like '%[^ ]%'
	begin
		if @userComments like '%[^ ]%'
			return
				(@bottleLocations +'

['+@userComments +']')
		else
			return @bottleLocations 
	end
else	 
	begin
		if @userComments like '%[^ ]%'
			return
				('['+@userComments +']')
		else
			return null
	end
return null
 
end
