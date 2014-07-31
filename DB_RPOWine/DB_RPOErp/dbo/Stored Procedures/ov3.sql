
CREATE proc [dbo].ov3 (@tableName nvarChar(max),  @fields nvarchar(max) = '', @where nvarChar(max) = '', @outTable nvarchar(max) = '', @maxRows int = 100, @minValueCount int = 3)
as begin
--select @where = 'N ' + @where, @fields  = 'N ' + @fields, @outTable  = 'N ' + @outTable
exec dbo.ovv @tableName, @fields, @where, @outTable, @maxRows, @minValueCount
end
 
 
 
 
 
 
 

