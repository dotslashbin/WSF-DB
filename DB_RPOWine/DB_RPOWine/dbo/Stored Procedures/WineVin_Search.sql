-- =============================================
-- Author:		Alex B
-- Create date: 1/20/2014
-- Description:	Returns list of Wine_VinN records containing @SearchString
--				Stored procedure requires input parameter @SearchString to be 
--				"as user types", no special characters (*, %, etc.) required and none 
--				of them will have special meaning.
-- =============================================
CREATE PROCEDURE [dbo].[WineVin_Search]
	@SearchString nvarchar(1024), 
	@FieldNameToSearch varchar(30) = NULL,
	@topNRows int = 100, @rankLimit int = 0,
	@isDebug bit = 0

AS
set nocount on
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

select @SearchString = replace(replace(rtrim(ltrim(@SearchString)), '%', ''), '*', '')

if @SearchString is NULL or len(@SearchString) < 2 begin
	raiserror('Search String is required.', 16, 1)
	RETURN -1
end

if @isDebug = 1
	print @SearchString

--------- Results --------
create table #t (
	Wine_VinN_ID int not null, 
	Wine_VinN_GroupID int null,
	WF_StatusID smallint null,
	locCountryID int null, locRegionID int null, locLocationID int null, locLocaleID int null, locSiteID int null,
	ProducerID int null, TypeID int null, LabelID int null, VarietyID int null, DrynessID int null, ColorID int null,
	SortOrder smallint null
)

if isnull(lower(@FieldNameToSearch), '') in ('', 'labelname') begin
	select	@SearchString = '%' + replace(@SearchString, ' ', '%') + '%'
	if @isDebug = 1
		print @SearchString	
	
	; with f as (
		select ID, Name, 
			SortOrder = case when Name like right(@SearchString, len(@SearchString)-1) then 0 else 20 end
		from WineLabel (nolock)
		where Name like @SearchString
	)
	insert into #t
	select top(@topNRows)
		Wine_VinN_ID = v.ID, Wine_VinN_GroupID = v.GroupID, 
		Wine_VinN_WF_StatusID = v.WF_StatusID,
		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
		ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID,
		SortOrder = f.SortOrder
	from f
		join Wine_VinN v on f.ID = v.LabelID
	order by f.SortOrder, f.Name;
end else if lower(@FieldNameToSearch) = 'extendedlabel' begin
	select	@SearchString = '%' + replace(@SearchString, ' ', '%') + '%'
	if @isDebug = 1
		print @SearchString	

	; with f as (
		select ID, Name, 
			SortOrder = case when Name like right(@SearchString, len(@SearchString)-1) then 10 else 20 end
		from WineLabel (nolock)
		where Name like @SearchString
	)
	insert into #t
	select top(@topNRows)
		Wine_VinN_ID = v.ID, Wine_VinN_GroupID = v.GroupID, 
		Wine_VinN_WF_StatusID = v.WF_StatusID,
		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
		ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID,
		SortOrder = f.SortOrder
	from f
		join Wine_VinN v on f.ID = v.LabelID
	order by f.SortOrder, f.Name;
	
	; with f as (
		select ID, Name, 
			SortOrder = case when Name like right(@SearchString, len(@SearchString)-1) then 12 else 22 end
		from WineProducer (nolock)
		where NameToShow like @SearchString
	)
	insert into #t
	select top(@topNRows)
		Wine_VinN_ID = v.ID, Wine_VinN_GroupID = v.GroupID, 
		Wine_VinN_WF_StatusID = v.WF_StatusID,
		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
		ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID,
		SortOrder = f.SortOrder
	from f
		join Wine_VinN v on f.ID = v.LabelID
	order by f.SortOrder, f.Name;

	; with f as (
		select ID, Name, 
			SortOrder = case when Name like right(@SearchString, len(@SearchString)-1) then 14 else 24 end
		from WineVariety (nolock)
		where Name like @SearchString
	)
	insert into #t
	select top(@topNRows)
		Wine_VinN_ID = v.ID, Wine_VinN_GroupID = v.GroupID, 
		Wine_VinN_WF_StatusID = v.WF_StatusID,
		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
		ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID,
		SortOrder = f.SortOrder
	from f
		join Wine_VinN v on f.ID = v.LabelID
	order by f.SortOrder, f.Name;
end else if lower(@FieldNameToSearch) = 'appellation' begin
	-- Appellation = coalesce(Site.Name, Locale.name, Location.name, Region.name, Country.name),
	select	@SearchString = '%' + replace(@SearchString, ' ', '%') + '%'
	if @isDebug = 1
		print @SearchString	

	; with f as (
		select ID, Name, 
			SortOrder = case when Name like right(@SearchString, len(@SearchString)-1) then 10 else 40 end
		from LocationSite (nolock)
		where Name like @SearchString
	)
	insert into #t
	select top(@topNRows/2)
		Wine_VinN_ID = v.ID, Wine_VinN_GroupID = v.GroupID, 
		Wine_VinN_WF_StatusID = v.WF_StatusID,
		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
		ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID,
		SortOrder = f.SortOrder
	from f
		join Wine_VinN v on f.ID = v.locSiteID
	order by f.SortOrder, f.Name;

	; with f as (
		select ID, Name, 
			SortOrder = case when Name like right(@SearchString, len(@SearchString)-1) then 12 else 42 end
		from LocationLocale (nolock)
		where Name like @SearchString
	)
	insert into #t
	select top(@topNRows/2)
		Wine_VinN_ID = v.ID, Wine_VinN_GroupID = v.GroupID, 
		Wine_VinN_WF_StatusID = v.WF_StatusID,
		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
		ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID,
		SortOrder = f.SortOrder
	from f
		join Wine_VinN v on f.ID = v.locLocaleID
	order by f.SortOrder, f.Name;

	; with f as (
		select ID, Name, 
			SortOrder = case when Name like right(@SearchString, len(@SearchString)-1) then 14 else 44 end
		from LocationLocation (nolock)
		where Name like @SearchString
	)
	insert into #t
	select top(@topNRows/2)
		Wine_VinN_ID = v.ID, Wine_VinN_GroupID = v.GroupID, 
		Wine_VinN_WF_StatusID = v.WF_StatusID,
		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
		ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID,
		SortOrder = f.SortOrder
	from f
		join Wine_VinN v on f.ID = v.locLocationID
	order by f.SortOrder, f.Name;

	; with f as (
		select ID, Name, 
			SortOrder = case when Name like right(@SearchString, len(@SearchString)-1) then 16 else 46 end
		from LocationRegion (nolock)
		where Name like @SearchString
	)
	insert into #t
	select top(@topNRows/2)
		Wine_VinN_ID = v.ID, Wine_VinN_GroupID = v.GroupID, 
		Wine_VinN_WF_StatusID = v.WF_StatusID,
		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
		ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID,
		SortOrder = f.SortOrder
	from f
		join Wine_VinN v on f.ID = v.locRegionID
	order by f.SortOrder, f.Name;

	; with f as (
		select ID, Name, 
			SortOrder = case when Name like right(@SearchString, len(@SearchString)-1) then 18 else 48 end
		from LocationCountry (nolock)
		where Name like @SearchString
	)
	insert into #t
	select top(@topNRows/2)
		Wine_VinN_ID = v.ID, Wine_VinN_GroupID = v.GroupID, 
		Wine_VinN_WF_StatusID = v.WF_StatusID,
		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
		ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID,
		SortOrder = f.SortOrder
	from f
		join Wine_VinN v on f.ID = v.locCountryID
	order by f.SortOrder, f.Name;

end else begin
	select @SearchString = '"' + replace(@SearchString, ' ', '*" and "') + '*"'
	if @isDebug = 1
		print @SearchString	

	select 
		Wine_VinN_ID = v.Wine_VinN_ID, 
		Label = v.Label,
		Producer = v.Producer, 
		ProducerToShow = v.ProducerToShow,
		Country = v.Country, Region = v.Region, Location = v.Location, Locale = v.Locale, Site = v.Site,
		Appellation = v.Appellation,
		Color = v.Color, Variety = v.Variety, Dryness = v.Dryness, WineType = v.[Type], 
		WF_StatusID = v.Wine_VinN_WF_StatusID
		--fts.RANK
	from vWineVinNDetails v
		join containstable(vWineVinNDetails, *, @SearchString, @topNRows) fts
			on v.Wine_VinN_ID = fts.[KEY]
	where fts.RANK > @rankLimit
	order by fts.RANK desc
	
	RETURN 1
end

/*
select top(@topNRows)
	Wine_VinN_ID = r.Wine_VinN_ID, 
	Label, Producer, ProducerToShow,
	Country, Region, Location, Locale, Site, Appellation,
	Color, Variety, Dryness, WineType = v.[Type], 
	WF_StatusID = r.WF_StatusID
from #t r
	join vWineVinNDetails v on r.Wine_VinN_ID = v.Wine_VinN_ID
order by SortOrder, Label, ProducerToShow, Variety
*/

select top(@topNRows)
	Wine_VinN_ID = r.Wine_VinN_ID, 
	Label = wl.Name,
	Producer = wp.Name, 
	ProducerToShow = wp.NameToShow,
	
	Country = lc.Name, Region = lr.Name, 
	Location = ll.Name, 
	Locale = lloc.Name, Site = ls.Name,
	Appellation = coalesce(
		nullif(ls.Name,''), nullif(lloc.name,''), nullif(ll.name,''), nullif(lr.name,''), nullif(lc.name,'')
	),
		
	Color = wc.Name,
	Variety = wv.Name, 
	Dryness = wd.Name,
	WineType = wt.Name, 

	WF_StatusID = r.WF_StatusID
from #t r
	join dbo.LocationCountry lc (nolock) on r.locCountryID = lc.ID
	join dbo.LocationRegion lr (nolock) on r.locRegionID = lr.ID
	join dbo.LocationLocation ll (nolock) on r.locLocationID = ll.ID
	join dbo.LocationLocale lloc (nolock) on r.locLocaleID = lloc.ID
	join dbo.LocationSite ls (nolock) on r.locSiteID = ls.ID

	join dbo.WineProducer wp (nolock) on r.ProducerID = wp.ID
	join dbo.WineType wt (nolock) on r.TypeID = wt.ID
	join dbo.WineLabel wl (nolock) on r.LabelID = wl.ID
	join dbo.WineVariety wv (nolock) on r.VarietyID = wv.ID
	join dbo.WineDryness wd (nolock) on r.DrynessID = wd.ID
	join dbo.WineColor wc (nolock) on r.ColorID = wc.ID
order by SortOrder, Label, Producer, Variety, Country
drop table #t

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[WineVin_Search] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[WineVin_Search] TO [RP_Customer]
    AS [dbo];

