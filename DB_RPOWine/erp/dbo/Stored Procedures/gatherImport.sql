CREATE proc [dbo].gatherImport(@whn int) as begin
declare @lock int, @rid varchar(99)='lockVUserWines'
 
begin transaction
exec @lock = sp_getapplock @resource=@rid, @lockmode='Exclusive'
if @lock<0
	begin
			rollback transaction
			RAISERROR (N'MyWines gatherImport Lock Timeout',16,1)
	end
else
	begin
		begin try
			exec dbo.alterViewUserWines @whN
			exec dbo.gatherImportLocked @whN
			exec sp_releaseAppLock @resource=@rid
			commit transaction
		end try
		begin catch
			exec sp_releaseAppLock @resource=@rid
			declare @s nvarchar(max)='MyWines/'+ERROR_Procedure()+': '+ERROR_MESSAGE()+' (line '+convert(nvarchar, ERROR_LINE())+')'
			rollback transaction
			RAISERROR (@s,16,1)
		end catch
	end 
end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
