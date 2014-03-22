-- ======= Wine ========
--
-- Data Source: RPOWineData.dbo
--
--
USE [RPOWine]
GO
print '---------- Loading Data... ------------'
GO
select
	ProducerID = isnull(wp.ID, 0), ProducerName = max(isnull(wn.Producer, '')),
	TypeID = isnull(wt.ID, 0), TypeName = max(isnull(wn.WineType, '')),
	LabelID = isnull(wl.ID, 0), LabelName = max(isnull(wn.LabelName, '')),
	VarietyID = isnull(wv.ID, 0), VarietyName = max(isnull(wn.Variety, '')),
	DrynessID = isnull(wd.ID, 0), DrynessName = max(isnull(wn.Dryness, '')),
	ColorID = isnull(wc.ID, 0), ColorName = max(isnull(wn.ColorClass, '')),
	VintageID = isnull(wvin.ID, 0), VintageName = max(isnull(wn.Vintage, '')),
	locCountryID = isnull(lc.ID, 0), locCountry = max(isnull(wn.Country, '')),
	locRegionID = isnull(lr.ID, 0), locRegion = max(isnull(wn.Region, '')),
	locLocationID = isnull(ll.ID, 0), locLocation = max(isnull(wn.Location, '')),
	locLocaleID = isnull(lloc.ID, 0), locLocale = max(isnull(wn.Locale, '')),
	locSiteID = isnull(ls.ID, 0), locSite = max(isnull(wn.Site, '')),
	
	oldIdn = max(wn.Idn),
	oldEntryN = max(wn.EntryN),
	oldFixedId = max(wn.FixedId),
	oldWineNameIdN = max(wn.WineNameIdN),
	DateUpdated = max(case when isnull(IsActiveWineN, 1) = 1 then wn.DateUpdated else '1/1/2000' end),

	EstimatedCost = max(EstimatedCost), 
	MostRecentPrice = max(MostRecentPrice), 
	MostRecentPriceHi = max(MostRecentPriceHi), 
	MostRecentPriceCnt = max(MostRecentPriceCnt),
	MostRecentAuctionPrice = max(MostRecentAuctionPrice), 
	MostRecentAuctionPriceHi = max(MostRecentAuctionPriceHi), 
	MostRecentAuctionPriceCnt = max(MostRecentAuctionPriceCnt), 
	hasWJTasting = max(cast(hasWJTasting as smallint)), 
	hasERPTasting = max(cast(hasERPTasting as smallint)), 
	IsActiveWineN = max(cast(IsActiveWineN as smallint)), 
	IsCurrentlyForSale = max(cast(IsCurrentlyForSale as smallint)),
	IsCurrentlyOnAuction = max(cast(IsCurrentlyOnAuction as smallint))
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
--where isnull(IsActiveWineN, 1) = 1
group by 
	isnull(wp.ID, 0), isnull(wt.ID, 0), isnull(wl.ID, 0), isnull(wv.ID, 0), 
	isnull(wd.ID, 0), isnull(wc.ID, 0), isnull(wvin.ID, 0),
	isnull(lc.ID, 0), isnull(lr.ID, 0), isnull(ll.ID, 0), isnull(lloc.ID, 0), isnull(ls.ID, 0)

------------- VinN
begin tran
	--set identity_insert Wine_VinN on
	insert into Wine_VinN (	--ID, 
		GroupID,
		ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID, 
		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
		WF_StatusID)
	select distinct 
		GroupID = 0,
		ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID, 
		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
		WF_StatusID = 100
	from #t
	--set identity_insert Wine_VinN off
	--rollback tran
commit tran

-------- WineN
begin tran
	insert into Wine_N (Wine_VinN_ID,VintageID, oldIdn,oldEntryN,oldFixedId,oldWineNameIdN, WF_StatusID,
		EstimatedCost, MostRecentPrice, MostRecentPriceHi, MostRecentPriceCnt, MostRecentAuctionPrice, MostRecentAuctionPriceHi, 
		MostRecentAuctionPriceCnt, hasWJTasting, hasERPTasting, IsActiveWineN, IsCurrentlyForSale, IsCurrentlyOnAuction)
	select 
		VinNID = v.ID,
		VintageID = #t.VintageID, 
		oldIdn = max(oldIdn),
		oldEntryN = max(oldEntryN),
		oldFixedId = max(oldFixedId),
		oldWineNameIdN = max(oldWineNameIdN), 
		WF_StatusID = 100,
		#t.EstimatedCost, #t.MostRecentPrice, #t.MostRecentPriceHi, #t.MostRecentPriceCnt, #t.MostRecentAuctionPrice, #t.MostRecentAuctionPriceHi, 
		#t.MostRecentAuctionPriceCnt, #t.hasWJTasting, #t.hasERPTasting, #t.IsActiveWineN, #t.IsCurrentlyForSale, #t.IsCurrentlyOnAuction
	from #t
		join Wine_VinN v on #t.ProducerID = v.ProducerID and #t.TypeID = v.TypeID 
			and #t.LabelID = v.LabelID and #t.VarietyID = v.VarietyID
			and #t.DrynessID = v.DrynessID and #t.ColorID = v.ColorID
			and #t.locCountryID = v.locCountryID and #t.locRegionID = v.locRegionID
			and #t.locLocationID = v.locLocationID and #t.locLocaleID = v.locLocaleID
			and #t.locSiteID = v.locSiteID
	group by v.ID, #t.VintageID,
		#t.EstimatedCost, #t.MostRecentPrice, #t.MostRecentPriceHi, #t.MostRecentPriceCnt, #t.MostRecentAuctionPrice, #t.MostRecentAuctionPriceHi, 
		#t.MostRecentAuctionPriceCnt, #t.hasWJTasting, #t.hasERPTasting, #t.IsActiveWineN, #t.IsCurrentlyForSale, #t.IsCurrentlyOnAuction
	--rollback tran
commit tran

-------- WineN_Stat
--begin tran
--	; with w as (
--		select 
--			VinNID = v.ID,
--			VintageID = #t.VintageID,
--			wineIdn = max(wn.Idn)
--		from #t
--			join Wine_VinN v on #t.ProducerID = v.ProducerID and #t.TypeID = v.TypeID 
--				and #t.LabelID = v.LabelID and #t.VarietyID = v.VarietyID
--				and #t.DrynessID = v.DrynessID and #t.ColorID = v.ColorID
--				and #t.locCountryID = v.locCountryID and #t.locRegionID = v.locRegionID
--				and #t.locLocationID = v.locLocationID and #t.locLocaleID = v.locLocaleID
--				and #t.locSiteID = v.locSiteID
--			join RPOWineData.dbo.Wine wn on #t.ProducerName = isnull(wn.Producer, '') 
--				and #t.TypeName = isnull(wn.WineType, '') and #t.LabelName = isnull(wn.LabelName, '')
--				and #t.VarietyName = isnull(wn.Variety, '') and #t.DrynessName = isnull(wn.Dryness, '')
--				and #t.ColorName = isnull(wn.ColorClass, '') and #t.VintageName = isnull(wn.Vintage, '')
--				and #t.locCountry = isnull(wn.Country, '') and #t.locRegion = isnull(wn.Region, '')
--				and #t.locLocation = isnull(wn.Location, '') and #t.locLocale = isnull(wn.Locale, '')
--				and #t.locSite = isnull(wn.Site, '')
--				and #t.DateUpdated = isnull(wn.DateUpdated, '1/1/1999') and isnull(wn.IsActiveWineN, 1) = 1
--		group by v.ID, #t.VintageID
--	)
--	insert into Wine_N_Stat ([Wine_N_ID], [EstimatedCost], [MostRecentPrice], [MostRecentPriceHi], [MostRecentPriceCnt],
--		[MostRecentAuctionPrice], [MostRecentAuctionPriceHi], [MostRecentAuctionPriceCnt], 
--		[hasWJTasting], [hasERPTasting], [IsActiveWineN], [IsCurrentlyForSale], [IsCurrentlyOnAuction])
--	select 
--		Wine_N_ID = wn.ID, 
--		EstimatedCost, 
--		MostRecentPrice, 
--		MostRecentPriceHi, 
--		MostRecentPriceCnt,
--		MostRecentAuctionPrice, 
--		MostRecentAuctionPriceHi, 
--		MostRecentAuctionPriceCnt, 
--		hasWJTasting, 
--		hasERPTasting, 
--		IsActiveWineN, 
--		IsCurrentlyForSale,
--		IsCurrentlyOnAuction
--	from w
--		join Wine_N wn on w.VinNID = wn.Wine_VinN_ID and w.VintageID = wn.VintageID
--		join RPOWineData.dbo.Wine ow on w.wineIdn = ow.Idn
----rollback tran
--commit tran

drop table #t
GO
print '------------ Completeness Check ------------'
GO
declare @uwSource int, @uwDest int

-- Wine_VinN
select @uwSource = count(*) 
from (
	select distinct 
		Producer = isnull(wn.Producer, ''), WineType = isnull(wn.WineType, ''), 
		LabelName = isnull(wn.LabelName, ''), Variety = isnull(wn.Variety, ''), Dryness = isnull(wn.Dryness, ''),
		ColorClass = isnull(wn.ColorClass, ''), --Vintage = isnull(wn.Vintage, ''),
		Country = isnull(wn.Country, ''), Region = isnull(wn.Region, ''), 
		Location = isnull(wn.Location, ''), Locale = isnull(wn.Locale, ''), Site = isnull(wn.Site, '')
	from RPOWineData.dbo.Wine wn
) a

select @uwDest = count(*) from Wine_VinN

if @uwSource != @uwDest
	select 'Wine_VinN - ERROR: Total # of WineN on a source is different than on a target'
else
	select 'Wine_VinN - SUCCESS!!!'
select Source = @uwSource, Destination = @uwDest

-- Wine_N
select @uwSource = count(*) 
from (
	select distinct 
		Producer = isnull(wn.Producer, ''), WineType = isnull(wn.WineType, ''), 
		LabelName = isnull(wn.LabelName, ''), Variety = isnull(wn.Variety, ''), Dryness = isnull(wn.Dryness, ''),
		ColorClass = isnull(wn.ColorClass, ''), Vintage = isnull(wn.Vintage, ''),
		Country = isnull(wn.Country, ''), Region = isnull(wn.Region, ''), 
		Location = isnull(wn.Location, ''), Locale = isnull(wn.Locale, ''), Site = isnull(wn.Site, '')
	from RPOWineData.dbo.Wine wn
) a

select @uwDest = count(*) from Wine_N

if @uwSource != @uwDest
	select 'Wine_N - ERROR: Total # of WineN on a source is different than on a target'
else
	select 'Wine_N - SUCCESS!!!'
select Source = @uwSource, Destination = @uwDest
GO

print 'Done.'
GO
