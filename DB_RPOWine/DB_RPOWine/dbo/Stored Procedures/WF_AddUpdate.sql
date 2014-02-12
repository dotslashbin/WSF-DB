-- =============================================
-- Author:		Alex B.
-- Create date: 2/04/2014
-- Description:	Adds or updates a "work flow" record.
-- =============================================
CREATE PROCEDURE [dbo].[WF_AddUpdate]
	@ObjectTypeID int = NULL, @ObjectTypeName varchar(50) = NULL,
	@ObjectID int, @StatusID smallint, 
	@AssignedByID int, @AssignedByLogin varchar(100) = NULL, @AssignedByName varchar(100) = NULL,
	@AssignedToID int, @AssignedToLogin varchar(100) = NULL, @AssignedToName varchar(100) = NULL,
	@Note varchar(max) = NULL
	
AS
set nocount on

select	@AssignedByLogin = upper(rtrim(@AssignedByLogin)),
		@AssignedToLogin = upper(rtrim(@AssignedToLogin))

if isnull(@ObjectTypeID, 0) < 1 and @ObjectTypeName is NOT NULL
	exec @ObjectTypeID = WF_GetLookupID @ObjectName = 'objecttype', @ObjectValue  = @ObjectTypeName
if isnull(@ObjectTypeID, 0) < 1 begin
	raiserror('ObjectTypeID cannot be found.', 16, 1)
	RETURN -1
end	

if @StatusID is NULL or not exists(select * from WF_Statuses (nolock) where ID = @StatusID) begin
	raiserror('@StatusID cannot be found.', 16, 1)
	RETURN -1
end	

if isnull(@AssignedByID, 0) < 1 begin
	select @AssignedByID = UserId from Users (nolock) where UserName = lower(rtrim(@AssignedByLogin))
	if isnull(@AssignedByID, 0) < 1 begin
		raiserror('@AssignedByID cannot be found.', 16, 1)
		RETURN -10
	end
end

if isnull(@AssignedToID, 0) < 1 begin
	select @AssignedToID = UserId from Users (nolock) where UserName = lower(rtrim(@AssignedToLogin))
	if isnull(@AssignedToID, 0) < 1 begin
		raiserror('@AssignedToID cannot be found.', 16, 1)
		RETURN -10
	end
end
--------------------- checks -------------------

; merge WF as t
using (select ObjectTypeID = @ObjectTypeID, ObjectID = @ObjectID) as s
	on t.ObjectTypeID = s.ObjectTypeID and t.ObjectID = s.ObjectID
when matched then
	update set
		StatusID = @StatusID,
		AssignedByID = @AssignedByID,
		AssignedToID = @AssignedToID,
		AssignedDate = getdate(),
		Note = @Note
when not matched then
	insert (ObjectTypeID, ObjectID, StatusID, AssignedByID, AssignedToID, AssignedDate, Note)
	values (s.ObjectTypeID, s.ObjectID, @StatusID, @AssignedByID, @AssignedToID, getdate(), @Note);

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[WF_AddUpdate] TO [RP_DataAdmin]
    AS [dbo];

