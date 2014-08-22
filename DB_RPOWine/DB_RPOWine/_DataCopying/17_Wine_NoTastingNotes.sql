-- ======= Wine ========
--
-- Data Source: RPOWineDataD.dbo
--
--
USE [RPOWine]
GO
print '---------- Loading Data... ------------'
GO
select
	ProducerID = isnull(wp.ID, 0), ProducerName = max(isnull(isnull(wan.erpProducer,wan.Producer), '')),
	TypeID = isnull(wt.ID, 0), TypeName = max(isnull(isnull(wan.erpWineType, wan.WineType), '')),
	LabelID = isnull(wl.ID, 0), LabelName = max(isnull(wan.LabelName, '')),
	VarietyID = isnull(wv.ID, 0), VarietyName = max(isnull(wan.Variety, '')),
	DrynessID = isnull(wd.ID, 0), DrynessName = max(isnull(wan.Dryness, '')),
	ColorID = isnull(wc.ID, 0), ColorName = max(isnull(wan.ColorClass, '')),
	VintageID = isnull(wvin.ID, 0), VintageName = max(isnull(sd.Vintage, '')),
	locCountryID = isnull(lc.ID, 0), locCountry = max(isnull(wan.Country, '')),
	locRegionID = isnull(lr.ID, 0), locRegion = max(isnull(wan.Region, '')),
	locLocationID = isnull(ll.ID, 0), locLocation = max(isnull(wan.Location, '')),
	--locLocaleID = isnull(lloc.ID, 0), locLocale = max(isnull(wn.Locale, '')),
	--locSiteID = isnull(ls.ID, 0), locSite = max(isnull(wn.Site, '')),
	
	--EstimatedCost = 0, 
	MostRecentPrice = min(case when sd.isAuction = 1 then null else sd.DollarsPer750Bottle end), 
	MostRecentPriceHi = max(case when sd.isAuction = 1 then null else sd.DollarsPer750Bottle end), 
	MostRecentPriceCnt = sum(case when sd.isAuction = 1 then 0 else 1 end),
	MostRecentAuctionPrice = min(case when sd.isAuction = 0 then null else sd.DollarsPer750Bottle end), 
	MostRecentAuctionPriceHi = max(case when sd.isAuction = 0 then null else sd.DollarsPer750Bottle end), 
	MostRecentAuctionPriceCnt = sum(case when sd.isAuction = 0 then 0 else 1 end), 
	hasWJTasting = cast(0 as smallint), 
	hasERPTasting = cast(0 as smallint), 
	IsActiveWineN = cast(0 as smallint), 
	IsCurrentlyForSale = cast(max(case when isnull(sd.DollarsPer750Bottle, 0) > 0 then 1 else 0 end) as smallint),
	IsCurrentlyOnAuction = cast(max(case when sd.isAuction = 0 then 0 else 1 end) as smallint)
into #t
from eRPSearchD.dbo.WAName wan
	join eRPSearchD.dbo.ForSaleDetail sd on sd.Wid = wan.Wid

	left join WineProducer wp on isnull(isnull(wan.erpProducer,wan.Producer), '') = wp.Name
	left join WineType wt on isnull(isnull(wan.erpWineType, wan.WineType), '') = wt.Name
	left join WineLabel wl on isnull(wan.LabelName, '') = wl.Name
	left join WineVariety wv on isnull(wan.Variety, '') = wv.Name
	left join WineDryness wd on isnull(wan.Dryness, '') = wd.Name
	left join WineColor wc on isnull(wan.ColorClass, '') = wc.Name
	left join WineVintage wvin on isnull(sd.Vintage, '') = wvin.Name
	
	left join LocationCountry lc on isnull(wan.Country, '') = lc.Name
	left join LocationRegion lr on isnull(wan.Region, '') = lr.Name
	left join LocationLocation ll on isnull(wan.Location, '') = ll.Name
	--left join LocationLocale lloc on isnull(wan.Locale, '') = lloc.Name
	--left join LocationSite ls on isnull(wan.Site, '') = ls.Name
--where wan.Wine_VinN_ID is NULL	-- only new stuff
where isnull(sd.DollarsPer750Bottle, 0) > 0		-- only stuff with prices
group by 
	isnull(wp.ID, 0), isnull(wt.ID, 0), isnull(wl.ID, 0), isnull(wv.ID, 0), 
	isnull(wd.ID, 0), isnull(wc.ID, 0), isnull(wvin.ID, 0),
	isnull(lc.ID, 0), isnull(lr.ID, 0), isnull(ll.ID, 0)
	--, isnull(lloc.ID, 0), isnull(ls.ID, 0)

------------- VinN
begin tran
	--set identity_insert Wine_VinN on
	insert into Wine_VinN (	--ID, 
		GroupID,
		ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID, 
		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
		WF_StatusID, oldVinN)
	select --distinct 
		GroupID = 0,
		#t.ProducerID, #t.TypeID, #t.LabelID, #t.VarietyID, #t.DrynessID, #t.ColorID, 
		#t.locCountryID, #t.locRegionID, #t.locLocationID, 0, 0,
		WF_StatusID = 100, oldVinN = 0
	--select #t.ProducerName, #t.TypeName, #t.ColorName, #t.DrynessName, #t.LabelName, #t.VarietyName,
	--	#t.locCountry, #t.locRegion, #t.locLocation
	from #t
		left join Wine_VinN vin on #t.ProducerID = vin.ProducerID
			and #t.TypeID = vin.TypeID and #t.LabelID = vin.LabelID and #t.VarietyID = vin.VarietyID
			and #t.DrynessID = vin.DrynessID and #t.ColorID = vin.ColorID 
			and #t.locCountryID = vin.locCountryID and #t.locRegionID = vin.locRegionID 
			and #t.locLocationID = vin.locLocationID and vin.locLocaleID = 0 and vin.locSiteID = 0
	where vin.ID is NULL
	--group by #t.ProducerName, #t.TypeName, #t.ColorName, #t.DrynessName, #t.LabelName, #t.VarietyName,
	--	#t.locCountry, #t.locRegion, #t.locLocation
	group by #t.ProducerID, #t.TypeID, #t.LabelID, #t.VarietyID, #t.DrynessID, #t.ColorID, 
		#t.locCountryID, #t.locRegionID, #t.locLocationID
	--set identity_insert Wine_VinN off
	--rollback tran
commit tran

-------- WineN
begin tran
	insert into Wine_N (Wine_VinN_ID,VintageID, oldIdn,oldEntryN,oldFixedId,oldWineNameIdN, oldWineN, oldVinN, WF_StatusID,
		MostRecentPrice, MostRecentPriceHi, MostRecentPriceCnt, MostRecentAuctionPrice, MostRecentAuctionPriceHi, 
		MostRecentAuctionPriceCnt, hasWJTasting, hasERPTasting, IsCurrentlyForSale, IsCurrentlyOnAuction)
	select 
		VinNID = v.ID,
		VintageID = #t.VintageID, 
		oldIdn = NULL,
		oldEntryN = NULL,
		oldFixedId = NULL,
		oldWineNameIdN = NULL, 
		oldWineN = NULL,
		oldVinN = NULL,
		WF_StatusID = 100,
		#t.MostRecentPrice, #t.MostRecentPriceHi, #t.MostRecentPriceCnt, #t.MostRecentAuctionPrice, #t.MostRecentAuctionPriceHi, 
		#t.MostRecentAuctionPriceCnt, #t.hasWJTasting, #t.hasERPTasting, #t.IsCurrentlyForSale, #t.IsCurrentlyOnAuction
	--select #t.ProducerName, #t.TypeName, #t.ColorName, #t.DrynessName, #t.LabelName, #t.VarietyName, #t.VintageName, 
	--	#t.locCountry, #t.locRegion, #t.locLocation,
	--	#t.MostRecentPrice, #t.MostRecentPriceHi, #t.MostRecentPriceCnt, #t.MostRecentAuctionPrice, #t.MostRecentAuctionPriceHi, #t.MostRecentAuctionPriceCnt
	from #t
		join Wine_VinN v on #t.ProducerID = v.ProducerID and #t.TypeID = v.TypeID 
			and #t.LabelID = v.LabelID and #t.VarietyID = v.VarietyID
			and #t.DrynessID = v.DrynessID and #t.ColorID = v.ColorID
			and #t.locCountryID = v.locCountryID and #t.locRegionID = v.locRegionID
			and #t.locLocationID = v.locLocationID 
			--and #t.locLocaleID = v.locLocaleID and #t.locSiteID = v.locSiteID
		left join Wine_N w on w.Wine_VinN_ID = v.ID and w.VintageID = #t.VintageID
	where w.ID is NULL
	group by v.ID, #t.VintageID,
		#t.MostRecentPrice, #t.MostRecentPriceHi, #t.MostRecentPriceCnt, #t.MostRecentAuctionPrice, #t.MostRecentAuctionPriceHi, 
		#t.MostRecentAuctionPriceCnt, #t.hasWJTasting, #t.hasERPTasting, #t.IsCurrentlyForSale, #t.IsCurrentlyOnAuction
	--rollback tran
commit tran

drop table #t

print 'Done.'
GO

