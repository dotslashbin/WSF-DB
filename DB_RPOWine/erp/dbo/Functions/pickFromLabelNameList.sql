CREATE function [dbo].[pickFromLabelNameList](@producer nvarchar(200), @labelName nvarchar(200))
/*
use erpTiny
select * from getLabelNameList(' ','Sine Qua Non')
select * from getLabelNameList('cab','Sine Qua Non')
select * from getLabelNameList('black blue','')
select * from pickFromLabelnameList('','Syrah Imposter Mccoy')
 
select top 1 1, producer, labelName, variety, colorClass from wineName where labelName='black and blue'
select distinct labelname from winename where producer='sine qua non'
select distinct producer from winename where labelname='black and blue'
 
select * from pickFromLabelnameList('Ventisquero, Vina', 'Yali')
select * from pickFromLabelnameList('Ventisquero, Vina', 'Yali')
select * from pickFromLabelNameList('Mondavi, Robert', 'Cabernet Sauvignon Oakville Unfiltered')I
select * from winename where producer='Mondavi, Robert' and labelName= 'Cabernet Sauvignon Oakville Unfiltered'
 
*/
returns @T table(matchFound bit, producer nvarchar(200), labelName nvarchar(200), variety nvarchar(200), colorClass nvarchar(20))
as begin
	select 
	   @producer=ltrim(rtrim(@producer)) 
	 , @labelName=ltrim(rtrim(@labelName)) 
	IF @producer='' SET @producer=null
	IF @labelName='' SET @labelName=null
 
	if @producer is null
		begin
			if @labelName is not null
				if (select count(distinct producer) from wineName where labelName=@labelName)=1
					insert into @T(matchFound, producer, labelName, variety, colorClass)
						select top 1 1, producer, labelName, variety, colorClass from wineName where labelName=@labelName
							order by isNull(len(variety),999), case colorClass when 'red' then 1 when 'white' then 2 else 3 end
		end
	else
		begin
			if @labelName is null
				begin
					if not exists (select * from winename where producer=@producer and labelName like '%[0-z]%')
						insert into @T(matchFound, producer, labelName, variety, colorClass)
							select top 1 1, producer, labelName, variety, colorClass from wineName where producer=@producer
								order by isNull(len(variety),999), case colorClass when 'red' then 1 when 'white' then 2 else 3 end
				end
			else
				begin
					insert into @T(matchFound, producer, labelName, variety, colorClass)
						select top 1 1, producer, labelName, variety, colorClass from wineName where producer=@producer and labelName=@labelName
							order by isNull(len(variety),999), case colorClass when 'red' then 1 when 'white' then 2 else 3 end
				end
 
				--look for one vinn
		end
	
	if not exists(select * from @T)
		insert into @T(matchFound, producer, labelName)
			select 0, @producer, @labelName
	return 
end
 
 
 
 
 
 
 
 
 
 
