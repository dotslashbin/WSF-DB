CREATE function [dbo].[buildSQLContains](@keywords nvarchar(999))
returns nvarchar(2000)
as begin
	declare @contains nvarchar(2000)=null
	if charIndex(' ', @keywords)>0
		begin
			set @contains = replace(@keywords, '  ', ' ')
			while charIndex('  ', @contains)>0
				set @contains = replace(replace(@contains, '   ', ' '), '  ', ' ')
			set @contains= '"' + replace(@contains, ' ', '*" and "') + '*"'
		end
	else
		begin
			if len(@keywords)>0
				set @contains='"' + @keywords + '*"'
		end;
return @contains
end
 
