CREATE proc [dbo].[oodeff] @nm varChar(200) as begin

SET NOCOUNT ON;
declare @s varchar(max), @loopCount int, @base int, @next int
select @s = definition from sys.default_constraints where [name] = @nm
if @s is null
	set @s = OBJECT_DEFINITION (OBJECT_ID('dbo.' + @nm))
    
select @loopCount = 1000, @base = 1
while @loopCount > 0 begin
	set @next = charindex(char(13), @s, @base)
	if @next > 0 begin
		print substring(@s, @base, @next - @base)
		set @base = @next + 2
		end
	else begin
		print substring(@s, @base, 9999);
		break;
		end

	set @loopCount = @loopCount - 1
	end
END
