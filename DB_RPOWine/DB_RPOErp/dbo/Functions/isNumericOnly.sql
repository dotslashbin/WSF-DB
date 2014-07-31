
CREATE function isNumericOnly(@x nvarchar(99))
returns bit
as begin
if @x not like '%[^.0-9]%' and 1=isNumeric(@x)
	return 1
 
return 0
end







