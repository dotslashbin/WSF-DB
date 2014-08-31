

CREATE proc [dbo].[alterViewUserWines_3Aug2012] (@whN int)
as begin 
--declare @whN int=20 
declare @myImportTable nvarchar(100)='transfer..userWines'+convert(nvarchar,@whN)
--exec dbo.addUserWinesFields @myImportTable , 'drop view vUserWines'
 
-----------------------------------------------------------------------------------
-- Check for table
---------------------------------------------------------------------------------- 
if OBJECT_ID(@myImportTable) is null
	begin
		RAISERROR (N'myWines/AlterViewUserWines: %s does not exist', 16, 1, @myImportTable)
	end
 
 
-----------------------------------------------------------------------------------
-- Update Views
---------------------------------------------------------------------------------- 
begin try
	if isNull(OBJECT_DEFINITION (OBJECT_ID('dbo.vUserWines')),'') not like '%'+@myImportTable
		exec ('alter view vUserWines as select * from '+@myImportTable)
end try begin catch
		begin try drop view vUserWines end try begin catch end catch
	begin try												     
		declare @sql nvarchar(max)='create view vUserWines as select * from '+@myImportTable
		exec (@sql)
	end try begin catch end catch
end catch;
 
end
 
 
 
 








