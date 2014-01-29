-- =============================================
-- Author:		Alex B
-- Create date: 1/20/2014
-- Description:	Returns list of Wine_VinN records containing @SearchString
--				Stored procedure requires input parameter @SearchString to be well formatted for 
--				CONTAINSTABLE
-- =============================================
CREATE PROCEDURE [dbo].[WineVin_SearchFT]
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

--select @SearchString = replace(replace(rtrim(ltrim(@SearchString)), '%', '*'), '  ', ' ')
--if lower(@FieldNameToSearch) = 'labelname' begin
--	-- applying macroses
--	select @SearchString = dbo.fn_GetAdjustedSearchString(@SearchString)
--end

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

if lower(@FieldNameToSearch) = 'labelname' begin
	insert into #t
	select top(@topNRows)
		Wine_VinN_ID, Wine_VinN_GroupID, Wine_VinN_WF_StatusID,
		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
		ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID,
		SortOrder = fts.RANK
	from vWineVinNDetails v
		join containstable(vWineVinNDetails, Label, @SearchString, @topNRows) fts
			on v.Wine_VinN_ID = fts.[KEY]
	where fts.RANK > @rankLimit
end else if lower(@FieldNameToSearch) = 'extendedlabel' begin
	insert into #t
	select top(@topNRows)
		Wine_VinN_ID, Wine_VinN_GroupID, Wine_VinN_WF_StatusID,
		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
		ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID,
		SortOrder = fts.RANK
	from vWineVinNDetails v
		join containstable(vWineVinNDetails, (ProducerToShow, Label, Variety), @SearchString, @topNRows) fts
			on v.Wine_VinN_ID = fts.[KEY]
	where fts.RANK > @rankLimit
end else if lower(@FieldNameToSearch) = 'appellation' begin
	insert into #t
	select top(@topNRows)
		Wine_VinN_ID, Wine_VinN_GroupID, Wine_VinN_WF_StatusID,
		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
		ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID,
		SortOrder = fts.RANK
	from vWineVinNDetails v
		join containstable(vWineVinNDetails, Appellation, @SearchString, @topNRows) fts
			on v.Wine_VinN_ID = fts.[KEY]
	where fts.RANK > @rankLimit
end else begin
	insert into #t
	select top(@topNRows)
		Wine_VinN_ID, Wine_VinN_GroupID, Wine_VinN_WF_StatusID,
		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
		ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID,
		SortOrder = fts.RANK
	from vWineVinNDetails v
		join containstable(vWineVinNDetails, *, @SearchString, @topNRows) fts
			on v.Wine_VinN_ID = fts.[KEY]
	where fts.RANK > @rankLimit
end

if @@rowcount > 100 begin
	if @isDebug = 1
		print '--- Creating Index on #t ---'
	CREATE NONCLUSTERED INDEX [IX_t] ON #t (
		[ColorID] ASC
	) WITH (SORT_IN_TEMPDB = ON);
end

select --top(@topNRows)
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
    ON OBJECT::[dbo].[WineVin_SearchFT] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[WineVin_SearchFT] TO [RP_Customer]
    AS [dbo];

