-- =============================================
-- Author:		Alex B.
-- Create date: 2/22/2014
-- Description:	Adds a new ResourceD to the Assignment or updates deadline.
-- =============================================
CREATE PROCEDURE [dbo].[Assignment_ResourceD_AddUpdate]
	@AssignmentID int, 
	@TypeID int, @Deadline date,
	@ShowRes smallint = 1

/*
exec Assignment_ResourceD_AddUpdate
*/	

AS
set nocount on
set xact_abort on

declare @Result int 

------------ Checks
select @Result = ID from Assignment (nolock) where ID = @AssignmentID
if @Result is NULL begin
	raiserror('Assignment_ResourceD_AddUpdate:: Assignment record with ID=%i does not exist.', 16, 1, @AssignmentID)
	RETURN -1
end
------------ Checks

BEGIN TRY
	BEGIN TRANSACTION

	if exists(select * from Assignment_ResourceD where AssignmentID = @AssignmentID and TypeID = @TypeID) begin
		update Assignment_ResourceD set 
			Deadline = isnull(@Deadline, Deadline),
			updated = getdate()
		where AssignmentID = @AssignmentID and TypeID = @TypeID
		select @Result = @@ROWCOUNT
	end else begin
		insert into Assignment_ResourceD (AssignmentID, TypeID, Deadline, created)
		values (@AssignmentID, @TypeID, @Deadline, getdate())
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
    ON OBJECT::[dbo].[Assignment_ResourceD_AddUpdate] TO [RP_DataAdmin]
    AS [dbo];

