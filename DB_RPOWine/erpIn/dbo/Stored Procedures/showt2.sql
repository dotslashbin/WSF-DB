
-------------------------------------------------------------------------------------------------------
--showt2
-------------------------------------------------------------------------------------------------------
--showmulti     showstuff     showvalues     showSamples     [=] 
CREATE proc [dbo].[showt2] (@tableName nvarChar(max), @where nvarChar(max) = '', @minValueCount int = 1)
as begin
set @where = 'T ' + @where
exec dbo.show @tableName, @where, 2
end
 
 
 
 

