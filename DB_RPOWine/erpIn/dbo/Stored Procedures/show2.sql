
-------------------------------------------------------------------------------------------------------
--show2
-------------------------------------------------------------------------------------------------------
--showmulti     showstuff     showvalues     showSamples     [=] 
CREATE proc [dbo].[show2] (@tableName nvarChar(max), @where nvarChar(max) = '', @minValueCount int = 2)
as begin
exec dbo.show @tableName, @where, @minValueCount
end
 
