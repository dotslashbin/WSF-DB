-- =============================================
-- Author:		Alex B.
-- Create date: 5/22/14
-- Description:	Processes data from erpSearchD database:
--				- Register all missing lookup values
--				- Adds all new VineN and Wine records, that have prices.
-- =============================================
CREATE PROCEDURE [srv].[Wine_AddMissingFromSearchDB]

AS
set nocount on;
set xact_abort on;

print '------------------ WARNING! ------------------'
print '-- Data Loaded from eRPSearchD database!    --'
print '-- Make sure that you updated prices first! --'
print '--          eRPSearchD..23Update            --'
print '--          srv.Wine_UpdatePrices!          --'
print '----------------------------------------------'

-------- WineTypes
--select WineType, erpWineType, count(*) from eRPSearchD.dbo.WAName group by WineType, erpWineType
insert into WineType (Name, WF_StatusID)
select isnull(wn.erpWineType, wn.WineType), WF_StatusID = 100
from eRPSearchD.dbo.WAName wn
	join eRPSearchD..ForSaleDetail sd on sd.Wid = wn.Wid
	left join WineType c on isnull(wn.erpWineType, wn.WineType) = c.Name
where wn.Wine_VinN_ID is NULL and isnull(sd.DollarsPer750Bottle, 0) > 0
	and isnull(wn.erpWineType, wn.WineType) is not null and LEN(isnull(wn.erpWineType, wn.WineType)) > 0 and c.ID is NULL
group by isnull(wn.erpWineType, wn.WineType)

----------- WineLabel
insert into WineLabel (Name, WF_StatusID)
select wn.LabelName, WF_StatusID = 100
from eRPSearchD.dbo.WAName wn
	join eRPSearchD..ForSaleDetail sd on sd.Wid = wn.Wid
	left join WineLabel l on wn.LabelName = l.Name
where wn.Wine_VinN_ID is NULL and isnull(sd.DollarsPer750Bottle, 0) > 0
	and wn.LabelName is not null and LEN(wn.LabelName) > 0  and l.ID is NULL
group by wn.LabelName

---------- WineProducer
--select top 20 * from WineProducer where Name like '%bott%' or NameToShow like '%bott%'
insert into WineProducer (Name, NameToShow, WebSiteURL, ProfileFileName, locCountryID,locRegionID,locLocationID,locLocaleID,locSiteID, WF_StatusID)
select isnull(wn.erpProducer,wn.Producer), NameToShow = max(isnull(wn.erpProducerShow,wn.ProducerShow)), WebSiteURL = '', ProfileFileName = '', 
	0,0,0,0,0, WF_StatusID = 100
from eRPSearchD.dbo.WAName wn
	join eRPSearchD..ForSaleDetail sd on sd.Wid = wn.Wid
	left join WineProducer l on isnull(wn.erpProducer,wn.Producer) = l.Name
where wn.Wine_VinN_ID is NULL and isnull(sd.DollarsPer750Bottle, 0) > 0
	and isnull(wn.erpProducer,wn.Producer) is not null and LEN(isnull(wn.erpProducer,wn.Producer)) > 0 
	and l.ID is NULL
group by isnull(wn.erpProducer,wn.Producer)

-------- WineDryness
--select max(len(Dryness)) from RPOWineData.dbo.Wine
insert into WineDryness (Name, WF_StatusID)
select wn.Dryness, WF_StatusID=100
from eRPSearchD.dbo.WAName wn
	join eRPSearchD..ForSaleDetail sd on sd.Wid = wn.Wid
	left join WineDryness l on wn.Dryness = l.Name
where wn.Wine_VinN_ID is NULL and isnull(sd.DollarsPer750Bottle, 0) > 0
	and wn.Dryness  is not null and LEN(wn.Dryness) > 0  and l.ID is NULL
group by wn.Dryness 

---------- WineColor
insert into WineColor (Name, WF_StatusID)
select wn.ColorClass, WF_StatusID = 100
from eRPSearchD.dbo.WAName wn
	join eRPSearchD..ForSaleDetail sd on sd.Wid = wn.Wid
	left join WineColor l on wn.ColorClass  = l.Name
where wn.Wine_VinN_ID is NULL and isnull(sd.DollarsPer750Bottle, 0) > 0
	and wn.ColorClass is not null and LEN(wn.ColorClass ) > 0 and l.ID is NULL
group by wn.ColorClass  

-------- WineVariety
--select * from WineVariety where Name like 'mos%'
insert into WineVariety (Name, WF_StatusID)
select wn.Variety, WF_StatusID = 100
from eRPSearchD.dbo.WAName wn
	join eRPSearchD..ForSaleDetail sd on sd.Wid = wn.Wid
	left join WineVariety l on wn.Variety = l.Name
where wn.Wine_VinN_ID is NULL and isnull(sd.DollarsPer750Bottle, 0) > 0
	and wn.Variety is not null and LEN(wn.Variety ) > 0  and l.ID is NULL
group by wn.Variety  

-------- WineVintage
insert into WineVintage (Name, WF_StatusID)
select sd.Vintage, WF_StatusID = 100
from eRPSearchD.dbo.WAName wn
	join eRPSearchD.dbo.ForSaleDetail sd on sd.Wid = wn.Wid
	left join WineVintage l on sd.Vintage = l.Name
where wn.Wine_VinN_ID is NULL and isnull(sd.DollarsPer750Bottle, 0) > 0
	and sd.Vintage is not null and LEN(sd.Vintage) > 0 and l.ID is NULL
group by sd.Vintage 

--------  Country
insert into LocationCountry (Name, WF_StatusID)
select wn.Country, WF_StatusID = 100
from eRPSearchD.dbo.WAName wn
	join eRPSearchD.dbo.ForSaleDetail sd on sd.Wid = wn.Wid
	left join LocationCountry c on wn.Country = c.Name
where wn.Wine_VinN_ID is NULL and isnull(sd.DollarsPer750Bottle, 0) > 0
	and wn.Country is not null and LEN(wn.Country) > 0 and c.ID is NULL
	and wn.Country != 'Table'
group by wn.Country

--------  Region
insert into LocationRegion (Name, WF_StatusID)
select wn.Region, WF_StatusID = 100
from eRPSearchD.dbo.WAName wn
	join eRPSearchD.dbo.ForSaleDetail sd on sd.Wid = wn.Wid
	left join LocationRegion r on wn.Region = r.Name
where wn.Wine_VinN_ID is NULL and isnull(sd.DollarsPer750Bottle, 0) > 0
	and wn.Region is not null and LEN(wn.Region) > 0 and r.ID is NULL
group by wn.Region

----- location
insert into LocationLocation (Name, WF_StatusID)
select wn.Location, WF_StatusID = 100
from eRPSearchD.dbo.WAName wn
	join eRPSearchD.dbo.ForSaleDetail sd on sd.Wid = wn.Wid
	left join LocationLocation r on wn.Location = r.Name
where wn.Wine_VinN_ID is NULL and isnull(sd.DollarsPer750Bottle, 0) > 0
	and wn.Location is not null and LEN(wn.Location) > 0 and r.ID is NULL
group by wn.Location

-- ================= VineN & Wine ===================
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
	
	EstimatedCost = 0, 
	MostRecentPrice = min(case when sd.isAuction = 1 then null else sd.DollarsPer750Bottle end), 
	MostRecentPriceHi = max(case when sd.isAuction = 1 then null else sd.DollarsPer750Bottle end), 
	MostRecentPriceCnt = sum(case when sd.isAuction = 1 then 0 else 1 end),
	MostRecentAuctionPrice = min(case when sd.isAuction = 0 then null else sd.DollarsPer750Bottle end), 
	MostRecentAuctionPriceHi = max(case when sd.isAuction = 0 then null else sd.DollarsPer750Bottle end), 
	MostRecentAuctionPriceCnt = sum(case when sd.isAuction = 0 then 0 else 1 end), 
	hasWJTasting = cast(0 as smallint), 
	hasERPTasting = cast(0 as smallint), 
	IsCurrentlyForSale = cast(0 as smallint),
	IsCurrentlyOnAuction = cast(0 as smallint)
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
where wan.Wine_VinN_ID is NULL	-- only new stuff
	and isnull(sd.DollarsPer750Bottle, 0) > 0		-- only stuff with prices
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
		EstimatedCost, MostRecentPrice, MostRecentPriceHi, MostRecentPriceCnt, MostRecentAuctionPrice, MostRecentAuctionPriceHi, 
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
		#t.EstimatedCost, #t.MostRecentPrice, #t.MostRecentPriceHi, #t.MostRecentPriceCnt, #t.MostRecentAuctionPrice, #t.MostRecentAuctionPriceHi, 
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
		#t.EstimatedCost, #t.MostRecentPrice, #t.MostRecentPriceHi, #t.MostRecentPriceCnt, #t.MostRecentAuctionPrice, #t.MostRecentAuctionPriceHi, 
		#t.MostRecentAuctionPriceCnt, #t.hasWJTasting, #t.hasERPTasting, #t.IsCurrentlyForSale, #t.IsCurrentlyOnAuction
	--rollback tran
commit tran

drop table #t

------------------- set Wine_VinN_ID for all newly added records -----------------
; with r as (
	select --top 20
		wn.idN, wn.Wid, wn.Errors, wn.Warnings,
		Wine_VinN_ID = vn.ID,
		wn.erpProducer, ProducerID = wp.ID, wn.erpWineType, TypeID = wt.ID,
		wn.erpLabelName, LabelID = wl.ID, wn.erpVariety, VarietyID = wv.ID,
		wn.erpDryness, DrynessID = wd.ID, wn.erpColorClass, ColorID = wc.ID,
		wn.erpCountry, CountryID = lc.ID, wn.erpRegion, RegionID = lr.ID,
		wn.erpLocation, LocationID = ll.ID
	from eRPSearchD.dbo.WAName wn
		left join RPOWine..WineProducer wp on isnull(wn.erpProducer, '') = wp.Name
		left join RPOWine..WineType wt on isnull(wn.erpWineType, '') = wt.Name
		left join RPOWine..WineLabel wl on isnull(wn.erpLabelName, '') = wl.Name
		left join RPOWine..WineVariety wv on isnull(wn.erpVariety, '') = wv.Name
		left join RPOWine..WineDryness wd on isnull(wn.erpDryness, '') = wd.Name
		left join RPOWine..WineColor wc on isnull(wn.erpColorClass, '') = wc.Name
		--left join WineVintage wvin on isnull(wn.Vintage, '') = wvin.Name
		
		left join RPOWine..LocationCountry lc on isnull(wn.erpCountry, '') = lc.Name
		left join RPOWine..LocationRegion lr on isnull(wn.erpRegion, '') = lr.Name
		left join RPOWine..LocationLocation ll on isnull(wn.erpLocation, '') = ll.Name
		--left join LocationLocale lloc on isnull(wn.Locale, '') = lloc.Name
		--left join LocationSite ls on isnull(wn.Site, '') = ls.Name
		left join RPOWine..Wine_VinN vn on
			wp.ID = vn.ProducerID and wt.ID = vn.TypeID and wl.ID = vn.LabelID
			and wv.ID = vn.VarietyID and wd.ID = vn.DrynessID and wc.ID = vn.ColorID
			and lc.ID = vn.locCountryID and lr.ID = vn.locRegionID and ll.ID = vn.locLocationID
)
update eRPSearchD.dbo.WAName set Wine_VinN_ID = r.Wine_VinN_ID
from r
	join eRPSearchD.dbo.WAName on r.idN = WAName.idN
where r.Wine_VinN_ID is not null
;

---------------- add missing Wines ------------
insert into Wine_N (Wine_VinN_ID, VintageID, WF_StatusID,
		MostRecentPrice, MostRecentPriceHi, MostRecentPriceCnt, 
		MostRecentAuctionPrice, MostRecentAuctionPriceHi, MostRecentAuctionPriceCnt, 
		hasWJTasting, hasERPTasting, IsCurrentlyForSale, IsCurrentlyOnAuction)
select wn.Wine_VinN_ID, VintageID = wv.ID, 100,	-- sd.Vintage, 
	Price = min(case when sd.isAuction = 1 then null else sd.DollarsPer750Bottle end),
	PriceHi = max(case when sd.isAuction = 1 then null else sd.DollarsPer750Bottle end),
	PriceCnt = sum(case when sd.isAuction = 1 then 0 else 1 end),
	AuctionPrice = min(case when sd.isAuction = 0 then null else sd.DollarsPer750Bottle end),
	AuctionPriceHi = max(case when sd.isAuction = 0 then null else sd.DollarsPer750Bottle end),
	AuctionPriceCnt = sum(case when sd.isAuction = 0 then 0 else 1 end),
	hasWJTasting = cast(0 as smallint), 
	hasERPTasting = cast(0 as smallint), 
	IsCurrentlyForSale = cast(1 as smallint),
	IsCurrentlyOnAuction = cast(max(case when sd.isAuction = 0 then 0 else 1 end) as smallint)
from eRPSearchD.dbo.WAName wn
	join eRPSearchD..ForSaleDetail sd on sd.Wid = wn.Wid
	join Wine_VinN vn on wn.Wine_VinN_ID = vn.ID
	join WineVintage wv on sd.Vintage = wv.Name
	left join Wine_N w on vn.ID = w.Wine_VinN_ID and wv.ID = w.VintageID
where wn.Wine_VinN_ID is NOT NULL and isnull(sd.DollarsPer750Bottle, 0) > 0
	and w.ID is NULL
group by wn.Wine_VinN_ID, sd.Vintage, wv.ID
	
-- ================= VineN & Wine ===================
print 'Done.'

RETURN 1