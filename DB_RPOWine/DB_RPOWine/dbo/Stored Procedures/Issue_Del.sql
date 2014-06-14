

-- =============================================
-- Author:		Alex B.
-- Create date: 2/4/2014
-- Description:	Deletes Issue and all associated with it records.
-- =============================================
CREATE PROCEDURE [dbo].[Issue_Del]
	@ID int, 

	--@UserName varchar(50),
	@ShowRes smallint = 1

/*
declare @r int
exec @r = Issue_Del @ID=254319	--, @UserName = 'test'
select @r
*/

AS
set nocount on
set xact_abort on

declare @Result int

------------ Checks
if not exists(select * from Issue (nolock) where ID = @ID) begin
	raiserror('Issue_Del:: Issue record with ID=%i does not exist.', 16, 1, @ID)
	RETURN -1
end

------------ Audit Log
--if len(isnull(@UserName, '')) < 1 begin
--	raiserror('Issue_Del:: @UserName is required.', 16, 1)
--	RETURN -1
--end
----exec @EditorID = Audit_GetLookupID @ObjectName = 'entryuser', @ObjectValue = @UserName
------------ Checks

BEGIN TRY
	BEGIN TRANSACTION

	--declare @msg nvarchar(1024) = dbo.fn_GetObjectDescription('Issue', @ID)
	
	delete Issue_Article where IssueID = @ID
	delete Issue_TasteNote where IssueID = @ID
	--delete Issue_TastingEvent where IssueID = @ID
	delete Issue where ID = @ID
	select @Result = @@ROWCOUNT
	if @@error <> 0 begin
		select @Result = -1
		ROLLBACK TRAN
	--end else begin
	--	exec Audit_Add @Type='Success', @Category='Delete', @Source='SQL', @UserName=@UserName, @MachineName='', 
	--		@ObjectType='Issue', @ObjectID=@ID, @Description='Issue deleted', @Message=@msg,
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


