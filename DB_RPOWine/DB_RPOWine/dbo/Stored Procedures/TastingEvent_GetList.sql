
-- =============================================
-- Author:		Alex B.
-- Create date: 1/26/2014
-- Description:	Gets List of Tasting Events.
--				Input parameters are used as a filter.
--				If @ParentID is not specified only 1st level events will be showsn (ParentID = 0)
-- =============================================
CREATE PROCEDURE [dbo].[TastingEvent_GetList]
	@ID int = NULL, @ParentID int = NULL,
	--@NameToShow nvarchar(100) = NULL,
	--@locCountry nvarchar(50) = NULL, @locRegion nvarchar(50) = NULL, 
	--@locLocation nvarchar(50) = NULL, @locLocale nvarchar(50) = NULL, @locSite nvarchar(50) = NULL
	
	@WF_StatusID int = NULL, 
	@AssignedByID int = NULL, @AssignedToID int = NULL, 
	@AssignedDateStart smalldatetime = NULL, @AssignedDateEnd smalldatetime = NULL,

	--@StartRow int = NULL, @EndRow int = NULL,
	--@SortBy varchar(20) = NULL, @SortOrder varchar(3) = NULL
	@ShowRes smallint = 1
	
/*
exec TastingEvent_GetList 
	, @StartRow = 15, @EndRow = 20, @SortBy = 'NameToShow'
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

if @ID is not null begin
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
		
		WF_StatusID = isnull(wfs.ID, -1),
		WF_StatusName = isnull(wfs.Name, ''),
		WF_AssignedByLogin = uby.UserName,
		WF_AssignedByName = uby.FullName,
		WF_AssignedToLogin = uto.UserName,
		WF_AssignedToName = uto.FullName,
		WF_AssignedDate = wf.AssignedDate, 
		WF_Note = wf.Note
	from TastingEvent te (nolock)
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
		and te.ID = @ID
end else begin
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
		
		WF_StatusID = isnull(wfs.ID, -1),
		WF_StatusName = isnull(wfs.Name, ''),
		WF_AssignedByLogin = uby.UserName,
		WF_AssignedByName = uby.FullName,
		WF_AssignedToLogin = uto.UserName,
		WF_AssignedToName = uto.FullName,
		WF_AssignedDate = wf.AssignedDate, 
		WF_Note = wf.Note
	from TastingEvent te (nolock)
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
		and te.ParentID = @ParentID
	order by ParentID, StartDate desc, SortOrder
end
	
RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[TastingEvent_GetList] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[TastingEvent_GetList] TO [RP_Customer]
    AS [dbo];

