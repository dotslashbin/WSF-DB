CREATE FUNCTION normalizeForLike(@s varChar(200))
RETURNS varChar(200)
AS
BEGIN
if @s like '[_]%[_]'  or @s like ' % '
	set @s = Ltrim(RTrim(@s))
else if @s like '[_]%' or @s like ' %'
	set @s = Ltrim(@s)	+ '%'
else if @s like '%[_]' or @s like '% '
	set @s = '%' + Rtrim(@s)
else
	set @s = '%' + (@s) + '%'
if @s like '%[_]%' begin
	set @s = replace(@s, '[_]', '[%%]')
	set @s = replace(@s, '_', '')
	set @s = replace(@s, '[%%]', '[_]')
end

	RETURN @s
END
