CREATE function [dbo].[getVintageList](@keywords varchar(200))
/*
set statistics time on
select * from getVintageList('n')
*/
returns @R table(vintage varChar(4))
as begin
	declare @T table(vintage varChar(4))
	declare @y int
	
	select @keywords=ltrim(rtrim(@keywords))
			, @y=year(getDate())

	insert into @T(vintage) select 'NV'
	while @y>1500
		begin
			insert into @T(vintage) 
				select convert(char(4), @y);
			select @y-=1
		end
	if @keywords is null or @keywords=''
		insert into @R(vintage) select top 100 * from @T
	else
		insert into @R(vintage) select top 100 * from @T where vintage like (@keywords+'%')

	return 
end
 
 
 
 
 
 
 
 
