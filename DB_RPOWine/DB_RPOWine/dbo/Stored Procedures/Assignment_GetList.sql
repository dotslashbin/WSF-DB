
-- =============================================
-- Author:		Alex B.
-- Create date: 2/17/2014
-- Description:	Gets List of Assignments.
--				Input parameters are used as a filter.
-- =============================================
CREATE PROCEDURE [dbo].[Assignment_GetList]
	@ID int = NULL, 
	@IssueID int = NULL, -- @AuthorId int = NULL,
	@Title nvarchar(255) = NULL,

	@WF_StatusID smallint = NULL,
	@Resource_UserID int = NULL,
	
	--@StartRow int = NULL, @EndRow int = NULL,
	--@SortBy varchar(20) = NULL, @SortOrder varchar(3) = NULL
	@ShowRes smallint = 1
	
/*
exec Assignment_GetList @Title = 'test', @Resource_UserID = -5
*/
	
AS
set nocount on

if @Title is NOT NULL 
		select @Title = '%' + @Title + '%'

if @IssueID is not null begin
	

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
		userId = u.UserId  ,
		userRoleId = u.UserRoleID,
		userFullName = uu.FullName,
		deadlineId = null,
		deadline = null
		
	from Assignment a (nolock)
		join Issue i (nolock) on a.IssueID = i.ID
		join Publication p (nolock) on i.PublicationID = p.ID
		join WF_Statuses wfs (nolock) on a.WF_StatusID = wfs.ID
		join Assignment_Resource u (nolock) on a.ID = u.AssignmentID
		join Users uu (nolock) on u.UserId = uu.UserId

	where a.IssueID = @IssueID
union
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
		userId =null,
		userRoleId = null,
		userRoleName = null,
		deadlineId = d.TypeID,
		deadline = d.Deadline

		
	from Assignment a (nolock)
		join Issue i (nolock) on a.IssueID = i.ID
		join Publication p (nolock) on i.PublicationID = p.ID
		join WF_Statuses wfs (nolock) on a.WF_StatusID = wfs.ID
		join Assignment_ResourceD d (nolock) on a.ID = d.AssignmentID
	where a.IssueID = @IssueID
	
	order by id
	
	
	
end else if @Resource_UserID is NOT NULL begin

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
		null,
		null,
		null,
		d.TypeID,
		d.Deadline
		
	from Assignment a (nolock)
		join Issue i (nolock) on a.IssueID = i.ID
		join Publication p (nolock) on i.PublicationID = p.ID
		join WF_Statuses wfs (nolock) on a.WF_StatusID = wfs.ID
		join Assignment_Resource u (nolock) on a.ID = u.AssignmentID
		join Assignment_ResourceD d (nolock) on a.ID = d.AssignmentID
	where a.IssueID = isnull(@IssueID, a.IssueID)
		and u.UserId = @Resource_UserID

	order by id


	select 
		ID = a.ID,
		--AuthorId = a.AuthorId,
		--AuthorName = isnull(u.FullName, ''),
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
		PublicationName = p.Name
	from Assignment a (nolock)
		join Issue i (nolock) on a.IssueID = i.ID
		join Publication p (nolock) on i.PublicationID = p.ID
--		left join Users u (nolock) on a.AuthorId = u.UserId
		left join WF_Statuses wfs (nolock) on a.WF_StatusID = wfs.ID
		join Assignment_Resource ar (nolock) on a.ID = ar.AssignmentID
	where a.IssueID = isnull(@IssueID, a.IssueID)
		--and a.AuthorId = isnull(@AuthorId, a.AuthorId)
		and (@Title is NULL or a.Title like @Title)
		and a.WF_StatusID = isnull(@WF_StatusID, a.WF_StatusID)
		and ar.UserId = @Resource_UserID
	order by Deadline desc, a.ID
	
	
	
	
end 

	
RETURN 1
GO



GO


