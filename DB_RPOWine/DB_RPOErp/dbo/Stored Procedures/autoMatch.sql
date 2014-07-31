CREATE proc [dbo].[autoMatch] ( @whN int)
as begin
--if @whN<>20 return

set @whN=abs(@whN)
begin try
	exec dbo.autoMatchTry @whN
end try
begin catch
		declare @s nvarchar(max)='MyWines/'+ERROR_Procedure()+': '+ERROR_MESSAGE()+' (line '+convert(nvarchar, ERROR_LINE())+')'
		RAISERROR (@s,16,1)
end catch 
 
end 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
