


CREATE proc actionUpdateSpeed as begin
set noCount on
 
if exists(select * from actions where actionN=1 and timeOfOldestRequest is not null)
	begin
		update actions set timeOfOldestRequest=null where actionN=1;
		exec dbo.updateSpeed
	end
end

