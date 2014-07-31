CREATE FUNCTION [getContainsArg] 
(
	@s varchar(max)
)
RETURNS varChar(max)
AS
BEGIN
	declare @r varChar(max), @i int
	set @s = ltrim(rtrim(@s))
	set @r = '"'

	while len(@s) > 0 begin
				set @i = patIndex('% %', @s)
				
				if @i > 0 begin
					set @r = @r + left(@s, @i - 1) + '%" and "'
					set @s = ltrim(right(@s, len(@s) - @i))
				end
				else begin
					set @r = @r + @s + '%"'
					set @s = ''
				end
	end
	RETURN @r
END
