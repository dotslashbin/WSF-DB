CREATE proc [dbo].updateMasterTableLocProducer (@wineNameN nvarchar(2000))
as begin
 
declare @lock int
begin transaction
exec @lock = sp_getapplock @resource='updateMasterTableLocProducer', @lockmode='Exclusive'
if @lock<0
	begin
			rollback transaction
			RAISERROR (N'myWines/updateMasterTableLocProducer Lock Timeout',16,1)
	end
else
	begin
		begin try
			exec updateMasterTableLocProducerLocked @wineNameN 
			exec sp_releaseAppLock @resource='updateMasterTableLocProducer'
			commit transaction
		end try
		begin catch
			exec sp_releaseAppLock @resource='updateMasterTableLocProducer'
			declare @s nvarchar(max)='MyWines/'+ERROR_Procedure()+': '+ERROR_MESSAGE()+' (line '+convert(nvarchar, ERROR_LINE())+')'
			rollback transaction
			RAISERROR (@s,16,1)
			end catch
	end 
 
 
 
end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
