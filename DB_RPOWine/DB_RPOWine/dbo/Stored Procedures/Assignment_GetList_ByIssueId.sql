



CREATE PROCEDURE [dbo].[Assignment_GetList_ByIssueId]
	@IssueID int = NULL
		
	
AS


set nocount on



	select 
		ID = a.ID,
		Title = a.Title,
		Deadline = a.Deadline,
		Notes = a.Notes,
		created = a.created, 
		updated = a.updated,
		
		WF_StatusID = isnull(wfs.ID, -1),
		WF_StatusName = isnull(wfs.Name, ''),
		
		IssueID = a.IssueID,
		IssueTitle = i.Title,
		PublicationID = p.ID,
		PublicationName = p.Name,

		notesCount = isnull(nc.NotesCount,0),
		notesCountWaiting = isnull(ncWaiting.NotesCount,0),
		notesCountApproved = isnull(ncApproved.NotesCount,0)
		
	from  

	    Assignment a (nolock)
	
	
		join Issue i (nolock) on a.IssueID = i.ID

		left outer join 
		(
		  select 
		  notesCount = COUNT(ten.TasteNoteID), 
		  AssignmentID = ate.AssignmentID 
		  from Assignment as aa   
		  left join Assignment_TastingEvent as ate on ate.AssignmentID = aa.ID
		  left join TastingEvent_TasteNote  as ten on ten.TastingEventID = ate.TastingEventID
		  where aa.IssueID=@IssueID
		  group by ate.AssignmentID 
		)  nc on  nc.AssignmentID = a.ID

		left outer join 
		(
		  select 
		  notesCount = COUNT(ten.TasteNoteID), 
		  AssignmentID = ate.AssignmentID 
		  from Assignment as aa   
		  left join Assignment_TastingEvent as ate on ate.AssignmentID   = aa.ID
		  left join TastingEvent_TasteNote  as ten on ten.TastingEventID = ate.TastingEventID
		  left join TasteNote               as tn  on tn.ID              = ten.TasteNoteID 
		  where aa.IssueID=@IssueID and tn.WF_StatusID < 60 and tn.WF_StatusID >= 0
		  group by ate.AssignmentID 
		)  ncWaiting on  ncWaiting.AssignmentID = a.ID

		left outer join 
		(
		  select 
		  notesCount = COUNT(ten.TasteNoteID), 
		  AssignmentID = ate.AssignmentID 
		  from Assignment as aa   
		  left join Assignment_TastingEvent as ate on ate.AssignmentID   = aa.ID
		  left join TastingEvent_TasteNote  as ten on ten.TastingEventID = ate.TastingEventID
		  left join TasteNote               as tn  on tn.ID              = ten.TasteNoteID 
		  where aa.IssueID=@IssueID and tn.WF_StatusID >= 60
		  group by ate.AssignmentID 
		)  ncApproved on  ncApproved.AssignmentID = a.ID




		join Publication p (nolock) on i.PublicationID = p.ID
		join WF_Statuses wfs (nolock) on a.WF_StatusID = wfs.ID

	where a.IssueID = @IssueID
	
-------------	
select AssignmentID,r.UserId,UserRoleID,uu.FullName from Assignment_Resource as r
join Assignment as a on a.ID = r.AssignmentID 	
join Users uu (nolock) on r.UserId = uu.UserId
where a.IssueID = @IssueID

-------------	
select AssignmentID,TypeID, r.Deadline from Assignment_ResourceD as r
join Assignment as a on a.ID = r.AssignmentID 	
where a.IssueID = @IssueID

	
RETURN 1