CREATE proc [dbo].wineForVintageVinn (@existingWineN int, @activeVinn int=null, @wineNameN int, @vintage nvarchar(5), @newWineN int output) as begin
declare @lock int
 
begin transaction
	exec @lock = sp_getapplock @resource='addNewWine', @lockmode='Exclusive'
if @lock<0
	begin
			rollback transaction
			RAISERROR (N'myWines/wineForVintageVinn Lock Timeout',16,1)
	end
else
	begin
		begin try
			exec wineForVintageVinnLocked  @existingWineN, @activeVinn, @wineNameN, @vintage, @newWineN=@newWineN output
			exec sp_releaseAppLock @resource='addNewWine'
			commit transaction
		end try
		begin catch
			exec sp_releaseAppLock @resource='addNewWine'
			declare @s nvarchar(max)='MyWines/'+ERROR_Procedure()+': '+ERROR_MESSAGE()+' (line '+convert(nvarchar, ERROR_LINE())+')'
			rollback transaction
			RAISERROR (@s,16,1)
		end catch
	end 
end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
