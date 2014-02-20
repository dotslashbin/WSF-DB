-- =============================================
-- Author:		Alex B.
-- Create date: 2/18/2014
-- Description:	Adds new TasteNote to Assignment.
-- =============================================
CREATE PROCEDURE [dbo].[Assignment_TasteNote_Add]
	@AssignmentID int, @TasteNoteID int,
	@ShowRes smallint = 1

/*
exec Assignment_TasteNote @AssignmentID=2, @TasteNoteID=15
*/	

AS
set nocount on
set xact_abort on

declare @Result int

------------ Checks
if not exists(select * from Assignment (nolock) where ID = @AssignmentID) begin
	raiserror('Assignment_TasteNote_Add:: Assignment record with ID=%i does not exist.', 16, 1, @AssignmentID)
	RETURN -1
end

if not exists(select * from TasteNote (nolock) where ID = @TasteNoteID) begin
	raiserror('Assignment_TasteNote_Add:: TasteNote record with ID=%i does not exist.', 16, 1, @TasteNoteID)
	RETURN -1
end

if exists(select * from Assignment_TasteNote (nolock) where AssignmentID = @AssignmentID and TasteNoteID = @TasteNoteID) begin
	-- do nothing - linkage already exists
	if @ShowRes = 1
		select Result = 1
	RETURN 1
end

BEGIN TRY
	BEGIN TRANSACTION

	insert into Assignment_TasteNote (AssignmentID, TasteNoteID,
		created)
	values (@AssignmentID, @TasteNoteID,
		getdate())
	if @@error <> 0 begin
		select @Result = -1
		ROLLBACK TRAN
	end else begin
		select @Result = 1
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
    ON OBJECT::[dbo].[Assignment_TasteNote_Add] TO [RP_DataAdmin]
    AS [dbo];

