-- =============================================
-- Author:		Alex B.
-- Create date: 1/26/2014
-- Description:	Adds new TastingEvent-TasteNote linkage.
-- =============================================
CREATE PROCEDURE [dbo].[TastingEvent_TasteNote_Add]
	@TastingEventID int, @TasteNote int,
	@ShowRes smallint = 1

/*
exec TastingEvent_TasteNote_Add	@TastingEventID=2, @TasteNote=15
*/	

AS
set nocount on
set xact_abort on

declare @Result int = 0

------------ Checks
if not exists(select * from TastingEvent (nolock) where ID = @TastingEventID) begin
	raiserror('TastingEvent_TasteNote_Add:: Tasting Event record with ID=%i does not exist.', 16, 1, @TastingEventID)
	RETURN -1
end

if not exists(select * from TasteNote (nolock) where ID = @TasteNote) begin
	raiserror('TastingEvent_TasteNote_Add:: Taste Note record with ID=%i does not exist.', 16, 1, @TasteNote)
	RETURN -1
end
------------ Checks

BEGIN TRY
	BEGIN TRANSACTION

	declare @TE_IssueID int, @TN_IssueID int, @TN_StatusID int
	
	select @TE_IssueID = a.IssueID
	from Assignment_TastingEvent ate
		join Assignment a on ate.AssignmentID = a.ID
	where ate.TastingEventID = @TastingEventID
		
	select @TN_IssueID = tn.IssueID, @TN_StatusID = tn.WF_StatusID
	from TasteNote tn 
	where ID = @TasteNote

	--------------------------------------------------------------------------
	
	if @TN_StatusID < 100 begin
		-- TN can be part of only 1 tasting event and we can change IssueID
		delete TastingEvent_TasteNote where TasteNoteID = @TasteNote and TastingEventID != @TastingEventID
		
		update TasteNote set TastingEventID = @TastingEventID, IssueID = isnull(@TE_IssueID, IssueID)
		where ID = @TasteNote
	end else begin
		update TasteNote set TastingEventID = @TastingEventID
		where ID = @TasteNote and TastingEventID is NULL
	end
	
	if not exists(select * from TastingEvent_TasteNote (nolock) where TastingEventID = @TastingEventID and TasteNoteID = @TasteNote) begin
		insert into TastingEvent_TasteNote (TastingEventID, TasteNoteID, created)
		values (@TastingEventID, @TasteNote, getdate())
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


