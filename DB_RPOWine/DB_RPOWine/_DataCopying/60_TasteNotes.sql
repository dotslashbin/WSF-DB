-- ======= Taste Notes ========
--
-- Data Source: RPOWineData.dbo
--
--
USE [RPOWine]
GO
print '--------- delete data --------'
GO
truncate table Publication_TasteNote
delete TasteNote

DBCC CHECKIDENT (TasteNote, RESEED, 1)
GO

print '--------- copying data --------'
GO

print '--------- Taste Notes --------'
GO
------- Taste Notes
select --distinct 
	wn.Idn,
	ProducerID = isnull(wp.ID, 0),
	TypeID = isnull(wt.ID, 0),
	LabelID = isnull(wl.ID, 0),
	VarietyID = isnull(wv.ID, 0),
	DrynessID = isnull(wd.ID, 0),
	ColorID = isnull(wc.ID, 0),
	VintageID = isnull(wvin.ID, 0),
	locCountryID = isnull(lc.ID, 0),
	locRegionID = isnull(lr.ID, 0),
	locLocationID = isnull(ll.ID, 0),
	locLocaleID = isnull(lloc.ID, 0),
	locSiteID = isnull(ls.ID, 0),
	Producer = isnull(wn.Producer, ''), WineType = isnull(wn.WineType, ''),
	LabelName = isnull(wn.LabelName, ''), Variety = isnull(wn.Variety, ''),
	Dryness = isnull(wn.Dryness, ''), ColorClass = isnull(wn.ColorClass, ''),
	Country = isnull(wn.Country, ''), Region = isnull(wn.Region, ''),
	Location = isnull(wn.Location, ''), Locale = isnull(wn.Locale, ''), Site = isnull(wn.Site, ''),
	Wine_VinN_ID = 0,
	Wine_N_ID = 0
into #t
from RPOWineData.dbo.Wine wn
	left join WineProducer wp on isnull(wn.Producer, '') = wp.Name
	left join WineType wt on isnull(wn.WineType, '') = wt.Name
	left join WineLabel wl on isnull(wn.LabelName, '') = wl.Name
	left join WineVariety wv on isnull(wn.Variety, '') = wv.Name
	left join WineDryness wd on isnull(wn.Dryness, '') = wd.Name
	left join WineColor wc on isnull(wn.ColorClass, '') = wc.Name
	left join WineVintage wvin on isnull(wn.Vintage, '') = wvin.Name
		
	left join LocationCountry lc on isnull(wn.Country, '') = lc.Name
	left join LocationRegion lr on isnull(wn.Region, '') = lr.Name
	left join LocationLocation ll on isnull(wn.Location, '') = ll.Name
	left join LocationLocale lloc on isnull(wn.Locale, '') = lloc.Name
	left join LocationSite ls on isnull(wn.Site, '') = ls.Name

update #t set 
	Wine_VinN_ID = v.ID,
	Wine_N_ID = wn.ID
from #t
	join Wine_VinN v on #t.ProducerID = v.ProducerID and #t.TypeID = v.TypeID 
		and #t.LabelID = v.LabelID and #t.VarietyID = v.VarietyID
		and #t.DrynessID = v.DrynessID and #t.ColorID = v.ColorID
		and #t.locCountryID = v.locCountryID and #t.locRegionID = v.locRegionID
		and #t.locLocationID = v.locLocationID and #t.locLocaleID = v.locLocaleID
		and #t.locSiteID = v.locSiteID
	join Wine_N wn on v.ID = wn.Wine_VinN_ID and #t.VintageID = wn.VintageID
		
---- checking consistency
if exists(select * from #t where Wine_VinN_ID = 0 or Wine_N_ID = 0) begin
	print '-- ERROR: Missing Wine_N_ID!'
	select * from #t where Wine_VinN_ID = 0 or Wine_N_ID = 0
end else begin
	insert into TasteNote (ReviewerID, Wine_N_ID, ProducerNoteID, TasteDate, MaturityID,
		Rating_Lo, Rating_Hi, DrinkDate_Lo, DrinkDate_Hi, IsBarrelTasting, oldIdn, Notes, 
		WF_StatusID, PublicationDate)
	select 
		ReviewerID = isnull(r.ID, 0), 
		Wine_N_ID = Wine_N_ID, 
		ProducerNoteID = NULL, 
		TasteDate = w.tasteDate,
		MaturityID = isnull(w.Maturity, -1), 
		Rating_Lo = w.Rating, 
		Rating_Hi = w.Rating_Hi, 
		DrinkDate_Lo = w.DrinkDate,	
		DrinkDate_Hi = w.DrinkDate_Hi, 
		IsBarrelTasting = IsBarrelTasting, 
		oldIdn = #t.Idn,
		Notes = w.Notes,
		WF_StatusID = 100,
		PublicationDate = w.SourceDate
	from RPOWineData.dbo.Wine w (nolock)
		left join Reviewer r on w.Source = r.Name
		join #t on w.Idn = #t.Idn
end

drop table #t
GO

---------- Publication_TasteNote
-- stat
--select showForERP, showForWJ, isErpTasting, isWjTasting, cnt=count(*)
--from RPOWineData.dbo.Wine 
--group by showForERP, showForWJ, isErpTasting, isWjTasting
--order by showForERP, showForWJ, isErpTasting, isWjTasting

print '--------- Publication_TasteNote --------'
GO
/* ----- incorrect version - those fields should be ignorted -----
declare @pubID int

print '--- eRP ---'
select @pubID = ID from Publication where Name = 'eRobertParker.com'
if @pubID is NOT NULL begin
	insert into Publication_TasteNote (PublicationID, TasteNoteID)
	select PublicationID=@pubID, TasteNoteID=t.ID
	from TasteNote t 
		join RPOWineData.dbo.Wine w on t.oldIdn = w.Idn
	where w.showForERP = 1
end

print '--- WJ ---'
select @pubID = ID from Publication where Name = 'Wine Journal'
if @pubID is NOT NULL begin
	insert into Publication_TasteNote (PublicationID, TasteNoteID)
	select PublicationID=@pubID, TasteNoteID=t.ID
	from TasteNote t 
		join RPOWineData.dbo.Wine w on t.oldIdn = w.Idn
	where w.showForWJ = 1
end
GO
*/
; with r as (
	select 
		Idn,
		PubName = case
			when Publication like '%robertpark%' then 'eRobertParker.com'
			when Publication like 'Executive Wine Seminar%' then 'Executive Wine Seminar'
			else Publication
		end
	from RPOWineData.dbo.Wine
)
insert into Publication_TasteNote (PublicationID, TasteNoteID)
select 
	PublicationID = p.ID, 
	TasteNoteID = tn.ID
from r
	join Publication p on r.PubName = p.Name
	join TasteNote tn on r.Idn = tn.oldIdn
GO

print 'Done.'
GO