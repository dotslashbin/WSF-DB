CREATE function [dbo].[normalizeName](@rawName nvarchar(max)) 
returns  nvarchar(max)
as begin
declare @s nvarchar(max)
select @s= ltrim(rtrim(@rawName));

--replace tab with space
select @s = replace(@s, '	', ' ')

--replace CR with space
select @s = replace(@s, '
', ' ')

select @s = replace(@s, '     ', ' ')
select @s = replace(@s, '   ', ' ')
select @s = replace(@s, '  ', ' ')
 
return (@s);
end
 
