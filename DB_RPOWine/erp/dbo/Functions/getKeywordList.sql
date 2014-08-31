CREATE function [dbo].[getKeywordList](@keywords varchar(200))
returns @T table(word varChar(200))
as begin
	declare @contains nvarchar(900)
	if @keywords like '%  ' or @keywords like '% *'
		begin
			set @contains=dbo.buildSQLContains(ltrim(rtrim(left(@keywords, len(@keywords)-2))))
			insert into @T(word)
				select top 20 word
					from wordkey 
					where contains(keywords, @contains)
					group by word 
					order by word
		end		
	else
		begin
			select @keywords=ltrim(rtrim(@keywords))
			declare @i int = charIndex(' ',reverse(@keywords))
			if @i <= 0
				begin
						insert into @T(word)
							select top 20 word 
								from wordkey 
								where word like (@keywords+'%') 
								group by word 
								order by word
				end
			else
				begin
					set @i=len(@keywords)-@i
					select @contains=left(@keywords, @i)
					set @contains=dbo.buildSQLContains(@contains)
					--insert into @T(word) select 'Contains: '+@contains
					declare @like nvarchar(200)=subString(@keywords, @i+2, 999)+'%'
					--insert into @T(word) select 'like: |' + @like+ '|'
					
					insert into @T(word)
						select top 20 word
							from wordkey 
							where contains(keywords, @contains) and word like @like
							group by word 
							order by word
				end		
		end
return 
end
 
/*
use erpTiny
set statistics time off
set statistics time on
select * from dbo.getKeywordList('mond r pino  ')
select * from getKeywordList('pin wo  ')
select * from getKeywordList('cab mon *')
select * from getKeywordList('end road  ')
select * from wordKey where word like 'end%'
Lemelson Vineyards Pinot Noir Meyer Vineyard Dry Red Table Pinot Noir USA Oregon Willamette Valley 
delete from wordKey where word like 'end of file%'
 
 */
 
 
