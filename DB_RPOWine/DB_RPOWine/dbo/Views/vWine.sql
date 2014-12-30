
CREATE VIEW [dbo].[vWine]

AS

select 
	TasteNote_ID = isnull(tn.ID, 0),
	Wine_N_ID = wn.ID,
	Wine_VinN_ID = wn.Wine_VinN_ID,
	IdN = isnull(tn.oldIdN, -((wn.ID * 1000) + isnull(tn.ID,0))),
	
	ArticleID = isnull(tn.oldArticleId, a.ID),	--  + 50000
	ArticleIdNKey = isnull(tn.oldArticleIdNKey, a.ID),	--  + 50000
	BottleSize = isnull(wbs.Name, ''),
	ColorClass = wc.Name,
	Country = lc.Name,
	ClumpName = isnull(tn.oldClumpName, a.FileName),
	Dryness = wd.Name,
	DrinkDate = tn.DrinkDate_Lo,
	DrinkDate_hi = tn.DrinkDate_Hi,
	EstimatedCost = tn.EstimatedCost,
	encodedKeyWords = case
		when tn.ID is NOT NULL and tn.oldEncodedKeyWords is NOT NULL then tn.oldEncodedKeyWords
		else replace(isnull(lc.Name, '') + ' ' + isnull(lr.Name, '') 
			+ ' ' + isnull(ll.Name, '') + ' ' + isnull(lloc.Name, '') + ' ' + isnull(ls.Name,'')
			+ ' ' + isnull(wp.Name, '') + ' ' + isnull(wp.NameToShow, '') 
			+ ' ' + isnull(wt.Name, '') + ' ' + isnull(wl.Name, '')
			+ ' ' + isnull(wv.Name, '') + ' ' + isnull(wd.Name, '') + ' ' + isnull(wc.Name, '')
			+ ' ' + isnull(wvin.Name, ''), '  ', '')
	end,
	fixedId = isnull(tn.oldFixedId, -((wn.ID * 1000) + isnull(tn.ID,0))),
	HasWJTasting = isnull(wn.HasWJTasting, 0),
	HasERPTasting = isnull(wn.HasERPTasting, 0),
	IsActiveWineN = isnull(tn.IsActiveWineN, 0),
	Issue = i.Title,
	IsERPTasting = isnull(tn.oldIsErpTasting, 0),
	IsWJTasting = isnull(tn.oldIsWjTasting, 0),
	IsCurrentlyForSale = isnull(wn.IsCurrentlyForSale, 0),
	IsCurrentlyOnAuction = isnull(wn.IsCurrentlyOnAuction, 0),
	LabelName = wl.Name,
	Location = ll.Name,
	Locale = lloc.Name,
	
	Maturity = dbo.fn_GetWineMaturityID(tn.DrinkDate_Lo, tn.DrinkDate_Hi, wvin.Name),	-- tn.MaturityID,	--wm.Name, 
	
	MostRecentPrice = wn.MostRecentPrice,
	MostRecentPriceHi = wn.MostRecentPriceHi, 
	MostRecentAuctionPrice = wn.MostRecentAuctionPrice,
	Notes = isnull(tn.Notes, '')
			+ case
	          when  ISNULL( te.Notes, '') = '' then ''
	          else  CHAR(13)+CHAR(10)+ CHAR(13)+CHAR(10) + te.Notes
	         end
             + ISNULL(CHAR(13)+CHAR(10)+ CHAR(13)+ CHAR(10) + 'Importer(s): ' + REPLACE((select '+++IMPORTER+++' +  Name 
                     +  case
                          when LEN( isnull(Address,'')) > 0 then (', ' + Address )
                          else ''
                        end   
                     +  case
                          when LEN( isnull(Phone1,'')) > 0 then (', ' + Phone1 )
                          else ''
                        end   
                     +  case
                          when LEN( isnull(URL,'')) > 0 then (', ' + URL)
                          else ''
                        end   
                    from WineImporter wi (nolock)
						join WineProducer_WineImporter wpi (nolock) on wpi.ImporterId  = wi.ID
                    where 
						wpi.ProducerId = wp.ID
                    FOR XML PATH('')), '+++IMPORTER+++', CHAR(13)+CHAR(10) + CHAR(13)+CHAR(10) ),'')	 
                            
	         ,
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
	ReviewerIdN = case
		when tn.oldReviewerIdN is not null then tn.oldReviewerIdN
		when tn.oldReviewerIdN is null and u.FullName is not null and u.FullName = 'NEAL MARTIN' then 2
		when tn.oldReviewerIdN is null and u.FullName is not null and u.FullName != 'NEAL MARTIN' then 1
		else null
	end,
	showForERP = case
		when tn.ID is not null then isnull(tn.oldShowForERP, 0)
		when tn.ID is null and isnull(wn.IsCurrentlyForSale, 0) = 1 then 1
		else 0
	end,
	showForWJ = case
		when tn.ID is not null then isnull(tn.oldShowForWJ, 0)
		when tn.ID is null and isnull(wn.IsCurrentlyForSale, 0) = 1 then 1
		else 0
	end,
	Source = isnull(u.FullName, ''),
	SourceDate = isnull(tn.oldSourceDate, i.PublicationDate),
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
	IssueID = isnull(i.ID, 0),
	
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
	
	left join dbo.WineBottleSize wbs (nolock) on tn.BottleSizeID = wbs.ID
	--left join (
	--	select atn.TasteNoteID, ArticleID=min(atn.ArticleID) 
	--	from dbo.Article_TasteNote atn (nolock) 
	--		join Issue_Article ia (nolock) on atn.ArticleID = ia.ArticleID
	--		join dbo.TasteNote tn (nolock) on atn.TasteNoteID = tn.ID and tn.IssueID = ia.IssueID
	--	group by atn.TasteNoteID
	--) atnMatch on tn.ID = atnMatch.TasteNoteID
	--left join (
	--	select atn.TasteNoteID, ArticleID=min(atn.ArticleID) 
	--	from dbo.Article_TasteNote atn (nolock) 
	--		join dbo.TasteNote tn (nolock) on atn.TasteNoteID = tn.ID
	--	group by atn.TasteNoteID
	--) atnNotMatch on tn.ID = atnMatch.TasteNoteID
	--left join dbo.Article a (nolock) on a.ID = isnull(atnMatch.ArticleID, atnNotMatch.ArticleID)
	left join dbo.Article a (nolock) on a.ID = tn.ArticleID
	
	left join (
		select TNID = ten.TasteNoteID, IssueID = a.IssueID, Notes = min(te.Notes)
		from dbo.TastingEvent te (nolock)
			join dbo.TastingEvent_TasteNote ten (nolock) on ten.TastingEventID = te.ID
			--join dbo.TasteNote tn (nolock) on ten.TasteNoteID = tn.ID
			join dbo.Assignment_TastingEvent ate (nolock) on te.ID = ate.TastingEventID
			join dbo.Assignment a (nolock) on ate.AssignmentID = a.ID --and a.IssueID = tn.IssueID
		group by ten.TasteNoteID, a.IssueID
	) te on tn.ID = te.TNID and tn.IssueID = te.IssueID
	
where (tn.WF_StatusID is null or tn.WF_StatusID > 99)
	and (i.WF_StatusID is null or i.WF_StatusID > 99)