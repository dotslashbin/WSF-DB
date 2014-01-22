-- =============================================
-- Author:		Alex B.
-- Create date: 1/22/2014
-- Description:	Gets List of WineProducers.
--				Input parameters are used as a filter.
-- =============================================
CREATE PROCEDURE [dbo].[WineProducer_GetList]
	@ID int = NULL, @Name nvarchar(100) = NULL
	--@NameToShow nvarchar(100) = NULL,
	--@locCountry nvarchar(50) = NULL, @locRegion nvarchar(50) = NULL, 
	--@locLocation nvarchar(50) = NULL, @locLocale nvarchar(50) = NULL, @locSite nvarchar(50) = NULL

/*
exec WineProducer_GetList @ID = NULL, @Name = 'monda'
*/
	
AS
set nocount on

if @ID is not null begin
	select 
		ID = wp.ID,
		Name = wp.Name,
		NameToShow = wp.NameToShow,
		WebSiteURL = wp.WebSiteURL,
		locCountry = lc.Name,
		locRegion = lr.Name,
		locLocation = lloc.Name,
		locLocale = ll.Name,
		locSiteID = ls.Name,
		Profile = wp.Profile,
		ContactInfo = wp.ContactInfo,
		WF_StatusID = wp.WF_StatusID,
		WF_StatusName = wfs.Name,
		created = wp.created, 
		updated = wp.updated,
		CreatorName = isnull(creator.Name, 'system'),
		EditorName = isnull(editor.Name, '')
	from WineProducer wp (nolock)
		join WF_Statuses wfs (nolock) on wp.WF_StatusID = wfs.ID
		left join LocationCountry lc (nolock) on wp.locCountryID = lc.ID
		left join LocationRegion lr (nolock) on wp.locRegionID = lr.ID
		left join LocationLocation lloc (nolock) on wp.locLocationID = lloc.ID
		left join LocationLocale ll (nolock) on wp.locLocaleID = ll.ID
		left join LocationSite ls (nolock) on wp.locSiteID = ls.ID
		
		left join Audit_EntryUsers creator (nolock) on wp.CreatorID = creator.ID
		left join Audit_EntryUsers editor (nolock) on wp.EditorID = editor.ID
	where wp.ID > 0 
		and wp.ID = @ID
end else if @Name is NOT NULL begin
	if @Name is NOT NULL 
		select @Name = '%' + @Name + '%'

	select 
		ID = wp.ID,
		Name = wp.Name,
		NameToShow = wp.NameToShow,
		WebSiteURL = wp.WebSiteURL,
		locCountry = lc.Name,
		locRegion = lr.Name,
		locLocation = lloc.Name,
		locLocale = ll.Name,
		locSiteID = ls.Name,
		Profile = '',
		ContactInfo = '',
		WF_StatusID = wp.WF_StatusID,
		WF_StatusName = wfs.Name,
		created = wp.created, 
		updated = wp.updated,
		CreatorName = isnull(creator.Name, 'system'),
		EditorName = isnull(editor.Name, '')
	from WineProducer wp (nolock)
		join WF_Statuses wfs (nolock) on wp.WF_StatusID = wfs.ID
		left join LocationCountry lc (nolock) on wp.locCountryID = lc.ID
		left join LocationRegion lr (nolock) on wp.locRegionID = lr.ID
		left join LocationLocation lloc (nolock) on wp.locLocationID = lloc.ID
		left join LocationLocale ll (nolock) on wp.locLocaleID = ll.ID
		left join LocationSite ls (nolock) on wp.locSiteID = ls.ID
		
		left join Audit_EntryUsers creator (nolock) on wp.CreatorID = creator.ID
		left join Audit_EntryUsers editor (nolock) on wp.EditorID = editor.ID
	where wp.ID > 0 
		and wp.Name like @Name
	order by wp.Name, wp.ID
end else begin
	select 
		ID = wp.ID,
		Name = wp.Name,
		NameToShow = wp.NameToShow,
		WebSiteURL = wp.WebSiteURL,
		locCountry = lc.Name,
		locRegion = lr.Name,
		locLocation = lloc.Name,
		locLocale = ll.Name,
		locSiteID = ls.Name,
		Profile = '',
		ContactInfo = '',
		WF_StatusID = wp.WF_StatusID,
		WF_StatusName = wfs.Name,
		created = wp.created, 
		updated = wp.updated,
		CreatorName = isnull(creator.Name, 'system'),
		EditorName = isnull(editor.Name, '')
	from WineProducer wp (nolock)
		join WF_Statuses wfs (nolock) on wp.WF_StatusID = wfs.ID
		left join LocationCountry lc (nolock) on wp.locCountryID = lc.ID
		left join LocationRegion lr (nolock) on wp.locRegionID = lr.ID
		left join LocationLocation lloc (nolock) on wp.locLocationID = lloc.ID
		left join LocationLocale ll (nolock) on wp.locLocaleID = ll.ID
		left join LocationSite ls (nolock) on wp.locSiteID = ls.ID

		left join Audit_EntryUsers creator (nolock) on wp.CreatorID = creator.ID
		left join Audit_EntryUsers editor (nolock) on wp.EditorID = editor.ID
	where wp.ID > 0
	order by wp.Name, wp.ID
end
	
RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[WineProducer_GetList] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[WineProducer_GetList] TO [RP_Customer]
    AS [dbo];

