
-- =============================================
-- Author:		Sergey S., Alex B.
-- Create date: 7/27/2014
-- Description:	Publishes Issue and all related items.


-- Sergey. Update. do not throw error if issue has been published already

-- =============================================
CREATE PROCEDURE [dbo].[Issue_Publish]
	@ID int, @IsFullReload bit = 1,
	@ShowRes smallint = 1

/*
declare @r int
exec @r = Issue_Publish @ID=2
select @r
*/	

AS
set nocount on
set xact_abort on

declare @Result int

------------ Checks
if not exists(select * from Issue (nolock) where ID = @ID) begin
	raiserror('Issue_Publish:: Issue with ID=%i does not exist.', 16, 1, @ID)
	RETURN -1
end

--if exists(select * from Issue (nolock) where ID = @ID and WF_StatusID >= 100) begin
--	raiserror('Issue_Publish:: Issue with ID=%i has already been published.', 16, 1, @ID)
--	RETURN -1
--end

------------ Checks

BEGIN TRY

	BEGIN TRANSACTION

	-- =========== Entities ===========
	print '-- Update Issue --'
	update Issue set WF_StatusID = 100
	where ID = @ID and WF_StatusID < 100;
	select @Result = @@rowcount

	print '-- Update Assignment --'
	update Assignment set WF_StatusID = 100
	where IssueID = @ID and WF_StatusID < 100;

	print '-- Update Articles --'
	update art set art.WF_StatusID = 100
	from Assignment as a 
		join Assignment_Article as ate on ate.AssignmentID = a.ID
		join Article as art on art.ID = ate.ArticleID
	where a.IssueID = @ID and art.WF_StatusID < 100;

	--print '-- Update Wine_N --'
	--; with r as (
	--	select distinct tn.Wine_N_ID
	--	from Assignment as a 
	--		join Assignment_TastingEvent as ate on ate.AssignmentID = a.ID
	--		join TastingEvent_TasteNote as tet on tet.TastingEventID = ate.TastingEventID
	--		join TasteNote as tn on tn.ID = tet.TasteNoteID
	--	where a.IssueID = @ID and tn.WF_StatusID = 60
	--)
	--update Wine_N set WF_StatusID = 100
	--from Wine_N wn
	--	join r on wn.ID = r.Wine_N_ID
	--where wn.WF_StatusID < 100;

	--print '-- Update Wine_VinN --'
	--update Wine_VinN set WF_StatusID = 100
	--from Wine_VinN vn
	--	join Wine_N wn on vn.ID = wn.Wine_VinN_ID
	--where vn.WF_StatusID < 100 and wn.WF_StatusID > 99

	print '-- Update TasteNotes --'
	update tn set tn.WF_StatusID = 100
	from Assignment as a 
		join Assignment_TastingEvent as ate on ate.AssignmentID = a.ID
		join TastingEvent_TasteNote as tet on tet.TastingEventID = ate.TastingEventID
		join TasteNote as tn on tn.ID = tet.TasteNoteID
	where a.IssueID = @ID and tn.WF_StatusID = 60;

	-- =========== Links ===========
	print '-- Update Issue_Article --'
	insert into Issue_Article (IssueID, ArticleID)
	select distinct a.IssueID, aa.ArticleID
	from Assignment a
		join Assignment_Article aa on a.ID = aa.AssignmentID
		left join Issue_Article ia on ia.IssueID = a.IssueID and ia.ArticleID = aa.ArticleID
	where a.IssueID = @ID and ia.ArticleID is NULL
	
	print '-- Update Issue_TasteNote --'
	insert into Issue_TasteNote (IssueID, TasteNoteID)
	select distinct a.IssueID, tn.ID
	from Assignment a
		join Assignment_TastingEvent as ate on ate.AssignmentID = a.ID
		join TastingEvent_TasteNote as tet on tet.TastingEventID = ate.TastingEventID
		join TasteNote as tn on tn.ID = tet.TasteNoteID and tn.WF_StatusID >= 100
		left join Issue_TasteNote itn on itn.IssueID = a.IssueID and itn.TasteNoteID = tn.ID
	where a.IssueID = @ID and itn.TasteNoteID is NULL

	print '-- Update Publication_TasteNote --'
	insert into Publication_TasteNote (PublicationID, TasteNoteID)
	select distinct i.PublicationID, tn.ID
	from Issue i
		join Assignment a on a.IssueID = i.ID
		join Assignment_TastingEvent as ate on ate.AssignmentID = a.ID
		join TastingEvent_TasteNote as tet on tet.TastingEventID = ate.TastingEventID
		join TasteNote as tn on tn.ID = tet.TasteNoteID and tn.WF_StatusID >= 100
		left join Publication_TasteNote ptn on ptn.PublicationID = i.PublicationID and ptn.TasteNoteID = tn.ID
	where i.ID = @ID and ptn.TasteNoteID is NULL

	print '-- Update Article_TasteNote --'
	insert into Article_TasteNote (ArticleID, TasteNoteID)
	select distinct aa.ArticleID, tn.ID
	from Assignment a
		join Assignment_Article aa on a.ID = aa.AssignmentID
		join Assignment_TastingEvent as ate on ate.AssignmentID = a.ID
		join TastingEvent_TasteNote as tet on tet.TastingEventID = ate.TastingEventID
		join TasteNote as tn on tn.ID = tet.TasteNoteID and tn.WF_StatusID >= 100
		left join Article_TasteNote atn on atn.ArticleID = aa.ArticleID and atn.TasteNoteID = tn.ID
	where a.IssueID = @ID and atn.TasteNoteID is NULL


	COMMIT TRANSACTION
	
	-- finally need refresh wine table
	exec srv.UpdateArticles
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
    ON OBJECT::[dbo].[Issue_Publish] TO [RP_DataAdmin]
    AS [dbo];

