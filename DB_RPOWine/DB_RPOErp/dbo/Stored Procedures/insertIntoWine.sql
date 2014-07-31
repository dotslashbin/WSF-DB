CREATE proc [dbo].insertIntoWine (@newWineN int, @activeVinn int, @wineNameN int , @vintage nvarchar(5))
as begin
declare @lock int, @rid nvarchar(99)='addNewWine_insertIntoWine'
begin transaction
exec @lock = sp_getapplock @resource=@rid, @lockmode='Exclusive'
if @lock<0
	begin
			rollback transaction
			RAISERROR (N'myWines/insertIntoWine Lock Timeout',16,1)
	end
else
	begin
		begin try
			exec insertIntoWineLocked @newWineN, @activeVinn, @wineNameN, @vintage 
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
            
 
 
 
 
 
 
 
	
 
