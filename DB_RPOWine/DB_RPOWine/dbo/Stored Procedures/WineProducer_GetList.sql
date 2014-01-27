-- =============================================
-- Author:		Alex B.
-- Create date: 1/22/2014
-- Description:	Gets List of WineProducers.
--				Input parameters are used as a filter.
-- =============================================
CREATE PROCEDURE [dbo].[WineProducer_GetList]
	@ID int = NULL, @Name nvarchar(100) = NULL,
	--@NameToShow nvarchar(100) = NULL,
	--@locCountry nvarchar(50) = NULL, @locRegion nvarchar(50) = NULL, 
	--@locLocation nvarchar(50) = NULL, @locLocale nvarchar(50) = NULL, @locSite nvarchar(50) = NULL
	
	@StartRow int = NULL, @EndRow int = NULL,
	@SortBy varchar(20) = NULL, @SortOrder varchar(3) = NULL
	
/*
exec WineProducer_GetList @ID = NULL, @Name = 'wine', @StartRow = 15, @EndRow = 20, @SortBy = 'NameToShow'
*/
	
AS
set nocount on

declare @TotalRows int
if isnull(@StartRow, 0) < 0 or isnull(@EndRow, 0) <= 0
	select @StartRow = NULL, @EndRow = NULL
select @SortBy = isnull(@SortBy, 'Name'), @SortOrder = lower(isnull(@SortOrder, 'asc'))

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
		EditorName = isnull(editor.Name, ''),
		RowNumber = 0,
		TotalRows = 0
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

	select @TotalRows = count(*) 
	from WineProducer wp (nolock)
	where wp.ID > 0 
		and wp.Name like @Name

	; with r as (
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
			EditorName = isnull(editor.Name, ''),
			RowNumber = row_number() over (order by 
				case when @SortBy = 'Name' and @SortOrder = 'asc' then wp.Name else null end asc, 
				case when @SortBy = 'Name' and @SortOrder = 'des' then wp.Name else null end desc,
				case when @SortBy = 'NameToShow' and @SortOrder = 'asc' then wp.NameToShow else null end asc, 
				case when @SortBy = 'NameToShow' and @SortOrder = 'des' then wp.NameToShow else null end desc,
				wp.ID),
			TotalRows = isnull(@TotalRows, 0)
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
	)
	select * from r
	where (@StartRow is NULL or @EndRow is NULL or
		RowNumber between @StartRow and @EndRow)
	order by RowNumber, ID
end else begin
	select @TotalRows = count(*) 
	from WineProducer wp (nolock)
	where wp.ID > 0 

	; with r as (
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
			EditorName = isnull(editor.Name, ''),
			RowNumber = row_number() over (order by 
				case when @SortBy = 'Name' and @SortOrder = 'asc' then wp.Name else null end asc, 
				case when @SortBy = 'Name' and @SortOrder = 'des' then wp.Name else null end desc,
				case when @SortBy = 'NameToShow' and @SortOrder = 'asc' then wp.NameToShow else null end asc, 
				case when @SortBy = 'NameToShow' and @SortOrder = 'des' then wp.NameToShow else null end desc,
				wp.ID),
			TotalRows = isnull(@TotalRows, 0)
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
	)
	select * from r
	where (@StartRow is NULL or @EndRow is NULL or
		RowNumber between @StartRow and @EndRow)
	order by RowNumber, ID
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

