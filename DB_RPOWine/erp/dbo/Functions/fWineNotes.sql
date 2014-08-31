-- database doug interface userInterface xx [=]
CREATE function fWineNotes ( 
		 @keywords varchar(max)
		,@MustBeCurrentlyForSale bit
		,@IncludeAuctions bit
		,@MustHaveReviewInThisPubG bit
		,@MyWinesN int
		,@PriceGN int
		,@PubGN int
		,@Where varchar(max) 
		,@OrderBy varchar(max)
		,@GroupBy varchar(max)
		,@MaxResultCount int
        )

returns @TT table(producer varchar(99)) as begin


/*
Larisa's fields
			WineN
			ColorClass
			Vintage
			ScreenWineName = isnull(ProducerShow,'') + ' ' +  isnull(LabelName,'')
			MostRecentPrice (I am not sure how we are going to handle the AuctionPrice here)
			Rating 
			Publication (are we going to use the Publication to show the icon?)
			Notes
*/




--------------------------------------------------------------------------------------------------------------------------------------
KeywordsOnly:			--  [ ] Include Auction          [ ] For Sale Now          [ ] Has Review          [ ] In My Wines
--------------------------------------------------------------------------------------------------------------------------------------
/* SEE PROCEDURE XX
insert into @TT(producer)
	select
		a.wineN, a.vintage
		,b.producer, b.producerProfileFile, b.producerShow, b.producerURL
		,b.labelName
		,b.country, b.region, b.location, b.locale, b.site, b.places
		,b.variety, b.colorClass, b.dryness, b.wineType
		,isNull (d.mostRecentPriceLo, a.estimatedCostLo) priceLo
		,isNull (d.mostRecentPriceHi, a.estimatedCostHi) priceHi
		,isNull(d.mostRecentPriceCnt, 0) priceCnt
		,a.tastingN 
		,c.pubIconN
		,c.ratingShow, c.maturity
	from wine a
		join wineName b
			on a.wineNameN = b.wineNameN
		join mapPubGToWine c
			on c.wineN = a.wineN 
		left join price d
			on a.wineN = d.wineN
	where
		(d.wineN is null
			or (includesNotForSaleNow = 1 
					and includesAuction = 1 
					and priceGN = @PriceGN)
			)
		and pubGN = @PubGN

*/


/* OLD
insert into @TT(producer)
select count(distinct z.winen) --z.wineN, includesNotForSaleNow, includesAuction, priceGN, pubGN
	from wine z
		join wineName y
			on z.wineNameN = y.wineNameN
		join mapPubGToWine x
			on x.wineN = z.wineN 
		left join price v
			on z.wineN = v.wineN
	where
		z.isInactive = 0
		and y.isInactive = 0
		and (v.wineN is null
			or (includesNotForSaleNow = 1 and includesAuction = 1 and priceGN = 18220)
			)
		and pubGN = 18223	-- erpPub
*/


/*
select
	 	 v.wineN vWineN, v.priceGN, v.includesNotForSaleNow, v.includesAuction, z.pubGN
		,z.wineN, y.wineNameN, y.activeVinn
		,y.vintage
		,x.producer, x.producerProfileFile, x.producerShow, x.producerURL
		,x.labelName
		,x.country, x.region, x.location, x.locale, x.site, x.places
		,x.variety, x.colorClass, x.dryness, x.wineType
		,isNull (v.mostRecentPriceLo, y.estimatedCostLo) priceLo
		,isNull (v.mostRecentPriceHi, y.estimatedCostHi) priceHi
		,isNull(v.mostRecentPriceCnt, 0) priceCnt
		,x.encodedKeyWords
	from mapPubGToWine z
		join wine y
			on z.wineN = y.wineN 
		join wineName x
			on y.wineNameN = x.wineNameN
		left join price v
			on z.wineN = v.wineN
	where isNull(v.includesNotForSaleNow,1) = 1
		and (y.isInactive = 0)
		and(x.isInactive = 0)

*/


return
end
