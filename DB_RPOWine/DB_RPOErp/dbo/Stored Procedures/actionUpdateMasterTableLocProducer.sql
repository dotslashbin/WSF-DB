CREATE proc [dbo].[actionUpdateMasterTableLocProducer] as begin
set noCount on
 
if exists(select * from actions where actionN=2 and timeOfOldestRequest is not null)
	begin
		update actions set timeOfOldestRequest=null where actionN=2
		exec dbo.updateMasterTableLocProducer
	end
 
end
 
