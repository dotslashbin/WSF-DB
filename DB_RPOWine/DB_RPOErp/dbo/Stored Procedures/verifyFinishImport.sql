CREATE proc [dbo].verifyFinishImport(@whN int, @finish bit) as
begin
--declare @whN int=-20, @finish bit=0
--if @whN=20 return
set @whN=abs(@whN)
begin try
	exec dbo.verifyFinishImportTry @whN, @finish
end try
begin catch
	begin try
		update wh set importStatus = 1 where whN = @whN
		update transfer..importStatus set status = 1 where whN = @whN
	end try begin catch end catch
			declare @s nvarchar(max)='MyWines/'+ERROR_Procedure()+': '+ERROR_MESSAGE()+' (line '+convert(nvarchar, ERROR_LINE())+')'
			RAISERROR (@s,16,1)
end catch 
 
end 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
