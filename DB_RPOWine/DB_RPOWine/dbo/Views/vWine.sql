CREATE VIEW [dbo].[vWine]
  

AS

select 
	TasteNote_ID = tn.ID,
	Wine_N_ID = tn.Wine_N_ID,
	Wine_VinN_ID = wn.Wine_VinN_ID,
	
	articleID = tn.oldArticleId,
	articleIdNKey = tn.oldArticleIdNKey,
	ColorClass = wc.Name,
	Country = lc.Name,
	ClumpName = tn.oldClumpName,
	Dryness = wd.Name,
	DrinkDate = tn.DrinkDate_Lo,
	DrinkDate_hi = tn.DrinkDate_Hi,
	EstimatedCost = tn.EstimatedCost,
	encodedKeyWords = tn.oldEncodedKeyWords,
	fixedId = tn.oldFixedId,
	HasWJTasting = wn.HasWJTasting,
	IsActiveWineN = isnull(tn.IsActiveWineN, wn.IsActiveWineN),
	Issue = i.Title,
	IsERPTasting = tn.oldIsErpTasting, 
	IsWJTasting = tn.oldIsWjTasting, 
	IsCurrentlyForSale = wn.IsCurrentlyForSale,
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
		case when tn.IsBarrelTasting = 1 then '(' else '' end +
		+ case
			when tn.Rating_Lo is NOT NULL and tn.Rating_Hi is NOT NULL 
				then cast(tn.Rating_Lo as varchar(20)) + '-' + cast(tn.Rating_Hi as varchar(20))
			when tn.Rating_Lo is NOT NULL and tn.Rating_Hi is NULL then cast(tn.Rating_Lo as varchar(20))
			when tn.Rating_Lo is NULL and tn.Rating_Hi is NOT NULL then '?-' + cast(tn.Rating_Hi as varchar(20))
			else ''
		end
		+ isnull(tn.RatingQ, '')
		+ case when tn.IsBarrelTasting = 1 then ')' else '' end
	, 
	ReviewerIdN = tn.oldReviewerIdN,
	showForERP = tn.oldShowForERP, 
	showForWJ = tn.oldShowForWJ,
	source = isnull(u.FullName, ''),
	SourceDate = tn.oldSourceDate,
	Site = lc.Name,
	Vintage = wvin.Name,
	Variety = wv.Name,
	VinN = wn.Wine_VinN_ID,
	WineN = wn.ID, 
	WineType = wt.Name,
	oldIdn = tn.oldIdn,
	oldWineN = wn.oldWineN,
	oldVinN = wn.oldVinN
from dbo.TasteNote tn 
	join dbo.Issue i on tn.IssueID = i.ID
	join dbo.Publication p on i.PublicationID = p.ID
	join dbo.Users u on tn.UserId = u.UserId
	join dbo.LocationPlaces lp on tn.locPlacesID = lp.ID

	join dbo.Wine_N wn on wn.ID = tn.Wine_N_ID
	join dbo.Wine_VinN vn on wn.Wine_VinN_ID = vn.ID
	join dbo.WineProducer wp on vn.ProducerID = wp.ID
	join dbo.WineType wt on vn.TypeID = wt.ID
	join dbo.WineLabel wl on vn.LabelID = wl.ID
	join dbo.WineVariety wv on vn.VarietyID = wv.ID
	join dbo.WineDryness wd on vn.DrynessID = wd.ID
	join dbo.WineColor wc on vn.ColorID = wc.ID
	join dbo.WineVintage wvin on wn.VintageID = wvin.ID

	join dbo.LocationCountry lc on vn.locCountryID = lc.ID
	join dbo.LocationRegion lr on vn.locRegionID = lr.ID
	join dbo.LocationLocation ll on vn.locLocationID = ll.ID
	join dbo.LocationLocale lloc on vn.locLocaleID = lloc.ID
	join dbo.LocationSite ls on vn.locSiteID = ls.ID

where tn.WF_StatusID > 99 and i.WF_StatusID > 99