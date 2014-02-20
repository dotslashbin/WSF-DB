-- =============================================
-- Author:		Alex B.
-- Create date: 2/17/2014
-- Description:	Deletes Assignment record and ALL associated with it records.
-- =============================================
CREATE PROCEDURE [dbo].[Assignment_Del]
	@ID int, 

	--@UserName varchar(50),
	@ShowRes smallint = 1

/*
declare @r int
exec @r = Assignment_Del @ID=2	--, @UserName = 'test'
select @r
*/

AS
set nocount on
set xact_abort on

declare @Result int

------------ Checks
if not exists(select * from Assignment (nolock) where ID = @ID) begin
	raiserror('Assignment_Del:: Assignment record with ID=%i does not exist.', 16, 1, @ID)
	RETURN -1
end

------------ Audit Log
--declare @EditorID int
--if len(isnull(@UserName, '')) < 1 begin
--	raiserror('TastingEvent_Del:: @UserName is required.', 16, 1)
--	RETURN -1
--end
----exec @EditorID = Audit_GetLookupID @ObjectName = 'entryuser', @ObjectValue = @UserName
------------ Checks

BEGIN TRY
	BEGIN TRANSACTION

	--declare @msg nvarchar(1024) = dbo.fn_GetObjectDescription('Assignment', @ID)
	
	delete Assignment_Article where AssignmentID = @ID
	delete Assignment_Resource where AssignmentID = @ID
	delete Assignment_TasteNote where AssignmentID = @ID
	delete Assignment_TastingEvent where AssignmentID = @ID
	delete Assignment where ID = @ID
	select @Result = @@ROWCOUNT
	if @@error <> 0 begin
		select @Result = -1
		ROLLBACK TRAN
	--end else begin
	--	exec Audit_Add @Type='Success', @Category='Delete', @Source='SQL', @UserName=@UserName, @MachineName='', 
	--		@ObjectType='Assignment', @ObjectID=@ID, @Description='Assignment deleted', @Message=@msg,
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
    ON OBJECT::[dbo].[Assignment_Del] TO [RP_DataAdmin]
    AS [dbo];

