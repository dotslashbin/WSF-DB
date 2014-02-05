
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

if @ID is not null begin
	select 
		ID = te.ID,
		ParentID = te.ParentID,
		ReviewerID = te.ReviewerID,
		ReviewerName = r.Name,
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
		WF_StatusID = te.WF_StatusID,
		WF_StatusName = wfs.Name,
		created = te.created, 
		updated = te.updated
	from TastingEvent te (nolock)
		join Reviewer r (nolock) on te.ReviewerID = r.ID
		join WF_Statuses wfs (nolock) on te.WF_StatusID = wfs.ID
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
		ReviewerID = te.ReviewerID,
		ReviewerName = r.Name,
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
		WF_StatusID = te.WF_StatusID,
		WF_StatusName = wfs.Name,
		created = te.created, 
		updated = te.updated
	from TastingEvent te (nolock)
		join Reviewer r (nolock) on te.ReviewerID = r.ID
		join WF_Statuses wfs (nolock) on te.WF_StatusID = wfs.ID
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

