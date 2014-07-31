create function [dbo].[getDef](@name varchar(200), @db varchar(50))
returns varchar(max)
as begin
return (convert(varchar,'ab'))
end
/*
declare @s varchar(max), @loopCount int, @base int, @next int
select @s = definition from sys.default_constraints where [name] = @nm
if @s is null
	set @s = OBJECT_DEFINITION (OBJECT_ID('dbo.' + @nm))
*/

