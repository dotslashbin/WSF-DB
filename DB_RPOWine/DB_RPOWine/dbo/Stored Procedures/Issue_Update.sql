
-- =============================================
-- Author:		Alex B.
-- Create date: 2/4/2014
-- Description:	Updates Issue record.
-- =============================================
CREATE PROCEDURE [dbo].[Issue_Update]
	@ID int, 
	@PublicationID int = NULL,
	@ChiefEditorUserId int = NULL,
	@Title nvarchar(255) = NULL,
	@CreatedDate date = NULL, @PublicationDate date = NULL,
	@Notes nvarchar(max) = NULL,
	--@UserName varchar(50),
	@ShowRes smallint = 1
		
/*
declare @r int
exec @r = Issue_Update @ChiefEditorID=2, @Title = 'Test Issue # 1',
	@CreatedDate = '2/1/2013', @PublicationDate = '2/12/2013',
	@Notes = 'Just testing...'
select @r
*/	

AS
set nocount on
set xact_abort on

declare @Result int, 
		@EditorID int

------------ Checks
if @PublicationID is NOT NULL and not exists(select * from Publication (nolock) where ID = @PublicationID) begin
	raiserror('Issue_Update:: Publication record with ID=%i does not exist.', 16, 1, @PublicationID)
	RETURN -1
end

if @ChiefEditorUserId is NOT NULL and not exists(select * from Users (nolock) where UserId = @ChiefEditorUserId) begin
	raiserror('Issue_Update:: User record with ID=%i does not exist.', 16, 1, @ChiefEditorUserId)
	RETURN -1
end
------------- Audit
--if len(isnull(@UserName, '')) < 1 begin
--	raiserror('Issue_Update:: @UserName is required.', 16, 1)
--	RETURN -1
--end
--exec @EditorID = Audit_GetLookupID @ObjectName = 'entryuser', @ObjectValue = @UserName
------------ Checks

BEGIN TRY
	--BEGIN TRANSACTION
	
	-- Update of PublicationID is very rare, but creates some sort of locks in the view Wine (compatibility view)
	-- Therefore, as a temporary solution, we are trying to avoid updating PublicationID, when possible
	
	if @PublicationID is NULL or exists(select * from Issue (nolock) where ID = @ID and PublicationID = @PublicationID) begin
		update Issue set 
			--PublicationID = isnull(@PublicationID, PublicationID), 
			ChiefEditorUserId = isnull(@ChiefEditorUserId, ChiefEditorUserId), 
			Title = isnull(@Title, Title), 
			CreatedDate = isnull(@CreatedDate, CreatedDate), 
			PublicationDate = isnull(@PublicationDate, PublicationDate), 
			Notes = isnull(@Notes, Notes),
			updated = getdate()
			--EditorID = @EditorID
		where ID = @ID
	end else begin
		update Issue set 
			PublicationID = isnull(@PublicationID, PublicationID), 
			ChiefEditorUserId = isnull(@ChiefEditorUserId, ChiefEditorUserId), 
			Title = isnull(@Title, Title), 
			CreatedDate = isnull(@CreatedDate, CreatedDate), 
			PublicationDate = isnull(@PublicationDate, PublicationDate), 
			Notes = isnull(@Notes, Notes),
			updated = getdate()
			--EditorID = @EditorID
		where ID = @ID
	end	

	select @Result = @@ROWCOUNT
	if @@error <> 0 begin
		select @Result = -1
		--ROLLBACK TRAN
	--end else begin
	--	declare @msg nvarchar(1024) = dbo.fn_GetObjectDescription('Issue', @ID)
	--	exec Audit_Add @Type='Success', @Category='Update', @Source='SQL', @UserName=@UserName, @MachineName='', 
	--		@ObjectType='Issue', @ObjectID=@ID, @Description='Issue updated', @Message=@msg,
	--		@ShowRes=0
	end

	--COMMIT TRANSACTION
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
    ON OBJECT::[dbo].[Issue_Update] TO [RP_DataAdmin]
    AS [dbo];

