CREATE FUNCTION pageOrder (@s varchar(50))
RETURNS varchar(50)
AS
BEGIN
			declare @s2 nvarchar(50), @i int
			select @s2 = ''
			while len(@s) > 0 begin
				if 1 = patIndex('[0-9]%', @s) begin
					set @i = patindex('%[0-9][^0-9]%', @s); if @i = 0 set @i = len(@s) + 1
					set @s2 = @s2 + right('00000' + left(@s, @i), 5)
				end
				else if 1 = patIndex('[a-zA-Z]%', @s) begin
					set @i =  patindex('%[a-zA-Z][^a-zA-Z]%', @s); if @i = 0 set @i = len(@s) + 1
					set @s2 = @s2 + right('aaaaa' + left(@s, @i), 5)
				end
				else begin
					set @i =  patindex('%[^a-zA-Z0-9][a-zA-Z0-9]%', @s)
				end

				if @i = 0 break

				set @s = substring(@s, @i + 1, 100)
			end

			return @s2
 END
