﻿CREATE proc [dbo].[autoOtherVintages](@whN int, @myWineName nvarchar(999), @wineN int=null) as begin
declare @lock int, @rid varchar(99)='lockVUserWines'
 
if @myWineName is null or @myWineName not like '%[0-z]%' return
 
begin transaction
exec @lock = sp_getapplock @resource=@rid, @lockmode='Exclusive'
if @lock<0
	begin
			rollback transaction
			RAISERROR (N'myWines/autoOtherVintages Lock Timeout',16,1)
	end
else
	begin
		begin try
			exec dbo.alterViewUserWines @whN
			exec autoOtherVintagesLocked @whN, @myWineName, @wineN
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
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
