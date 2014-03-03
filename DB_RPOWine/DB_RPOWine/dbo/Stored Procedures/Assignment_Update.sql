-- =============================================
-- Author:		Alex B.
-- Create date: 2/17/2014
-- Description:	Updates Assignment record.
-- =============================================
CREATE PROCEDURE [dbo].[Assignment_Update]
	@ID int, 
	@IssueID int = NULL, @AuthorId int = NULL, 
	@Title nvarchar(255) = NULL, 
	@Deadline date = NULL,
	@Notes nvarchar(max) = NULL,
	
	@WF_StatusID smallint = NULL,
	--@UserName varchar(50),
	@ShowRes smallint = 1
	
/*
declare @r int
exec @r = Assignment_Update
	@ID = 3, @Title = 'Test Assignment with Update',
	@WF_StatusID = 100
select @r
*/	

AS
set nocount on
set xact_abort on

declare @Result int

------------ Checks
if @IssueID is NOT NULL and not exists(select * from Issue (nolock) where ID = @IssueID) begin
	raiserror('Assignment_Add:: @IssueID is required.', 16, 1)
	RETURN -2
end

-- cannot check - decision on 2/17/2014
--if @AuthorId is NOT NULL and not exists(select * from Users (nolock) where UserId = @AuthorId) begin
--	raiserror('Assignment_Add:: @AuthorId is required.', 16, 1)
--	RETURN -2
--end

------------- Audit
--declare @EditorID int
--if len(isnull(@UserName, '')) < 1 begin
--	raiserror('Assignment_Update:: @UserName is required.', 16, 1)
--	RETURN -1
--end
--exec @EditorID = Audit_GetLookupID @ObjectName = 'entryuser', @ObjectValue = @UserName
------------ Checks

BEGIN TRY
	BEGIN TRANSACTION

	update Assignment set 
		IssueID = isnull(@IssueID, IssueID),
		AuthorId = isnull(@AuthorId, AuthorId), 
		Title = isnull(@Title, Title), 
		Deadline = isnull(@Deadline, Deadline), 
		Notes = isnull(@Notes, Notes),

		updated = getdate(), 
		WF_StatusID = isnull(@WF_StatusID, WF_StatusID)
		--EditorID = @EditorID
	where ID = @ID

	select @Result = @@ROWCOUNT
	if @@error <> 0 begin
		select @Result = -1
		ROLLBACK TRAN
	--end else begin
	--	declare @msg nvarchar(1024) = dbo.fn_GetObjectDescription('Assignment', @ID)
	--	exec Audit_Add @Type='Success', @Category='Update', @Source='SQL', @UserName=@UserName, @MachineName='', 
	--		@ObjectType='Assignment', @ObjectID=@ID, @Description='Assignment updated', @Message=@msg,
	--		@ShowRes=0
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

if @ShowRes = 1
	select Result = isnull(@Result, -1)

RETURN isnull(@Result, -1)
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Assignment_Update] TO [RP_DataAdmin]
    AS [dbo];

