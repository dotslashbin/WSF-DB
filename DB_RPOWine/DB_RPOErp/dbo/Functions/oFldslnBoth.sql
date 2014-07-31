CREATE function [dbo].[oFldslnBoth] (@a varchar(max), @b varchar(max))
returns nvarchar(max)
as begin
	declare @c nvarchar(max);
	with
	a as ( select column_name from
				(
					select column_name from information_schema.columns where table_name = @a
					intersect
					select column_name from information_schema.columns where table_name = @b
				) b
			)
	select @c= replace(dbo.concatFF(column_name), char(12), ',') from a
	return @c
end
 
 
