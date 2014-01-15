CREATE PROCEDURE [dbo].[Wine_SearchFT]
	@SearchString nvarchar(1024), 
	@topNRows int = 30, --@rankLimit int = 20,
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

select @SearchString = replace(replace(rtrim(ltrim(@SearchString)), '%', '*'), '  ', ' ')

-- ===== special keywords =====
declare @newSearchString nvarchar(1024) = '',
	@sS nvarchar(120), @sD nvarchar(240)

-- complex phrases
if charindex(' ', @SearchString) > 0 begin
	declare crPh CURSOR forward_only fast_forward read_only for
		select Source, Destination 
		from KeywordMap_Wine km (nolock) 
		where charindex(' ', km.Source) > 0
			and @SearchString like '%' + km.Source + '%'
	open crPh
	fetch next from crPh into @sS, @sD
	while @@fetch_status = 0 begin
		if @sS is NOT NULL begin
			select @SearchString = replace(@SearchString, @sS, '')
			if len(@newSearchString) > 0
				select @newSearchString += ' AND ' 
			select @newSearchString += case when @sD is null then @sS else @sD end
		end
		fetch next from crPh into @sS, @sD
	end
	close crPh
	deallocate crPh
end

select @SearchString = rtrim(ltrim(@SearchString))

-- single words
if len(@SearchString) > 0 begin
	if isnull(charindex(' ', @SearchString), 0) < 1 begin
		if len(@newSearchString) > 0
			select @newSearchString += ' AND ' 
		select @sD = Destination from KeywordMap_Wine (nolock) where Source = @SearchString
		select @newSearchString += case when @sD is null then @SearchString else @sD end
	end else begin
		declare cr CURSOR forward_only fast_forward read_only for
			select Source = f.Item, Destination 
			from dbo.String2Table(@SearchString, ' ') f 
				left join KeywordMap_Wine km (nolock) on km.Source = replace(f.Item, '"' , '')
			where f.Item != '""'

		open cr
		fetch next from cr into @sS, @sD
		while @@fetch_status = 0 begin
			if @sS is NOT NULL begin
				if len(@newSearchString) > 0
					select @newSearchString += ' AND ' 
				select @newSearchString += case when @sD is null then @sS else @sD end
			end
			fetch next from cr into @sS, @sD
		end
		close cr
		deallocate cr
	end
end
-- ===== end of special keywords =====

if @isDebug = 1
	print @newSearchString

--------- Results --------
select -- top(@topNRows) -->> cannot use here because of sorting
	Wine_N_ID, Wine_VinN_ID, Wine_VinN_GroupID,
	locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
	ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID,	VintageID
into #t
from vWineDetails where contains(*, @newSearchString)

if @@rowcount > 100 begin
	if @isDebug = 1
		print '--- Creating Index on #t ---'
	CREATE NONCLUSTERED INDEX [IX_t] ON #t (
		[ColorID] ASC
	) WITH (SORT_IN_TEMPDB = ON);
end

--; with r as (
--	select WineN_ID, 
--		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
--		ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID,	VintageID
--	from vWineDetails where contains(*, @newSearchString)
--)
select top(@topNRows)
	Wine_N_ID = r.Wine_N_ID,
	Wine_VinN_ID = r.Wine_VinN_ID, 
	Wine_VinN_GroupID = r.Wine_VinN_GroupID,
	Country = lc.Name, Region = lr.Name, Location = ll.Name, 
	Locale = lloc.Name, Site = ls.Name,
	Producer = wp.Name, ProducerToShow = wp.NameToShow,
	[Type] = wt.Name, Label = wl.Name,
	Variety = wv.Name, Dryness = wd.Name, Color = wc.Name,
	Vintage = wvin.Name
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
	join dbo.WineVintage wvin (nolock) on r.VintageID = wvin.ID
order by Country, Producer, Type, Label, Vintage

drop table #t

/*
-- CONTAINSTABLE
declare @SS nvarchar(400) = replace(replace(replace(@SearchString, ' AND ', ''), ' OR ', ''), ' ', ' AND ')
select v.* , fts.RANK
from vWineDetails v
	join CONTAINSTABLE(vWineDetails, 
		(Producer,WineType,LabelName,Variety,Dryness,ColorClass,Country,Region,Location,Locale,Site), 
		@SS, @topNRows) fts
	on v.VinN_ID = fts.[KEY]
where fts.RANK > @rankLimit
order by fts.RANK desc

-- FREETEXTTABLE
select v.* , fts.RANK
from vWineDetails v
	join FREETEXTTABLE(vWineDetails, 
		(Producer,WineType,LabelName,Variety,Dryness,ColorClass,Country,Region,Location,Locale,Site), 
		@SearchString, @topNRows) fts
	on v.VinN_ID = fts.[KEY]
where fts.RANK > @rankLimit
order by fts.RANK desc
*/

RETURN 1


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Wine_SearchFT] TO [RP_Customer]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Wine_SearchFT] TO [RP_DataAdmin]
    AS [dbo];

