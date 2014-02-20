-- =============================================
-- Author:		Alex B.
-- Create date: 1/22/2014
-- Description:	Gets List of WineProducers.
--				Input parameters are used as a filter.
--				To get Last Page, define @RowsPerPage and leave @StartRow and @EndRow as NULL
-- =============================================
CREATE PROCEDURE [dbo].[WineProducer_GetList]
	@ID int = NULL, @Name nvarchar(100) = NULL,
	--@NameToShow nvarchar(100) = NULL,
	@locCountry nvarchar(50) = NULL, @locRegion nvarchar(50) = NULL, 
	--@locLocation nvarchar(50) = NULL, @locLocale nvarchar(50) = NULL, @locSite nvarchar(50) = NULL
	
	@StartRow int = NULL, @EndRow int = NULL,
	@SortBy varchar(20) = NULL, @SortOrder varchar(3) = NULL,
	@RowsPerPage int = NULL,
	
	@WF_StatusID int = NULL, 
	@AssignedByID int = NULL, @AssignedToID int = NULL, 
	@AssignedDateStart smalldatetime = NULL, @AssignedDateEnd smalldatetime = NULL
	
/*
exec WineProducer_GetList @ID = NULL, @Name = 'rob', @StartRow = 15, @EndRow = 20, @SortBy = 'NameToShow'
*/
	
AS
set nocount on

-- TEST
--raiserror('[USERERROR]:: Test user error.', 16, 1)
--RETURN -1

if @ID < 0
	select @ID = NULL
select @locCountry = nullif(rtrim(ltrim(@locCountry)), ''), @locRegion = nullif(rtrim(ltrim(@locRegion)), '')

declare @TotalRows int
if isnull(@StartRow, 0) < 0 or isnull(@EndRow, 0) <= 0
	select @StartRow = NULL, @EndRow = NULL
select @SortBy = isnull(@SortBy, 'Name'), @SortOrder = lower(isnull(@SortOrder, 'asc'))

declare @locCountryID int, @locRegionID int
if @locCountry is NOT NULL
	exec @locCountryID = Location_GetLookupID @ObjectName='locCountry', @ObjectValue=@locCountry, @IsAutoCreate=0
if @locRegionID is NOT NULL
	exec @locRegionID = Location_GetLookupID @ObjectName='locRegion', @ObjectValue=@locRegion, @IsAutoCreate=0

------- WF attributes ---
declare @ObjectTypeID int

exec @ObjectTypeID = WF_GetLookupID @ObjectName = 'objecttype', @ObjectValue = 'WineProducer'

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

if @ID is not null or (@StartRow is null or @EndRow is NULL) begin
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
		Profile = wp.Profile,
		ContactInfo = wp.ContactInfo,
		--WF_StatusID = wp.WF_StatusID,
		--WF_StatusName = wfs.Name,
		created = wp.created, 
		updated = wp.updated,
		CreatorName = isnull(creator.Name, 'system'),
		EditorName = isnull(editor.Name, ''),
		
		WF_StatusID = isnull(wfs.ID, -1),
		WF_StatusName = isnull(wfs.Name, ''),
		WF_AssignedByID = isnull(uby.UserId, 0),
		WF_AssignedByLogin = uby.UserName,
		WF_AssignedByName = uby.FullName,
		WF_AssignedToID = isnull(uto.UserId, 0),
		WF_AssignedToLogin = uto.UserName,
		WF_AssignedToName = uto.FullName,
		WF_AssignedDate = wf.AssignedDate, 
		WF_Note = wf.Note,
		
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
		
		left join WF wf (nolock) on wf.ObjectTypeID = @ObjectTypeID and wp.ID = wf.ObjectID
		left join Users uby (nolock) on wf.AssignedByID = uby.UserId
		left join Users uto (nolock) on wf.AssignedToID = uto.UserId
	where wp.ID > 0 
		and (@ID is NULL or wp.ID = @ID)
		and (@Name is NULL or wp.Name like @Name)
		and (@locCountryID is NULL or wp.locCountryID = @locCountryID)
		and (@locRegionID is NULL or wp.locRegionID = @locRegionID)
	order by Name, NameToShow, ID
end else if @Name is NOT NULL begin
	if @Name is NOT NULL 
		select @Name = '%' + @Name + '%'

	select @TotalRows = count(*) 
	from WineProducer wp (nolock)
	where wp.ID > 0 
		and wp.Name like @Name
		and (@locCountryID is NULL or wp.locCountryID = @locCountryID)
		and (@locRegionID is NULL or wp.locRegionID = @locRegionID)

	if (isnull(@RowsPerPage, 0) > 0 and (@StartRow is NULL or @EndRow is NULL)) begin
		-- get last page
		select 
			@StartRow = case
				when @TotalRows < @RowsPerPage then 1
				else (cast(ceiling(cast(@TotalRows as money) / @RowsPerPage) as int) - 1) * @RowsPerPage + 1
			end,
			@EndRow = @TotalRows
	end

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
			--WF_StatusID = wp.WF_StatusID,
			--WF_StatusName = wfs.Name,
			created = wp.created, 
			updated = wp.updated,
			CreatorName = isnull(creator.Name, 'system'),
			EditorName = isnull(editor.Name, ''),
			
			WF_StatusID = isnull(wfs.ID, -1),
			WF_StatusName = isnull(wfs.Name, ''),
			WF_AssignedByID = isnull(uby.UserId, 0),
			WF_AssignedByLogin = uby.UserName,
			WF_AssignedByName = uby.FullName,
			WF_AssignedToID = isnull(uto.UserId, 0),
			WF_AssignedToLogin = uto.UserName,
			WF_AssignedToName = uto.FullName,
			WF_AssignedDate = wf.AssignedDate, 
			WF_Note = wf.Note,

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
			
			left join WF wf (nolock) on wf.ObjectTypeID = @ObjectTypeID and wp.ID = wf.ObjectID
			left join Users uby (nolock) on wf.AssignedByID = uby.UserId
			left join Users uto (nolock) on wf.AssignedToID = uto.UserId
		where wp.ID > 0 
			and wp.Name like @Name
			and (@locCountryID is NULL or wp.locCountryID = @locCountryID)
			and (@locRegionID is NULL or wp.locRegionID = @locRegionID)
	)
	select * from r
	where (@StartRow is NULL or @EndRow is NULL or
		RowNumber between @StartRow and @EndRow)
	order by RowNumber, ID
end else begin
	select @TotalRows = count(*) 
	from WineProducer wp (nolock)
	where wp.ID > 0 
		and (@locCountryID is NULL or wp.locCountryID = @locCountryID)
		and (@locRegionID is NULL or wp.locRegionID = @locRegionID)

	if (isnull(@RowsPerPage, 0) > 0 and (@StartRow is NULL or @EndRow is NULL)) begin
		-- get last page
		select 
			@StartRow = case
				when @TotalRows < @RowsPerPage then 1
				else (cast(ceiling(cast(@TotalRows as money) / @RowsPerPage) as int) - 1) * @RowsPerPage + 1
			end,
			@EndRow = @TotalRows
	end

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
			--WF_StatusID = wp.WF_StatusID,
			--WF_StatusName = wfs.Name,
			created = wp.created, 
			updated = wp.updated,
			CreatorName = isnull(creator.Name, 'system'),
			EditorName = isnull(editor.Name, ''),
			
			WF_StatusID = isnull(wfs.ID, -1),
			WF_StatusName = isnull(wfs.Name, ''),
			WF_AssignedByID = isnull(uby.UserId, 0),
			WF_AssignedByLogin = uby.UserName,
			WF_AssignedByName = uby.FullName,
			WF_AssignedToID = isnull(uto.UserId, 0),
			WF_AssignedToLogin = uto.UserName,
			WF_AssignedToName = uto.FullName,
			WF_AssignedDate = wf.AssignedDate, 
			WF_Note = wf.Note,

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

			left join WF wf (nolock) on wf.ObjectTypeID = @ObjectTypeID and wp.ID = wf.ObjectID
			left join Users uby (nolock) on wf.AssignedByID = uby.UserId
			left join Users uto (nolock) on wf.AssignedToID = uto.UserId
		where wp.ID > 0
			and (@locCountryID is NULL or wp.locCountryID = @locCountryID)
			and (@locRegionID is NULL or wp.locRegionID = @locRegionID)
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

