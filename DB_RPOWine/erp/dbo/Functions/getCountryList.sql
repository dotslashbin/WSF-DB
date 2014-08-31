CREATE function [dbo].[getCountryList](@keywords varchar(200))
/*
use erpTiny
select * from getCountryList('')
*/
returns @T table(country varChar(200))
as begin
	select 
		  @keywords=ltrim(rtrim(@keywords))
	declare @contains nvarchar(900)=null
	
	set @contains=dbo.buildSQLContains(@keywords)
 
	if @contains is null
		begin
			insert into @T(country)
				select top 100     country
					from masterLoc
					where 
						len(country)>0
					group by country
					order by country
		end
	else
		insert into @T(country)
			select top 100     country
				from masterLoc
				where 
					len(country)>0
					and contains(country, @contains)
				group by country
				order by country
	return 
end
 
 
 
 
 
 
 
