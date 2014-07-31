
CREATE function superTrim(@s nvarchar(max))
returns nvarchar(max)
as begin
	declare @s2 nvarchar(max) = ltrim(rtrim(@s))
	while 0 < charIndex('  ', @s2)
		set @s2 = replace(@s2, '  ', ' ')
	return	 @s2
end
 
