CREATE function [dbo].[getLabelNameList](@keywords varchar(200), @producer nvarchar(200))
/*
select * from masterProducer where producer not like '%,%' order by len(producer)
select producer, count(distinct labelName) cnt from wineName group by producer order by cnt desc
	Jadot, Louis
	Laurent, Dominique
	Bouchard Pere & Fils
	Duboeuf, Georges
	Girardin, Vincent
	Verget
	Potel, Maison Nicolas
	Latour, Domaine Louis
	Drouhin, Domaine Joseph
	Rosenblum Cellars
	Zind Humbrecht, Domaine
	Kendall Jackson
	Sine Qua Non
select * from getLabelNameList_dev('v *', 'Kendall Jackson')
select * from getLabelNameList_dev('v ', 'Kendall Jackson')
select * from getLabelNameList('re m', 'Kendall Jackson')
select * from getLabelNameList('re m XXYX', '')
*/
returns @T table (LabelName varChar(200),idN int identity(1,1))
as begin
	--if @keywords like '%  ' or @keywords like '% *' set @keywords ='*'
	select 
		   @keywords=ltrim(rtrim(@keywords))
		 , @producer=ltrim(rtrim(@producer)) 
	IF @producer='' SET @producer=null
	
	declare @contains nvarchar(900)=null
	--if @keywords <> '*'
	set @contains=dbo.buildSQLContains(@keywords)
 
	if @contains is null
		begin
			--insert into @T(labelname) select 'Contains is null'
			insert into @T(LabelName)
				select top 100 LabelName
					from wineName
					where 
						(@producer IS NULL OR producer=@producer)
						and len(LabelName)>0
					group by LabelName
					order by LabelName
		end
	else
		begin
			--insert into @T(labelname) select 'Contains='+@contains
			insert into @T(LabelName)
				select top 100 LabelName
					from wineName
					where 
						(@producer IS NULL OR producer=@producer)
						and len(LabelName)>0
						and contains(LabelName, @contains)
					group by LabelName
					order by LabelName
		end
		 
/*	if not exists(select * from @t)
		begin
			--insert into @t(labelname) select 'foo'
			if @producer is null
				insert into @t(labelname) select '(no matches)'
			else
				insert into @t(labelname) select '(no matches for '+@producer+')'
		end     */
 
	declare @cnt int
	select @cnt= count(*) from @T
	if @cnt = 0
		begin
			if @producer is null
				insert into @t(labelname) select '(no matches)'
			else
				insert into @t(labelname) select '(no matches for '+@producer+')'
		end
	else if @cnt>15
		begin
			delete from @T where idN>(15-1)
			insert into @T(labelName) select '...'
		end
 
/*
select * from getLabelNameList('re m XXYX', '')
*/
 
RETURN
end
 
 
 
 
 
 
 
 
 
 
