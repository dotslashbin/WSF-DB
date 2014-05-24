

CREATE PROCEDURE [dbo].[Assignment_GetList_ByUserId]
	@UserID int = NULL
		
	
AS


set nocount on




	select distinct
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

		notesCount = isnull(nc.NotesCount,0)
		
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
		  group by ate.AssignmentID 
		)  nc on  nc.AssignmentID = a.ID

		join Publication p (nolock) on i.PublicationID = p.ID
		join WF_Statuses wfs (nolock) on a.WF_StatusID = wfs.ID
		join Assignment_Resource  r (nolock) on r.AssignmentID = a.ID

	where r.UserId  = @UserID
	
	
select AssignmentID,r.UserId,UserRoleID,uu.FullName from Assignment_Resource as r
join Assignment as a on a.ID = r.AssignmentID 	
join Users uu (nolock) on r.UserId = uu.UserId
where r.UserId  = @UserID

	
select distinct r.AssignmentID,TypeID, r.Deadline from Assignment_ResourceD as r
join Assignment as a on a.ID = r.AssignmentID 	
join Assignment_Resource as ru on a.ID = ru.AssignmentID
where ru.UserId  = @UserID
	
RETURN 1