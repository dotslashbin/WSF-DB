CREATE function [dbo].[pickFromVarietyList](@variety nvarchar(200))
/*
oofrr
use erpTiny
select * from pickFromLabelnameList('Ventisquero, Vina', 'Yali')
select * from pickFromLabelNameList('Mondavi, Robert', 'Cabernet Sauvignon Oakville Unfiltered')I
select * from winename where producer='Mondavi, Robert' and labelName= 'Cabernet Sauvignon Oakville Unfiltered'

*/
returns @T table(matchFound bit, variety nvarchar(200), colorClass nvarchar(20))
as begin
	select 
	   @variety=ltrim(rtrim(@variety)) 
	IF @variety='' SET @variety=null

	if @variety is null
		begin
				insert into @T(variety)
						select 1
		end
	else
			begin
				if  exists (select * from masterVariety where variety=@variety)
					insert into @T(matchFound, variety, colorClass)
						select top 1. 1, variety, colorClass from masterVariety  where variety=@variety
				else
					insert into @T(matchFound) select 0
			end
	return 
end
 
 
 
 
 
 
 
 
