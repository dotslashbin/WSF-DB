-- =============================================
-- Author:		Alex B.
-- Create date: 2/4/2014
-- Description:	Adds new Issue.
-- =============================================
CREATE PROCEDURE [dbo].[Issue_Add]
	--@ID int = NULL, 
	@PublicationID int,
	@ChiefEditorUserId int = NULL, 
	@Title nvarchar(255),
	@CreatedDate date, @PublicationDate date,
	@Notes nvarchar(max),
	--@UserName varchar(50),
	@ShowRes smallint = 1
	
/*
declare @r int
exec @r = Issue_Add @@ChiefEditorID=2, @Title = 'Test Issue # 1',
	@CreatedDate = '2/1/2013', @PublicationDate = '2/12/2013',
	@Notes = 'Just testing...'
select @r
*/

AS
set nocount on
set xact_abort on

declare @Result int, 
		@CreatorID int

------------ Checks
if not exists(select * from Publication (nolock) where ID = @PublicationID) begin
	raiserror('Issue_Add:: Publication record with ID=%i does not exist.', 16, 1, @PublicationID)
	RETURN -1
end

if @ChiefEditorUserId is NOT NULL and not exists(select * from Users (nolock) where UserId = @ChiefEditorUserId) begin
	raiserror('Issue_Add:: User record with ID=%i does not exist.', 16, 1, @ChiefEditorUserId)
	RETURN -1
end

------------- Audit
--if len(isnull(@UserName, '')) < 1 begin
--	raiserror('TasteNote_Add:: @UserName is required.', 16, 1)
--	RETURN -1
--end
--exec @CreatorID = Audit_GetLookupID @ObjectName = 'entryuser', @ObjectValue = @UserName
---------- Checks

BEGIN TRY
	BEGIN TRANSACTION

	insert into Issue (PublicationID, ChiefEditorUserId, Title, 
		CreatedDate, PublicationDate, Notes,
		created, updated)
	values (@PublicationID, @ChiefEditorUserId, @Title, 
		@CreatedDate, @PublicationDate, @Notes,
		getdate(), null)
	if @@error <> 0 begin
		select @Result = -1
		ROLLBACK TRAN
	end else begin
		select @Result = scope_identity()
		--declare @msg nvarchar(1024) = dbo.fn_GetObjectDescription('Issue', @Result)
		--exec Audit_Add @Type='Success', @Category='Add', @Source='SQL', @UserName=@UserName, @MachineName='', 
		--	@ObjectType='Issue', @ObjectID=@Result, @Description='Issue added', @Message=@msg,
		--	@ShowRes=0
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
    ON OBJECT::[dbo].[Issue_Add] TO [RP_DataAdmin]
    AS [dbo];

