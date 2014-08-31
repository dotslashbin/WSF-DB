
CREATE function [dbo].getNumLeft(@text nvarChar(999))
returns int
as begin
declare @r int=null
if @text like '[0-9]%'
	return CONVERT(INT, LEFT(@text,PATINDEX('%[^0-9]%',@text+' ')-1))
return @r
end
