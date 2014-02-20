
-- =============================================
-- Author:		Alex B.
-- Create date: 2/18/2014
-- Description:	Adds a new Resource to the Assignment or updates deadline.
-- =============================================
CREATE PROCEDURE [dbo].[Assignment_Resource_AddUpdateTVP]
	@AssignmentID int, 
	@tvpResourceList as dbo.AssignmentResource readonly,
	@ShowRes smallint = 1

/*
set nocount on
declare @t as dbo.AssignmentResource
insert into @t (UserId, UserRoleID, UserRoleName, Deadline) 
values (2, null, 'Reviewer', '2/26/2014'), (3, null, 'Reviewer', '2/28/2014')
exec Assignment_Resource_AddUpdateTVP @AssignmentID=2, @tvpResourceList = @t
*/	

AS
set nocount on
set xact_abort on

declare @Result int 

------------ Checks
select @Result = ID from Assignment (nolock) where ID = @AssignmentID
if @Result is NULL begin
	raiserror('Assignment_Resource_AddUpdateTVP:: Assignment record with ID=%i does not exist.', 16, 1, @AssignmentID)
	RETURN -1
end

if exists(select * from @tvpResourceList where UserRoleID is NULL and UserRoleName is NULL) begin
	raiserror('Assignment_Resource_AddUpdateTVP:: User Roles are required for all records.', 16, 1)
	RETURN -1
end

------------ Checks

BEGIN TRY
	BEGIN TRANSACTION

	-- 1. Registering new user roles
	insert into UserRoles (Name)
	select distinct n.UserRoleName
	from @tvpResourceList n
		left join UserRoles ur on lower(n.UserRoleName) = lower(ur.Name)
	where isnull(n.UserRoleID, 0) < 1 and ur.ID is NULL

	-- 2. merging 
	merge Assignment_Resource as t
	using (
		select UserId = rl.UserId,
			UserRoleID = ur.ID,
			Deadline = rl.Deadline
		from @tvpResourceList rl
			left join UserRoles ur on rl.UserRoleID = ur.ID or lower(rl.UserRoleName) = lower(ur.Name)
	) as s 
		on t.UserId = s.UserId and t.AssignmentID = @AssignmentID
	when matched then
		UPDATE set 
			UserRoleID = isnull(s.UserRoleID, t.UserRoleID),
			Deadline = isnull(s.Deadline, t.Deadline),
			updated = getdate()
	when not matched by target 
		and s.UserRoleID is NOT NULL then
		INSERT (AssignmentID, UserId, UserRoleID, Deadline, created)
		values (@AssignmentID, s.UserId, s.UserRoleID, s.Deadline, getdate());
	select @Result = @@rowcount
	
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
    ON OBJECT::[dbo].[Assignment_Resource_AddUpdateTVP] TO [RP_DataAdmin]
    AS [dbo];

