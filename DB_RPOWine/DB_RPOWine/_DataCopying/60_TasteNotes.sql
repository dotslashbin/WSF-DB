-- ======= Taste Notes ========
--
-- Data Source: RPOWineData.dbo
--
--
USE [RPOWine]
GO
--print '--------- deleting data --------'
--GO
--truncate table Issue_TasteNote
--truncate table Publication_TasteNote
--delete TasteNote
--delete Issue
--DBCC CHECKIDENT (Issue, RESEED, 1)
--DBCC CHECKIDENT (TasteNote, RESEED, 1)
--GO
print '--------- copying data --------'
GO
print '--------- Get Data Ready --------'
GO
select distinct 
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
	locPlacesID = isnull(lp.ID, 0),
	
	Producer = isnull(wn.Producer, ''), WineType = isnull(wn.WineType, ''),
	LabelName = isnull(wn.LabelName, ''), Variety = isnull(wn.Variety, ''),
	Dryness = isnull(wn.Dryness, ''), ColorClass = isnull(wn.ColorClass, ''),
	Country = isnull(wn.Country, ''), Region = isnull(wn.Region, ''),
	Location = isnull(wn.Location, ''), Locale = isnull(wn.Locale, ''), 
	Site = isnull(wn.Site, ''), Places = isnull(wn.Places, ''),
	Wine_VinN_ID = 0,
	Wine_N_ID = 0,
	
	PublicationID = isnull(p.ID, 1),
	Issue = isnull(wn.Issue, 'Lost & Found'),
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
	left join LocationPlaces lp on isnull(wn.Places, '') = lp.Name

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
	insert into Issue(PublicationID, Title, CreatedDate, PublicationDate, WF_StatusID)
	select distinct 
		#t.PublicationID,
		Title = #t.Issue,
		CreatedDate = min(isnull(#t.PublicationDate, '1/1/2000')),
		PublicationDate = min(isnull(#t.PublicationDate, '1/1/2000')),
		WF_StatusID = 100
	from #t
		left join Issue i on #t.PublicationID = i.PublicationID and #t.Issue = i.Title
	where len(isnull(Issue,'')) > 0 and i.ID is NULL
	group by #t.PublicationID, #t.Issue
--select * from Issue where Title = '210'
	
	print '--------- Taste Notes --------'
	insert into TasteNote (UserId, Wine_N_ID, IssueID, TastingEventID, locPlacesID, TasteDate, MaturityID,
		Rating_Lo, Rating_Hi, DrinkDate_Lo, DrinkDate_Hi, IsBarrelTasting, Notes, 
		oldIdn, oldFixedId, oldClumpName, oldEncodedKeyWords, oldReviewerIdN, oldIsErpTasting, oldIsWjTasting,
		oldShowForERP, oldShowForWJ, oldSourceDate,
		WF_StatusID)
	select distinct
		UserId = isnull(u.UserId, isnull(u2.UserId, 0)), 
		Wine_N_ID = #t.Wine_N_ID, 
		IssueID = i.ID, 
		TastingEventID = NULL, 
		locPlacesID = #t.locPlacesID, 
		TasteDate = w.tasteDate,
		MaturityID = isnull(w.Maturity, -1), 
		Rating_Lo = w.Rating, 
		Rating_Hi = w.Rating_Hi, 
		DrinkDate_Lo = w.DrinkDate,	
		DrinkDate_Hi = w.DrinkDate_Hi, 
		IsBarrelTasting = IsBarrelTasting, 
		Notes = w.Notes,
		oldIdn = #t.Idn,
		oldFixedId = #t.FixedId,
		oldClumpName = w.clumpName, 
		oldEncodedKeyWords = w.encodedKeyWords, 
		oldReviewerIdN = w.ReviewerIdN, 
		oldIsErpTasting = w.isErpTasting, 
		oldIsWjTasting = w.isWjTasting,
		oldShowForERP = w.showForERP, 
		oldShowForWJ = w.showForWJ, 
		oldSourceDate = w.SourceDate,
		WF_StatusID = 100
		--oldPublicationDate = w.SourceDate
	from RPOWineData.dbo.Wine w (nolock)
		join #t on w.Idn = #t.Idn
		join Issue i (nolock) on #t.PublicationID = i.PublicationID and #t.Issue = i.Title
		left join Users u on isnull(w.Source, '') != '' and u.FullName = case 
			when w.Source = 'Robert Parker' then 'Robert M. Parker, Jr.' 
			when w.Source = 'Jay Miller' then 'Jay S Miller' 
			else w.Source 
		end
		left join (
			select FixedId = m.fixedId, UserId = max(u.UserId)
			from RPOWineData.dbo.tocMap m
				join RPOWineData.dbo.Articles a on a.idN = m.idN
				join Users u on isnull(a.Source, '') != '' and u.FullName = case
					when a.Source = 'Robert Parker' then 'Robert M. Parker, Jr.' 
					when a.Source = 'Jay Miller' then 'Jay S Miller' 
					else a.Source 
				end
			group by m.fixedId
		) u2 on #t.FixedId = u2.FixedId

	print '------------ Completeness Check ------------'
	declare @tnSource int, @tnDest int

	-- TasteNote
	select @tnSource = count(*) from RPOWineData.dbo.Wine
	select @tnDest = count(*) from TasteNote

	if @tnSource != @tnDest
		select 'TasteNote - ERROR: Total # of TasteNote on a source is different than on a target'
	else
		select 'Wine_VinN - SUCCESS!!!'
	select Source = @tnSource, Destination = @tnDest

	print '--------- Publication_TasteNote - 278788 -------'
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
		join Issue i (nolock) on #t.PublicationID = i.PublicationID and #t.Issue = i.Title
	where len(isnull(#t.Issue, '')) > 0
	
end

drop table #t
GO

print 'Done.'
GO
