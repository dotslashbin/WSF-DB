-- =============================================
-- Author:		Alex B.
-- Create date: 5/23/2014
-- Description:	Updates price and auction price based on new data in RPOSearch databse.
-- =============================================
CREATE PROCEDURE [srv].[Wine_UpdatePrices]

AS

set nocount on;
set xact_abort on;

--alter table WAName add
--	Wine_VinN_ID int null

--begin tran
	-- 01. Set VinN in WAName (4 sec)
	exec srv.Wine_MatchWithSearchDB;

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
		from dbo.SYN_t_ForSaleDetail sd
			join dbo.SYN_t_WAName wan on sd.Wid = wan.Wid
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
	update Wine_N set 
		IsCurrentlyForSale = 0, 
		IsCurrentlyOnAuction = 0,
		MostRecentPrice = 0,
		MostRecentPriceHi = 0,
		MostRecentPriceCnt = 0,
		MostRecentAuctionPrice = 0,
		MostRecentAuctionPriceHi = 0,
		MostRecentAuctionPriceCnt = 0
	;
	
	;with r as (
		select 
			Wine_VinN_ID = wn.Wine_VinN_ID, Wine_ID = wn.ID,
			Price = min(case when sd.isAuction = 1 then null else sd.DollarsPer750Bottle end),
			PriceHi = max(case when sd.isAuction = 1 then null else sd.DollarsPer750Bottle end),
			PriceCnt = sum(case when sd.isAuction = 1 then 0 else 1 end),
			AuctionPrice = min(case when sd.isAuction = 0 then null else sd.DollarsPer750Bottle end),
			AuctionPriceHi = max(case when sd.isAuction = 0 then null else sd.DollarsPer750Bottle end),
			AuctionPriceCnt = sum(case when sd.isAuction = 0 then 0 else 1 end)
		from dbo.SYN_t_ForSaleDetail sd
			join dbo.SYN_t_WAName wan on sd.Wid = wan.Wid
			join WineVintage wvin on isnull(sd.Vintage, '') = wvin.Name
			join Wine_N wn on wan.Wine_VinN_ID = wn.Wine_VinN_ID and wn.VintageID = wvin.ID
		where isnull(sd.DollarsPer750Bottle, 0) > 0 
			--and len(isnull(sd.Errors,'')) < 1 and len(isnull(wan.Errors, '')) < 1

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
	-- we cannot do it! because IsCurrentlyForSale was set to 0...
	--where (isnull(MostRecentPrice, -1) != isnull(r.Price, -2) 
	--	or isnull(MostRecentPriceHi, -1) != isnull(r.PriceHi, -2)
	--	or isnull(MostRecentPriceCnt, -1) != isnull(r.PriceCnt, -2) 
	--	or isnull(MostRecentAuctionPrice, -1) != isnull(r.AuctionPrice, -2)
	--	or isnull(MostRecentAuctionPriceHi, -1) != isnull(r.AuctionPriceHi, -2) 
	--	or isnull(MostRecentAuctionPriceCnt, -1) != isnull(r.AuctionPriceCnt, -2))
	;

	-- 03. Set hasWJTasting and hasErpTasting
	update Wine_N set
		hasWJTasting = 0,
		hasERPTasting = 0,
		updated = getdate()
	from Wine_N
		left join TasteNote tn on tn.Wine_N_ID = Wine_N.ID
	where tn.ID is NULL and 
		(hasWJTasting is NULL or hasWJTasting != 0 
		or hasERPTasting is NULL or hasERPTasting != 0)
	
	;with has as (
		select
			tn.Wine_N_ID,
			hasWJTasting = max(case when pub.ID > 0 and pub.IsPrimary = 0 then 1 else 0 end),
			hasErpTasting = max(case when pub.ID > 0 and pub.IsPrimary = 1 then 1 else 0 end)
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
	where (isnull(wn.hasWJTasting, -1) != isnull(has.hasWJTasting, -2) 
		or isnull(wn.hasERPTasting, -1) != isnull(has.hasERPTasting, -2))
	;
	
--commit tran

RETURN 1
