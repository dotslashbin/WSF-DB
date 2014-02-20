-- =============================================
-- Author:		Alex B.
-- Create date: 2/18/2014
-- Description:	Adds a new Resource to the Assignment or updates deadline.
-- =============================================
CREATE PROCEDURE [dbo].[Assignment_Resource_AddUpdate]
	@AssignmentID int, @UserId int, 
	@UserRoleID int = NULL, @UserRoleName varchar(30) = NULL,
	@Deadline date = NULL,
	
	--@UserName varchar(50),
	@ShowRes smallint = 1

/*
exec Assignment_Recource_Add
*/	

AS
set nocount on
set xact_abort on

declare @Result int 

------------ Checks
select @Result = ID from Assignment (nolock) where ID = @AssignmentID
if @Result is NULL begin
	raiserror('Assignment_Resource_AddUpdate:: Assignment record with ID=%i does not exist.', 16, 1, @AssignmentID)
	RETURN -1
end

if @UserRoleID is NULL or not exists(select * from UserRoles (nolock) where ID = @UserRoleID)
	exec @UserRoleID = GetLookupID @ObjectName='userrole', @ObjectValue=@UserRoleName
------------ Checks

BEGIN TRY
	BEGIN TRANSACTION

	if exists(select * from Assignment_Resource where AssignmentID=@AssignmentID and UserId = @UserId) begin
		update Assignment_Resource set 
			UserRoleID = isnull(@UserRoleID, UserRoleID),
			Deadline = isnull(@Deadline, Deadline),
			updated = getdate()
		where AssignmentID=@AssignmentID and UserId = @UserId
		select @Result = @@ROWCOUNT
	end else begin
		if isnull(@UserRoleID, 0) < 1 begin
			raiserror('Assignment_Resource_AddUpdate:: User Role is required.', 16, 1)
			RETURN -1
		end
		insert into Assignment_Resource (AssignmentID, UserId, UserRoleID, Deadline, created)
		values (@AssignmentID, @UserId, @UserRoleID, @Deadline, getdate())
		select @Result = @@ROWCOUNT
	end
	
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	declare @errSeverity int,
			@errMsg nvarchar(2048)
	select	@errSeverity = ERROR_SEVERITY(),
			@errMsg = ERROR_MESSAGE()

    -- Test XACT_STATE:
        -- If 1, the transaction is committable.
        -- If -1, the transaction is uncommittable and should be rolled back.
        -- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
    if (xact_state() = 1 or xact_state() = -1)
		ROLLBACK TRAN

	raiserror(@errMsg, @errSeverity, 1)
END CATCH

if @ShowRes = 1 ---> always return new ID in the ADD procedure
	select Result = isnull(@Result, -1)

RETURN isnull(@Result, -1)
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Assignment_Resource_AddUpdate] TO [RP_DataAdmin]
    AS [dbo];

