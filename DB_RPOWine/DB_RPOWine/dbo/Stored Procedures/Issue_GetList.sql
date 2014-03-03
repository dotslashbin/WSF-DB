
-- =============================================
-- Author:		Alex B.
-- Create date: 2/4/2014
-- Description:	Gets List of Issues.
--				Input parameters are used as a filter.
-- =============================================
CREATE PROCEDURE [dbo].[Issue_GetList]
	@ID int = NULL, 
	@PublicationID int = NULL,
	@ChiefEditorUserId int = NULL,
	@Title nvarchar(255) = NULL,
	@CreatedDate date = NULL, @PublicationDate date = NULL,
	@ShowRes smallint = 1
	
/*
exec Issue_GetList @PublicationID = 1
*/
	
AS
set nocount on

----------------- Checks 
select @Title = nullif(@Title, '')
if @Title is NOT NULL
	select @Title = '%' + ltrim(rtrim(@Title)) + '%'
	
if @PublicationID is NOT NULL and not exists(select * from Publication (nolock) where ID = @PublicationID) begin
	raiserror('Issue_GetList:: Publication record with ID=%i does not exist.', 16, 1, @PublicationID)
	RETURN -1
end

if @ChiefEditorUserId is NOT NULL and not exists(select * from Users (nolock) where UserId = @ChiefEditorUserId) begin
	raiserror('Issue_GetList:: User record with ID=%i does not exist.', 16, 1, @ChiefEditorUserId)
	RETURN -1
end
----------------- Checks 

; with 
st_a as (
	select IssueID = i.IssueID,
		Cnt = count(*),
		Cnt_Published = sum(case when a.WF_StatusID > 99 then 1 else 0 end)
	from Issue_Article i (nolock)
		join Article a (nolock) on i.ArticleID = a.ID
	group by i.IssueID
),
st_tn as (
	select IssueID = i.IssueID,
		Cnt = count(*),
		Cnt_Published = sum(case when tn.WF_StatusID > 99 then 1 else 0 end)
	from Issue_TasteNote i (nolock)
		join TasteNote tn (nolock) on i.TasteNoteID = tn.ID
	group by i.IssueID
),

-- commented by sergiy, not sure if I did proper changes
--st_te as (
--	select IssueID = i.IssueID,
--		Cnt = count(*),
--		Cnt_Published = sum(case when te.WF_StatusID > 99 then 1 else 0 end)
--	from Issue_TastingEvent i (nolock)
--		join TastingEvent te (nolock) on i.TastingEventID = te.ID
--	group by i.IssueID
--)

st_te as (
	select AssignmentID = i.AssignmentID,
		Cnt = count(*),
		Cnt_Published = sum(case when te.WF_StatusID > 99 then 1 else 0 end)
	from Assignment_TastingEvent i (nolock)
		join TastingEvent te (nolock) on i.TastingEventID = te.ID
	group by i.AssignmentID
)






select 
	ID = i.ID,
	PublicationID = i.PublicationID,
	PublicationName = p.Name,
	ChiefEditorUserId = i.ChiefEditorUserId,
	ChiefEditorName = isnull(u.FullName, ''),
	Title = i.Title,
	CreatedDate = i.CreatedDate,
	PublicationDate = i.PublicationDate,
	Notes = i.Notes, 

	created = i.created, 
	updated = i.updated,
	
	Cnt_Articles = isnull(st_a.Cnt, 0),
	Cnt_ArticlesPublished = isnull(st_a.Cnt_Published, 0),
	Cnt_TasteNotes = isnull(st_tn.Cnt, 0),
	Cnt_TasteNotesPublished = isnull(st_tn.Cnt_Published, 0),
	Cnt_TastingEvents = isnull(st_te.Cnt, 0),
	Cnt_TastingEventsPublished = isnull(st_te.Cnt_Published, 0)	
from Issue i (nolock)
	join Publication p (nolock) on i.PublicationID = p.ID
	left join st_a on i.ID = st_a.IssueID
	left join st_tn on i.ID = st_tn.IssueID
	left join st_te on i.ID = st_te.AssignmentID
	left join Users u (nolock) on i.ChiefEditorUserId = u.UserId
where i.ID = isnull(@ID, i.ID)
	and (@PublicationID is NULL or i.PublicationID = @PublicationID)
	and (@ChiefEditorUserId is NULL or i.ChiefEditorUserId = @ChiefEditorUserId)
	and (@CreatedDate is NULL or i.CreatedDate = @CreatedDate)
	and (@PublicationDate is NULL or i.PublicationDate = @PublicationDate)
	and (@Title is NULL or i.Title like @Title)
order by i.PublicationDate desc, i.ID
	
RETURN 1
GO



GO


