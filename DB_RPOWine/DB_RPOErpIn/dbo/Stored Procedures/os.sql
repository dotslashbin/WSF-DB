----------------------------------------------------------
--showmulti     showstuff     showvalues     showSamples     [=] 
CREATE proc [dbo].[os] (@tableName nvarChar(max), @where nvarChar(max) = '', @minValueCount int = null)
as begin
set @where = 'N ' + @where
exec dbo.oss @tableName, @where, @minValueCount
end
 
 
 
 
 
 
