CREATE proc finishImport(@whN int) as
begin
set noCount on
exec dbo.verifyFinishImport @whN, 1
end 
 
 
 
