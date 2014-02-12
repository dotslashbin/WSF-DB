-- =============================================
-- Author:		Alex B.
-- Create date: 2/5/2014
-- Description:	Gets List of Tasting Events for a particular Issue.
--				If @ParentID is not specified only 1st level events will be shown (ParentID = 0)
-- =============================================
CREATE PROCEDURE [dbo].[Issue_GetTastingEventList]
	@IssueID int,
	@ID int = NULL, @ParentID int = NULL,

	@WF_StatusID int = NULL, 
	@AssignedByID int = NULL, @AssignedToID int = NULL, 
	@AssignedDateStart smalldatetime = NULL, @AssignedDateEnd smalldatetime = NULL,

	@ShowRes smallint = 1
	
/*
exec Issue_GetTastingEventList @IssueID = 411
*/
	
AS
set nocount on

select @ParentID = isnull(@ParentID, 0)

------- WF attributes ---
declare @ObjectTypeID int

exec @ObjectTypeID = WF_GetLookupID @ObjectName = 'objecttype', @ObjectValue = 'TastingEvent'

if isnull(@AssignedByID, 0) <= 0
	set @AssignedByID = NULL
if isnull(@AssignedToID, 0) <= 0
	set @AssignedToID = NULL

if @AssignedDateStart is NOT NULL
	select @AssignedDateEnd = isnull(@AssignedDateEnd, getdate())
else
	select @AssignedDateEnd = NULL
if @AssignedDateStart is NOT NULL and @AssignedDateEnd is NOT NULL and @AssignedDateStart >= @AssignedDateEnd begin
	raiserror('ERROR Wrong date filter parameters: AssignedDateStart must not be greater than AssignedDateEnd.', 16, 1)
	RETURN -1
end
------- WF attributes ---

	select 
		ID = te.ID,
		ParentID = te.ParentID,
		UserId = te.UserId,
		UserName = u.FullName,
		Title = te.Title,
		StartDate = te.StartDate,
		EndDate = te.EndDate,
		Location = te.Location,
		locCountry = lc.Name,
		locRegion = lr.Name,
		locLocation = lloc.Name,
		locLocale = ll.Name,
		locSite = ls.Name,
		Notes = te.Notes,
		SortOrder = te.SortOrder,
		created = te.created, 
		updated = te.updated,
		
		WF_StatusID = isnull(wf.StatusID, -1),
		WF_StatusName = isnull(wfs.Name, ''),
		WF_AssignedByLogin = uby.UserName,
		WF_AssignedByName = uby.FullName,
		WF_AssignedToLogin = uto.UserName,
		WF_AssignedToName = uto.FullName,
		WF_AssignedDate = wf.AssignedDate, 
		WF_Note = wf.Note
	from TastingEvent te (nolock)
		join Issue_TastingEvent f (nolock) on f.IssueID = @IssueID and te.ID = f.TastingEventID
		join Users u (nolock) on te.UserId = u.UserId

		join WF_Statuses wfs (nolock) on te.WF_StatusID = wfs.ID
		left join WF wf (nolock) on wf.ObjectTypeID = @ObjectTypeID and te.ID = wf.ObjectID
		left join Users uby (nolock) on wf.AssignedByID = uby.UserId
		left join Users uto (nolock) on wf.AssignedToID = uto.UserId

		left join LocationCountry lc (nolock) on te.locCountryID = lc.ID
		left join LocationRegion lr (nolock) on te.locRegionID = lr.ID
		left join LocationLocation lloc (nolock) on te.locLocationID = lloc.ID
		left join LocationLocale ll (nolock) on te.locLocaleID = ll.ID
		left join LocationSite ls (nolock) on te.locSiteID = ls.ID
	where te.ID > 0 
		and (@ID is NULL or te.ID = @ID)
		and te.ParentID = @ParentID
		
		and (@WF_StatusID is NULL or 
			(@WF_StatusID >= 0 and wf.StatusID = @WF_StatusID) or 
			(@WF_StatusID = -1 and wf.StatusID is NULL) )
		and (@AssignedByID is NULL or wf.AssignedByID = @AssignedByID)
		and (@AssignedToID is NULL or wf.AssignedToID = @AssignedToID)
		and (@AssignedDateStart is NULL or wf.AssignedDate between @AssignedDateStart and @AssignedDateEnd)
	order by ParentID, StartDate desc, SortOrder
	
RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Issue_GetTastingEventList] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Issue_GetTastingEventList] TO [RP_Customer]
    AS [dbo];

