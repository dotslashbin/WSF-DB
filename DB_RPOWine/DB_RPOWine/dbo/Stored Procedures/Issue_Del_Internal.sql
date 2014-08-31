
-- =============================================
-- Author:		Alex B.
-- Create date: 8/29/2014
-- Description:	Deletes Issue and all associated with it records.
--				Sergey S on 8/29/2014: "Just delete all children. Do no worry about case when notes could belong to other issues"
-- =============================================
CREATE PROCEDURE [dbo].[Issue_Del_Internal]
	@ID int, 

	@IsDeleteAssignments bit = 1, @IsDeleteArticles bit = 1, @IsDeleteTastingNotes bit = 1,
	@ShowRes smallint = 1

/*
declare @r int
exec @r = Issue_Del @ID=254319
select @r
*/

AS
set nocount on
set xact_abort on

declare @Result int

------------ Checks
if not exists(select * from Issue (nolock) where ID = @ID) begin
	raiserror('Issue_Del_Internal:: Issue record with ID=%i does not exist.', 16, 1, @ID)
	RETURN -1
end

create table #tn (ID int)	-- taste notes
create table #a (ID int)	-- articles

BEGIN TRY
	
	BEGIN TRANSACTION

	---------- collect "to be deleted" IDs
	insert into #tn (ID)
	select distinct TasteNoteID from Issue_TasteNote where IssueID = @ID 
	
	insert into #tn (ID)
	select distinct TasteNoteID 
	from Issue_TasteNote itn
		left join #tn on itn.TasteNoteID = #tn.ID
	where #tn.ID is NULL and TasteNoteID in (select ID from TasteNote where IssueID = @ID)
	
	; with r as (
		select tetn.TastingEventID, tetn.TasteNoteID
		from Assignment a
			join Assignment_TastingEvent ate on a.ID = ate.AssignmentID
			join TastingEvent_TasteNote tetn on ate.TastingEventID = tetn.TastingEventID
		where a.IssueID = @ID
	)
	insert into #tn (ID)
	select distinct TasteNoteID 
	from r
		left join #tn on r.TasteNoteID = #tn.ID
	where #tn.ID is NULL

	insert into #tn (ID)
	select distinct TasteNoteID 
	from Assignment_TasteNote atn
		left join #tn on atn.TasteNoteID = #tn.ID
	where #tn.ID is NULL and atn.AssignmentID in (select distinct ID from Assignment where IssueID = @ID )

	insert into #tn (ID)
	select distinct TasteNoteID 
	from Article_TasteNote atn
		left join #tn on atn.TasteNoteID = #tn.ID
	where #tn.ID is NULL and atn.ArticleID in (select distinct ArticleID from Issue_Article where IssueID = @ID )

	insert into #a (ID)
	select distinct ArticleID from Issue_Article where IssueID = @ID 
	
	---------- delete
	delete Issue_TasteNote where IssueID = @ID
	delete Issue_TasteNote where TasteNoteID in (select ID from #tn)
	delete TastingEvent_TasteNote where TasteNoteID in (select ID from #tn)
	delete Article_TasteNote where TasteNoteID in (select ID from #tn)
	delete Issue_Article where ArticleID in (select ID from #a)
	delete Assignment_TasteNote where TasteNoteID in (select ID from #tn)
	
	if @IsDeleteAssignments = 1 begin
		delete Assignment_Article where AssignmentID in (select ID from Assignment where IssueID = @ID)
		delete Assignment_Resource where AssignmentID in (select ID from Assignment where IssueID = @ID)
		delete Assignment_ResourceD where AssignmentID in (select ID from Assignment where IssueID = @ID)
		delete Assignment_TasteNote where AssignmentID in (select ID from Assignment where IssueID = @ID)
		delete TastingEvent where ID in 
			(select TastingEventID from Assignment_TastingEvent where AssignmentID in 
				(select ID from Assignment where IssueID = @ID))
		delete Assignment_TastingEvent where AssignmentID in (select ID from Assignment where IssueID = @ID)
		delete Assignment where IssueID = @ID
	end

	if @IsDeleteArticles = 1 begin
		delete Article where ID in (select ID from #a)
	end

	if @IsDeleteTastingNotes = 1 begin
		delete TasteNote where ID in (select ID from #tn)
	end

	delete Issue where ID = @ID
	select @Result = @@ROWCOUNT
	if @@error <> 0 begin
		select @Result = -1
		ROLLBACK TRAN
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

drop table #tn
drop table #a

if @ShowRes = 1
	select Result = isnull(@Result, -1)

RETURN isnull(@Result, -1)