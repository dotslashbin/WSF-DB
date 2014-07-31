/*
verifyImport_after1003Mar26 20
verifyImport 20
*/
CREATE proc verifyImport(@whN int) as
--alter proc verifyImport_after1003Mar26(@whN int) as
begin
set noCount on
exec dbo.verifyFinishImport @whN, 0
end 


