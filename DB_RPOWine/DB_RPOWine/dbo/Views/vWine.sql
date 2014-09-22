

CREATE VIEW [dbo].[vWine]

AS

select 
	TasteNote_ID = isnull(tn.ID, 0),
	Wine_N_ID = wn.ID,
	Wine_VinN_ID = wn.Wine_VinN_ID,
	IdN = isnull(tn.oldIdN, -((wn.ID * 1000) + isnull(tn.ID,0))),
	
	articleID = tn.oldArticleId,
	articleIdNKey = tn.oldArticleIdNKey,
	ColorClass = wc.Name,
	Country = lc.Name,
	ClumpName = tn.oldClumpName,
	Dryness = wd.Name,
	DrinkDate = tn.DrinkDate_Lo,
	DrinkDate_hi = tn.DrinkDate_Hi,
	EstimatedCost = tn.EstimatedCost,
	encodedKeyWords = case
		when tn.ID is NOT NULL and len(isnull(tn.oldEncodedKeyWords, '')) > 1 then tn.oldEncodedKeyWords
		else replace(isnull(lc.Name, '') + ' ' + isnull(lr.Name, '') 
			+ ' ' + isnull(ll.Name, '') + ' ' + isnull(lloc.Name, '') + ' ' + isnull(ls.Name,'')
			+ ' ' + isnull(wp.Name, '') + ' ' + isnull(wp.NameToShow, '') 
			+ ' ' + isnull(wt.Name, '') + ' ' + isnull(wl.Name, '')
			+ ' ' + isnull(wv.Name, '') + ' ' + isnull(wd.Name, '') + ' ' + isnull(wc.Name, '')
			+ ' ' + isnull(wvin.Name, ''), '  ', '')
	end,
	fixedId = isnull(tn.oldFixedId, -((wn.ID * 1000) + isnull(tn.ID,0))),
	HasWJTasting = wn.HasWJTasting,
	HasERPTasting = wn.HasERPTasting,
	IsActiveWineN = isnull(tn.IsActiveWineN, 0),
	Issue = i.Title,
	IsERPTasting = tn.oldIsErpTasting, 
	IsWJTasting = tn.oldIsWjTasting, 
	IsCurrentlyForSale = wn.IsCurrentlyForSale,
	IsCurrentlyOnAuction = wn.IsCurrentlyOnAuction,
	LabelName = wl.Name,
	Location = ll.Name,
	Locale = lloc.Name,
	Maturity = tn.MaturityID,	--wm.Name, 
	MostRecentPrice = wn.MostRecentPrice,
	MostRecentPriceHi = wn.MostRecentPriceHi, 
	MostRecentAuctionPrice = wn.MostRecentAuctionPrice,
	Notes = tn.Notes,
	Producer = wp.Name,
	ProducerShow = wp.NameToShow,
	ProducerURL = wp.WebSiteURL,
	ProducerProfileFileName = wp.ProfileFileName,
	ShortTitle = null,	--isnull(a.ShortTitle, a.Title),
	Publication = p.Name, 
	Places = isnull(lp.Name, ''),
	Region = lr.Name,
	Rating = tn.Rating_Lo, 
	RatingShow = 
		case when isnull(tn.IsBarrelTasting, 0) = 1 then '(' else '' end +
		+ case
			when isnull(tn.Rating_Lo, 0) > 0 and isnull(tn.Rating_Hi, 0) > 0
				then cast(tn.Rating_Lo as varchar(20)) + '-' + cast(tn.Rating_Hi as varchar(20))
			when isnull(tn.Rating_Lo, 0) > 0 and isnull(tn.Rating_Hi, 0) = 0 then cast(tn.Rating_Lo as varchar(20))
			when isnull(tn.Rating_Lo, 0) = 0 and isnull(tn.Rating_Hi, 0) > 0 then '?-' + cast(tn.Rating_Hi as varchar(20))
			else ''
		end
		+ isnull(tn.RatingQ, '')
		+ case when isnull(tn.IsBarrelTasting, 0) = 1 then ')' else '' end
	, 
	ReviewerIdN = tn.oldReviewerIdN,
	showForERP = tn.oldShowForERP, 
	showForWJ = tn.oldShowForWJ,
	Source = isnull(u.FullName, ''),
	SourceDate = tn.oldSourceDate,
	Site = lc.Name,
	Vintage = wvin.Name,
	Variety = wv.Name,
	VinN = wn.Wine_VinN_ID,
	WineN = wn.ID, 
	WineType = wt.Name,
	oldIdn = tn.oldIdn,
	oldWineN = isnull(wn.oldWineN, 250000 + wn.ID),	-- wn.oldWineN,
	oldVinN = isnull(wn.oldVinN, 250000 + wn.Wine_VinN_ID),		-- wn.oldVinN, 
	
	wProducerID = wp.ID,
	wTypeID = wt.ID,
	wLabelID = wl.ID,
	wVarietyID = wv.ID,
	wDrynessID = wd.ID,
	wColorID = wc.ID,
	wVintageID = wvin.ID,
	
	RV_TasteNote = isnull(tn.RV, 0x00),
	RV_Wine_N = wn.RV
from 
	dbo.Wine_N wn (nolock) 
	join dbo.Wine_VinN vn (nolock) on wn.Wine_VinN_ID = vn.ID
	join dbo.WineProducer wp (nolock) on vn.ProducerID = wp.ID
	join dbo.WineType wt (nolock) on vn.TypeID = wt.ID
	join dbo.WineLabel wl (nolock) on vn.LabelID = wl.ID
	join dbo.WineVariety wv (nolock) on vn.VarietyID = wv.ID
	join dbo.WineDryness wd (nolock) on vn.DrynessID = wd.ID
	join dbo.WineColor wc (nolock) on vn.ColorID = wc.ID
	join dbo.WineVintage wvin (nolock) on wn.VintageID = wvin.ID

	join dbo.LocationCountry lc (nolock) on vn.locCountryID = lc.ID
	join dbo.LocationRegion lr (nolock) on vn.locRegionID = lr.ID
	join dbo.LocationLocation ll (nolock) on vn.locLocationID = ll.ID
	join dbo.LocationLocale lloc (nolock) on vn.locLocaleID = lloc.ID
	join dbo.LocationSite ls (nolock) on vn.locSiteID = ls.ID

	left join dbo.TasteNote tn (nolock) on wn.ID = tn.Wine_N_ID
	left join dbo.Issue i (nolock) on tn.IssueID = i.ID
	left join dbo.Publication p (nolock) on i.PublicationID = p.ID
	left join dbo.Users u (nolock) on tn.UserId = u.UserId
	left join dbo.LocationPlaces lp (nolock) on tn.locPlacesID = lp.ID
	
where (tn.WF_StatusID is null or tn.WF_StatusID > 99)
	and (i.WF_StatusID is null or i.WF_StatusID > 99)