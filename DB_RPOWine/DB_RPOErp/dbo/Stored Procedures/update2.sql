CREATE proc dbo.update2
as begin
set nocount on;
 
exec dbo.ooLog '=' 
/*
update2getData1
update2getData2
*/
 
exec dbo.ooLog 'Processing update2Init'
exec dbo.update2Init
 
exec dbo.ooLog 'Processing update2Wh'
exec dbo.update2Wh
 
--exec dbo.ooLog 'Processing update2errors'
--exec dbo.update2errors
 
exec dbo.ooLog 'Processing update2wineNames'
exec dbo.update2wineNames
 
exec dbo.ooLog 'Processing update2winesChanged'
exec dbo.update2winesChanged
 
exec dbo.ooLog 'Processing update2winesNew erp'
exec dbo.update2winesNew 'erp'
 
exec dbo.ooLog 'Processing update2winesNew julian'
exec dbo.update2winesNew 'julian'
 
exec dbo.ooLog 'Processing update2namer'
exec dbo.update2namer
 
exec dbo.ooLog 'Processing update2tastingStep1'
exec dbo.update2tastingStep1
 
exec dbo.ooLog 'Processing update2tastingStep2'
exec dbo.update2tastingStep2
 
exec dbo.ooLog 'Processing update2price'
exec dbo.update2price
 
exec dbo.ooLog 'Processing updateWinenameInfo'
exec dbo.updateWinenameInfo
--exec dbo.update2verify
--remap non-clash users
exec dbo.ooLog 'Update2 Done'
end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
