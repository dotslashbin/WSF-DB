-- =============================================
-- Author:		Sergey S., Alex B.
-- Create date: 7/27/2014
-- Description:	Unpublishes Issue and all related items.
-- =============================================
CREATE PROCEDURE [dbo].[Issue_Unpublish]
	@ID int, @IsFullReload bit = 1,
	@ShowRes smallint = 1

/*
declare @r int
exec @r = Issue_Unpublish @ID=2
select @r
*/	

AS
set nocount on
set xact_abort on

declare @Result int

------------ Checks
if not exists(select * from Issue (nolock) where ID = @ID) begin
	raiserror('Issue_Unpublish:: Issue with ID=%i does not exist.', 16, 1, @ID)
	RETURN -1
end

if exists(select * from Issue (nolock) where ID = @ID and WF_StatusID < 100) begin
	raiserror('Issue_Unpublish:: Issue with ID=%i is not yet published.', 16, 1, @ID)
	RETURN -1
end

------------ Checks
declare @pubID int
select @pubID = PublicationID from Issue (nolock) where ID = @ID

BEGIN TRY
	BEGIN TRANSACTION

	-- =========== Entities ===========
	print '-- Update Issue --'
	update Issue set WF_StatusID = 0
	where ID = @ID and WF_StatusID = 100;
	select @Result = @@rowcount

	print '-- Update Assignment --'
	update Assignment set WF_StatusID = 0
	where IssueID = @ID and WF_StatusID = 100;

	print '-- Update Articles --'
	update art set art.WF_StatusID = 60
	from Assignment as a 
		join Assignment_Article as ate on ate.AssignmentID = a.ID
		join Article as art on art.ID = ate.ArticleID
	where a.IssueID = @ID and art.WF_StatusID = 100;

	print '-- Update TasteNotes --'
	update tn set tn.WF_StatusID = 60
	from Assignment as a 
		join Assignment_TastingEvent as ate on ate.AssignmentID = a.ID
		join TastingEvent_TasteNote as tet on tet.TastingEventID = ate.TastingEventID
		join TasteNote as tn on tn.ID = tet.TasteNoteID
	where a.IssueID = @ID and tn.WF_StatusID = 100;

	-- =========== Links ===========
	print '-- Update Publication_TasteNote --'
	delete Publication_TasteNote where PublicationID = @pubID and TasteNoteID in (
		select itn.TasteNoteID
		from Issue_TasteNote itn
			left join (
				select itn.TasteNoteID 
				from Issue_TasteNote itn
					join Issue i on itn.IssueID = i.ID
				where i.PublicationID = @pubID and i.ID != @ID
			) f on itn.TasteNoteID = f.TasteNoteID
		where itn.IssueID = @ID and f.TasteNoteID is NULL
	)

	print '-- Update Article_TasteNote --'
	delete Article_TasteNote 
	from Article_TasteNote atn
		join Issue_Article ia on atn.ArticleID = ia.ArticleID
	where ia.IssueID = @ID

	print '-- Update Issue_Article --'
	delete Issue_Article where IssueID = @ID
	
	print '-- Update Issue_TasteNote --'
	delete Issue_TasteNote where IssueID = @ID

	COMMIT TRANSACTION
	
	-- finally need refresh wine table
	exec srv.Wine_UpdateIsActiveWineN
	exec srv.Wine_Reload @IsFullReload = @IsFullReload
	
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
    ON OBJECT::[dbo].[Issue_Unpublish] TO [RP_DataAdmin]
    AS [dbo];

