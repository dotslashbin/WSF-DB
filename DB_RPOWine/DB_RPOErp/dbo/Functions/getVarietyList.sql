CREATE function [dbo].[getVarietyList](@keywords varchar(200), @producer nvarchar(200), @labelName nvarchar(200))
/*
use erpTiny
select * from [getVarietyList](' ', 'Monchhof (Robert Eymael)','')
select * from [getVarietyList]('cab', 'Kendall Jackson','')
select * from [getVarietyList]('s  ', 'Kendall Jackson','Chardonnay Camelot Bench')
select * from [getVarietyList]('', 'Kendall Jackson','Chardonnay Camelot Bench')
select * from getLabelNameList('', 'Kendall Jackson')
select distinct labelname from winename where producer='Kendall Jackson'
select * from getLabelNameList('year', 'Mondavi, Robert')
select * from getLabelNameList('r', 'Monchhof (Robert Eymael)')
select * from getLabelNameList('r', 'xxxxxxxxxxxxxxxxxx')
select * from getLabelNameList('  ', 'Sine Qua Non')
 
use erpTiny
 
select distinct(producer) from winename where labelname='Cabernet Sauvignon Oakville Unfiltered'
select * from wineName where producer='Mondavi, Robert' and labelname='Cabernet Sauvignon Oakville Unfiltered'
select * from getVarietyList('c', 'Mondavi, Robert', 'Cabernet Sauvignon Oakville Unfiltered')
select * from getVarietyList('c', 'Mondavi, Robert', 'Cabernet Sauvignon Oakville Unfilteredx')
*/
returns @T table (idN int identity(1,1), variety nvarchar(200))
as begin
	--if @keywords like '%  ' or @keywords like '% *' set @keywords ='*'
	--declare @showAll bit=0;if @keywords like '%  ' set @showAll =1
	declare @showAll bit=1
	select 
		   @keywords=ltrim(rtrim(@keywords))
		 , @producer=ltrim(rtrim(@producer)) 
		 , @labelName=ltrim(rtrim(@labelName)) 
	IF @producer='' SET @producer=null
	IF @labelName='' SET @labelName=null
 
	declare @contains nvarchar(900)=null
	--if @keywords <> '*'
	set @contains=dbo.buildSQLContains(@keywords)
 
	declare @showVarietyForThisLabel bit=0
	/* 1009Sep21
	if @producer is not null
		begin
			if @labelName is null
				begin
					if not exists (select * from wineName where producer=@producer and labelName like '%[0-z]%')
						set @showVarietyForThisLabel=1
				end
			else
				begin
					if  exists (select * from wineName where producer=@producer and labelName = @labelName)
						set @showVarietyForThisLabel=1
				end
			
		end
	*/
	
	if-0=@showVarietyForThisLabel
		begin
			if @contains is null
				begin
					insert into @T(variety)
						select top 15 variety
							from dbo.masterVariety
							where len(variety)>0
							group by variety
							order by variety
				end
			else
				begin
					insert into @T(variety)
						select top 15 variety
							from dbo.masterVariety
							where len(variety)>0
								and contains(variety, @contains)
							group by variety
							order by variety
				end
		end
	else
		begin
			if @showAll = 1 insert into @T(variety) select '--- Varieties for this name---'
			if @contains is null
				begin
					insert into @T(variety)
						select top 15 variety
							from wineName
							where 
								producer=@producer
								and (@labelName is null or labelName =@labelName)
								and len(variety)>0
							group by variety
							order by variety
				end
			else
				begin
					insert into @T(variety)
						select top 15 variety
							from wineName
							where 
								producer=@producer
								and (@labelName is null or labelName =@labelName)
								and len(variety)>0
								--and contains(variety, @contains)
							group by variety
							order by variety
				end
			if (select count(*) from @T)<15 and @showAll=1
				begin 
					if (select count(*) from @T)<2
						begin
							update @T set variety='--- No variety set for this name ---' where idN=1
						end
					else
						insert into @T(variety) select '--- Other Varieties ---'
					if @contains is null
						insert into @T(variety) 
							select top 15 variety 
								from dbo.masterVariety
								where 
									len(Variety)>0
							except
								select variety from @T
					else
						insert into @T(variety) 
							select top 15 variety 
								from dbo.masterVariety
								where 
									len(Variety)>0
									and contains(Variety, @contains)
							except
								select variety from @T
				end
		end
	
 
	declare @cnt int
	select @cnt= count(*) from @T
	if @cnt = 0
		insert into @T(variety) select '(no matches)'			
	else if @cnt>15
		begin
			delete from @T where idN>(15-1)
			insert into @T(variety) select '...'
		end
		
return 
/*
	declare @max int=23
	if (select count(*) from winename)>@max print 'foo'
o
(from Kendall Jackson)
(No matches for Kendall Jackson)
	Cabernet Sauvignon
(from full list)
 
*/
 
RETURN
end
 
 
 
 
 
 
 
 
 
 
 
 
