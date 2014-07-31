--use erp
CREATE proc [dbo].[myWinesBackgroundTasks] as begin
set noCount on
 
if exists(select * from actions where timeOfOldestRequest is not null)
	begin
		if exists(select * from actions where actionName='updateMasterTableLocProducer' and timeOfOldestRequest is not null)
			begin
				update actions set timeOfOldestRequest=null where actionName='updateMasterTableLocProducer'
				exec dbo.updateMasterTableLocProducer null
			end

		if exists(select * from actions where actionName='updateSpeed' and timeOfOldestRequest is not null)
			begin
				update actions set timeOfOldestRequest=null where actionName='updateSpeed'
				exec dbo.updateSpeed
			end

	end
 
end
