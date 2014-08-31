
create proc [dbo].[requestBackgroundAction](@actionName nvarchar(50) )
as begin
 
declare @date dateTime=getDate()
 
if not exists(select * from actions where actionName=@actionName)
	begin
		insert into actions(actionName, timeOfOldestRequest) select @actionName, @date end
else
	begin
		update actions set timeOfOldestRequest=@date
			 where actionName=@actionName and timeOfOldestRequest is null
	end	
end
 
 
 
 
/*
create proc [dbo].[exampleMerge]
as begin
 
merge bottleSizeAlias as a
	using erp..bottleSize b
		on a.alias=b.name
when matched and a.bottleSizeN <> b.bottleSizeN or b.bottleSizeN is null then
	update set bottleSizeN=b.bottleSizeN
when not matched by target then
	insert(alias, bottleSizeN)
		values(b.name, b.bottleSizeN);
 */
 

