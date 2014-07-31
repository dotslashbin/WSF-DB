/*
use erp
od tasting
*/
CREATE proc [dbo].[od](@table varchar(max), @fields varchar(max)=null, @where varchar(max) = '', @byFrequency bit = 0)
as begin
	declare @q nvarchar(max) = 'Select @fields, count(*) cnt from @table group by @fields '
	if @where like '%[^ ]%' set @q = replace(@q, '@table', '@table where ' + @where)
	if @fields is null or @fields not like '%[^ ]%'
		begin
			exec ('Select count(*) cnt from ' + @table)
			return
		end

	set @fields = replace(@fields, ',', ' ')
      set @fields = dbo.superTrim(@fields)
	set @fields = replace (@fields, ' ', ',')
	if @byFrequency = 0 
		set @q += ' order by @fields'
	else
		set @q += ' order by cnt desc'
	
	set @q = replace(@q, '@table', @table)
	set @q = replace(@q, '@fields', @fields)
	exec (@q)
end
 
 
 
