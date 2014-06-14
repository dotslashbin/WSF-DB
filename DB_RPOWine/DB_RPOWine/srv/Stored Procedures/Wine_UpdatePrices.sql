
-- =============================================
-- Author:		Alex B.
-- Create date: 5/23/2014
-- Description:	Updates price and auction price based on new data in erpSearchD databse.
-- =============================================
CREATE PROCEDURE [srv].[Wine_UpdatePrices]

AS

set nocount on;
set xact_abort on;

--alter table WAName add
--	Wine_VinN_ID int null

begin tran
	-- 01. Set VinN in WAName (4 sec)
	update eRPSearchD.dbo.WAName set Wine_VinN_ID = NULL;

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
			join eRPSearchD.dbo.ForSaleDetail sd on sd.Wid = wn.Wid
			left join WineProducer wp on isnull(wn.erpProducer, '') = wp.Name
			left join WineType wt on isnull(wn.erpWineType, '') = wt.Name
			left join WineLabel wl on isnull(wn.erpLabelName, '') = wl.Name
			left join WineVariety wv on isnull(wn.erpVariety, '') = wv.Name
			left join WineDryness wd on isnull(wn.erpDryness, '') = wd.Name
			left join WineColor wc on isnull(wn.erpColorClass, '') = wc.Name
			--left join WineVintage wvin on isnull(wn.Vintage, '') = wvin.Name
			
			left join LocationCountry lc on isnull(wn.erpCountry, '') = lc.Name
			left join LocationRegion lr on isnull(wn.erpRegion, '') = lr.Name
			left join LocationLocation ll on isnull(wn.erpLocation, '') = ll.Name
			--left join LocationLocale lloc on isnull(wn.Locale, '') = lloc.Name
			--left join LocationSite ls on isnull(wn.Site, '') = ls.Name
			left join Wine_VinN vn on
				wp.ID = vn.ProducerID and wt.ID = vn.TypeID and wl.ID = vn.LabelID
				and wv.ID = vn.VarietyID and wd.ID = vn.DrynessID and wc.ID = vn.ColorID
				and lc.ID = vn.locCountryID and lr.ID = vn.locRegionID and ll.ID = vn.locLocationID
	)
	update eRPSearchD.dbo.WAName set Wine_VinN_ID = r.Wine_VinN_ID
	from r
		join eRPSearchD.dbo.WAName on r.idN = WAName.idN
	where r.Wine_VinN_ID is not null
	;

	-- 019. Checking results - no update
	/*
	; with r as (
		select 
			Wine_VinN_ID = wn.Wine_VinN_ID, Wine_ID = wn.ID,
			Price = min(case when sd.isAuction = 1 then null else sd.DollarsPer750Bottle end),
			PriceHi = max(case when sd.isAuction = 1 then null else sd.DollarsPer750Bottle end),
			PriceCnt = sum(case when sd.isAuction = 1 then 0 else 1 end),
			AuctionPrice = min(case when sd.isAuction = 0 then null else sd.DollarsPer750Bottle end),
			AuctionPriceHi = max(case when sd.isAuction = 0 then null else sd.DollarsPer750Bottle end),
			AuctionPriceCnt = sum(case when sd.isAuction = 0 then 0 else 1 end)
		from eRPSearchD.dbo.ForSaleDetail sd
			join eRPSearchD.dbo.WAName wan on sd.Wid = wan.Wid
			join WineVintage wvin on isnull(sd.Vintage, '') = wvin.Name
			join Wine_N wn on wan.Wine_VinN_ID = wn.Wine_VinN_ID and wn.VintageID = wvin.ID
		where isnull(sd.DollarsPer750Bottle, 0) > 0 and sd.Errors is null and wan.Errors is null
		group by wn.Wine_VinN_ID, wn.ID
	)
	select 
		r.Wine_VinN_ID, r.Wine_ID,
		r.Price,
		r.PriceHi,
		r.PriceCnt,
		r.AuctionPrice,
		r.AuctionPriceHi,
		r.AuctionPriceCnt,
		wn.MostRecentPrice,
		wn.MostRecentPriceHi,
		wn.MostRecentPriceCnt,
		wn.MostRecentAuctionPrice,
		wn.MostRecentAuctionPriceHi,
		wn.MostRecentAuctionPriceCnt
	from r
		join Wine_N wn on r.Wine_ID = wn.ID
	where Price != wn.MostRecentPrice or isnull(r.AuctionPrice, 0) != isnull(wn.MostRecentAuctionPrice, 0)
	;
	*/

	-- 02. Update Price
	-- NOTE: it does not clear out previous prices!!!
	with r as (
		select 
			Wine_VinN_ID = wn.Wine_VinN_ID, Wine_ID = wn.ID,
			Price = min(case when sd.isAuction = 1 then null else sd.DollarsPer750Bottle end),
			PriceHi = max(case when sd.isAuction = 1 then null else sd.DollarsPer750Bottle end),
			PriceCnt = sum(case when sd.isAuction = 1 then 0 else 1 end),
			AuctionPrice = min(case when sd.isAuction = 0 then null else sd.DollarsPer750Bottle end),
			AuctionPriceHi = max(case when sd.isAuction = 0 then null else sd.DollarsPer750Bottle end),
			AuctionPriceCnt = sum(case when sd.isAuction = 0 then 0 else 1 end)
		from eRPSearchD.dbo.ForSaleDetail sd
			join eRPSearchD.dbo.WAName wan on sd.Wid = wan.Wid
			join WineVintage wvin on isnull(sd.Vintage, '') = wvin.Name
			join Wine_N wn on wan.Wine_VinN_ID = wn.Wine_VinN_ID and wn.VintageID = wvin.ID
		where isnull(sd.DollarsPer750Bottle, 0) > 0 and sd.Errors is null and wan.Errors is null
		group by wn.Wine_VinN_ID, wn.ID
	)
	update Wine_N set 
		MostRecentPrice = r.Price,
		MostRecentPriceHi = r.PriceHi,
		MostRecentPriceCnt = r.PriceCnt,
		MostRecentAuctionPrice = r.AuctionPrice,
		MostRecentAuctionPriceHi = r.AuctionPriceHi,
		MostRecentAuctionPriceCnt = r.AuctionPriceCnt,
		IsCurrentlyForSale = case when isnull(r.PriceCnt, 0) > 0 then 1 else 0 end,
		IsCurrentlyOnAuction = case when isnull(r.AuctionPriceCnt, 0) > 0 then 1 else 0 end,
		updated = getdate()
	from r
		join Wine_N wn on r.Wine_ID = wn.ID
	where (MostRecentPrice != r.Price or MostRecentPriceHi != r.PriceHi 
		or MostRecentPriceCnt != r.PriceCnt or MostRecentAuctionPrice != r.AuctionPrice
		or MostRecentAuctionPriceHi != r.AuctionPriceHi or MostRecentAuctionPriceCnt != r.AuctionPriceCnt)
	;

	-- 03. Set hasWJTasting and hasErpTasting
	;with has as (
		select
			tn.Wine_N_ID,
			hasWJTasting = max(case when pub.IsPrimary = 0 then 1 else 0 end),
			hasErpTasting = max(case when pub.IsPrimary = 1 then 1 else 0 end)
		from TasteNote tn (nolock)
			join Issue i (nolock) on tn.IssueID = i.ID
			join Publication p (nolock) on i.PublicationID = p.ID
			join Publisher pub (nolock) on p.PublisherID = pub.ID
		group by tn.Wine_N_ID
	)
	update Wine_N set
		hasWJTasting = has.hasWJTasting,
		hasERPTasting = has.hasERPTasting,
		updated = getdate()
	from has
		join Wine_N wn on has.Wine_N_ID = wn.ID
	where (wn.hasWJTasting != has.hasWJTasting or wn.hasERPTasting != has.hasERPTasting)
	;
	
commit tran

RETURN 1