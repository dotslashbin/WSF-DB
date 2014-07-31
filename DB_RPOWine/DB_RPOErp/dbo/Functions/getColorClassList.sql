--use erpTiny
CREATE function [dbo].[getColorClassList](@keywords varchar(200))
/*
select * from getColorClassList('n p')
*/
returns @T table(ColorClass varChar(200))
as begin
	select 
		  @keywords=ltrim(rtrim(@keywords))
	declare @contains nvarchar(900)=null
	
	set @contains=dbo.buildSQLContains(@keywords)
 
	if @contains is null
		begin
			insert into @T(ColorClass)
				select distinct(ColorClass)
					from masterColorClass
					where 
						len(ColorClass)>0
					order by ColorClass
		end
	else
		insert into @T(ColorClass)
			select distinct(ColorClass)
				from masterColorClass
				where 
					len(ColorClass)>0
					and contains(ColorClass, @contains)
				order by ColorClass
	return 
end
 
 
 
 
 
 
 
