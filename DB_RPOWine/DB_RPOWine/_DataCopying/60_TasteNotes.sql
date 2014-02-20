-- ======= Taste Notes ========
--
-- Data Source: RPOWineData.dbo
--
--
USE [RPOWine]
GO
print '--------- copying data --------'
GO
print '----- TastingEvent -----'
GO
BEGIN TRAN
	set identity_insert TastingEvent on
	insert into TastingEvent (ID, ParentID, UserId, Title)
	values (0, 0, 0, 'Root')
	set identity_insert TastingEvent off
COMMIT TRAN
GO

print '--------- Get Data Ready --------'
GO
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
	Wine_N_ID = 0,
	
	PublicationID = isnull(p.ID, 1),
	Issue = wn.Issue,
	PublicationDate = wn.SourceDate,
	ArticleId = wn.ArticleId,
	ArticleIdNKey = wn.ArticleIdNKey,
	FixedId = wn.FixedId,
	ArticleClumpName = wn.clumpName,
	ArticlePages = wn.Pages
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

	left join Publication p on p.Name = case
		when Publication like '%robertpark%' then 'eRobertParker.com'
		when Publication like 'Executive Wine Seminar%' then 'Executive Wine Seminar'
		else Publication
	end

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
	print '--------- Issues --------'
	insert into Issue(PublicationID, Title, CreatedDate, PublicationDate)
	select distinct 
		PublicationID,
		Title = Issue,
		CreatedDate = min(isnull(PublicationDate, '1/1/2000')),
		PublicationDate = min(isnull(PublicationDate, '1/1/2000'))
	from #t
	where len(isnull(Issue,'')) > 0
	group by PublicationID, Issue
	
	print '--------- Taste Notes --------'
	insert into TasteNote (UserId, Wine_N_ID, TastingEventID, TasteDate, MaturityID,
		Rating_Lo, Rating_Hi, DrinkDate_Lo, DrinkDate_Hi, IsBarrelTasting, oldIdn, Notes, 
		WF_StatusID)
	select 
		UserId = isnull(u.UserId, 0), 
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
		WF_StatusID = 100
		--oldPublicationDate = w.SourceDate
	from RPOWineData.dbo.Wine w (nolock)
		left join Users u on w.Source = u.FullName
		join #t on w.Idn = #t.Idn

	print '--------- Publication_TasteNote --------'
	insert into Publication_TasteNote (PublicationID, TasteNoteID)
	select 
		PublicationID = #t.PublicationID, 
		TasteNoteID = tn.ID
	from #t
		join TasteNote tn on #t.Idn = tn.oldIdn

	print '--------- Issue_TasteNote --------'
	insert into Issue_TasteNote (IssueID, TasteNoteID, oldArticleIdNKey, oldArticleId, oldArticleClumpName, oldPages, oldFixedId)
	select 
		IssueID = i.ID, 
		TasteNoteID = tn.ID, 
		oldArticleIdNKey = #t.ArticleIdNKey, 
		oldArticleId = #t.ArticleId, 
		oldArticleClumpName = #t.ArticleClumpName, 
		oldPages = #t.ArticlePages,
		oldFixedId = #t.FixedId
	from #t
		join TasteNote tn (nolock) on #t.Idn = tn.oldIdn
		join Issue i (nolock) on #t.Issue = i.Title
	where len(isnull(#t.Issue, '')) > 0

end

drop table #t
GO

print 'Done.'
GO
