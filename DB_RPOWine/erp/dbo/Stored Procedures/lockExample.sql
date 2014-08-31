CREATE proc [dbo].lockExample(@whn int, @userWinesId int) as begin
declare @lock int
 
begin transaction
exec @lock = sp_getapplock @resource='lockVUserWines', @lockmode='Exclusive'
if @lock<0
	begin
			rollback transaction
			RAISERROR (N'myWines/AfterPick Lock Timeout',16,1)
	end
else
	begin
		begin try
			exec afterPickLocked @whN, @userWinesId
			exec sp_releaseAppLock @resource='lockVUserWines'
			commit transaction
		end try
		begin catch
			exec sp_releaseAppLock @resource='lockVUserWines'
			declare @s nvarchar(max)='MyWines/'+ERROR_Procedure()+': '+ERROR_MESSAGE()+' (line '+convert(nvarchar, ERROR_LINE())+')'
			rollback transaction
			RAISERROR (@s,16,1)
		end catch
	end 
end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
