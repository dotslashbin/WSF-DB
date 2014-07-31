

CREATE proc [dbo].[alterViewUserWines] (@whN int)
as begin 
--declare @whN int=20 
declare @myImportTable1 nvarchar(100)='transfer..userWines'+convert(nvarchar,@whN)
declare @myImportTable2 nvarchar(100)='transfer.dbo.userWines'+convert(nvarchar,@whN)
declare @myImportTable3 nvarchar(100)='transfer.db_owner.userWines'+convert(nvarchar,@whN)
--exec dbo.addUserWinesFields @myImportTable , 'drop view vUserWines'
 
-----------------------------------------------------------------------------------
-- Check for table
---------------------------------------------------------------------------------- 
if OBJECT_ID(@myImportTable1) is null and OBJECT_ID(@myImportTable2) is null and OBJECT_ID(@myImportTable3) is null
	begin
		RAISERROR (N'myWines/AlterViewUserWines: %s does not exist', 16, 1, @myImportTable1)
	end
 
 
-----------------------------------------------------------------------------------
-- Update Views
---------------------------------------------------------------------------------- 
begin try
	if isNull(OBJECT_DEFINITION (OBJECT_ID('dbo.vUserWines')),'') not like '%'+@myImportTable1
		exec ('alter view vUserWines as select * from '+@myImportTable1)
end try begin catch
		begin try drop view vUserWines end try begin catch end catch
	begin try												     
		declare @sql nvarchar(max)='create view vUserWines as select * from '+@myImportTable1
		exec (@sql)
	end try begin catch end catch
end catch;

 
end
 
 
 
 








