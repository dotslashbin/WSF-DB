-- =============================================
-- Author:		Alex B.
-- Create date: 2/17/2014
-- Description:	Adds new Assignment.
-- =============================================
CREATE PROCEDURE [dbo].[Assignment_Add]
	--@ID int = NULL, 
	@IssueID int, @AuthorId int = NULL, 
	@Title nvarchar(255), 
	@Deadline date = NULL,
	@Notes nvarchar(max) = NULL,
	
	@WF_StatusID smallint = NULL,
	--@UserName varchar(50),
	@ShowRes smallint = 1
	
/*
declare @r int
exec @r = Assignment_Add @AuthorID=7, @IssueID=1,
	@Title = 'Test Assignment', @Deadline = '3/1/2014',
	@Notes = 'First in my list...',
	@WF_StatusID = NULL
select @r
*/

AS
set nocount on
set xact_abort on

declare @Result int

------------ Checks
-- cannot check - decision on 2/17/2014
--if @AuthorId is NULL or not exists(select * from Users (nolock) where UserId = @AuthorId) begin
--	raiserror('Assignment_Add:: @AuthorId is required.', 16, 1)
--	RETURN -2
--end

if not exists(select * from Issue (nolock) where ID = @IssueID) begin
	raiserror('Assignment_Add:: @IssueID is required.', 16, 1)
	RETURN -2
end

------------- Audit
--declare @CreatorID int
--if len(isnull(@UserName, '')) < 1 begin
--	raiserror('TastingEvent_Add:: @UserName is required.', 16, 1)
--	RETURN -1
--end
--exec @CreatorID = Audit_GetLookupID @ObjectName = 'entryuser', @ObjectValue = @UserName
------------ Checks

BEGIN TRY
	BEGIN TRANSACTION

	insert into Assignment (IssueID, AuthorId, Title, Deadline, Notes,
		created, updated, WF_StatusID)
	values (@IssueID, isnull(@AuthorId, 0), @Title, @Deadline, @Notes,
		getdate(), null, isnull(@WF_StatusID, 0))
	if @@error <> 0 begin
		select @Result = -1
		ROLLBACK TRAN
	end else begin
		select @Result = scope_identity()
	--	declare @msg nvarchar(1024) = dbo.fn_GetObjectDescription('Assignment', @Result)
	--	exec Audit_Add @Type='Success', @Category='Add', @Source='SQL', @UserName=@UserName, @MachineName='', 
	--		@ObjectType='Assignment', @ObjectID=@Result, @Description='Assignment added', @Message=@msg,
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

if @ShowRes = 1 ---> always return new ID in the ADD procedure
	select Result = isnull(@Result, -1)

RETURN isnull(@Result, -1)
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Assignment_Add] TO [RP_DataAdmin]
    AS [dbo];

