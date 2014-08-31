--use erpTiny
CREATE function [dbo].[getVarietyListFromMaster](@keywords varchar(200))
/*
select * from getVarietyList('n p')
select * from getVarietyList('')
*/
returns @T table(Variety varChar(200))
as begin
	select 
		  @keywords=ltrim(rtrim(@keywords))
	declare @contains nvarchar(900)=null
	
	set @contains=dbo.buildSQLContains(@keywords)
 
	if @contains is null
		begin
			insert into @T(Variety)
				select top 100 variety
					from masterVariety
					where 
						len(Variety)>0
					group by variety
					order by Variety
		end
	else
		insert into @T(Variety)
			select top 100 variety
				from masterVariety
				where 
					len(Variety)>0
					and contains(Variety, @contains)
				group by variety
				order by Variety
	return 
end
 
 
 
 
 
 
 
 
