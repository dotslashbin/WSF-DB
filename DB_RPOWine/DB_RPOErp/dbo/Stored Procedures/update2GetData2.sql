
CREATE proc [dbo].[update2GetData2]

as 
begin
 
	truncate table RPOErpIn..ewine
	
	alter index all on RPOErpIn..ewine disable
	alter index ix_eWine_idN on RPOErpIn..ewine rebuild

	insert into RPOErpIn..ewine(
		--articleHandle,
		ArticleId, ArticleIdNKey,
		--articleMasterN,ArticleOrder,BottleSize,BottlesPerCosting,canBeActiveTasting,
		clumpName,ColorClass,
		--CombinedLocation,
		Country,
		--DateUpdated,
		DrinkDate,DrinkDate_Hi,Dryness,encodedKeyWords,
		--EntryN,erpTastingCount,
		EstimatedCost,
		--EstimatedCost_Hi,
		FixedId,
		--hasAGalloniTasting,HasCurrentPrice,hasDSchildknechtTasting,hasDThomasesTasting,hasErpTasting,hasJMillerTasting,
		--hasMSquiresTasting,hasMultipleWATastings,hasNMartinTasting,hasProducerProfile,HasProducerWebSite,hasPRovaniTasting,
		--hasRParkerTasting,
		hasWJtasting,
		--Idn,isActiveT,IsActiveTasting,
		IsActiveWineN,
		--isActiveWineN_old,isActiveWineN2,isActiveWineNRpwacm,IsBarrelTasting,isBorrowedDrinkDate,
		IsCurrentlyForSale,isCurrentlyOnAuction,
		--IsERPName,
		isErpTasting,
		--isMostRecentTasting,isNoTasting,
		Issue,isWjTasting,
		--joinA,joinX,
		LabelName,Locale,Location,Maturity,mostRecentAuctionPrice,
		--mostRecentAuctionPriceCnt,mostRecentAuctionPriceHi,
		MostRecentPrice,
		--MostRecentPriceCnt,
		MostRecentPriceHi,Notes,
		--notesLen,originalEstimatedCost,originalEstimatedCost_hi,Pages,
		Places,Producer,ProducerProfileFileName,ProducerShow,ProducerURL,Publication,Rating,
		--Rating_Hi,RatingQ,
		RatingShow,Region,ReviewerIdN,
		--ShortLabelName,
		ShortTitle,showForERP,showForWJ,Site,
		--SomeYearHasPrices,
		Source,SourceDate,
		--tasteDate,TastingCount,temp,ThisYearHasPrices,
		Variety,
		--Vin,
		VinN,Vintage,
		--WhoUpdated,
		WineN,
		--WineNameIdN,wineNameN,
		WineType)
	select 
		--articleHandle,
		ArticleId,ArticleIdNKey,
		--articleMasterN,ArticleOrder,BottleSize,BottlesPerCosting,canBeActiveTasting,
		clumpName,ColorClass,
		--CombinedLocation,
		Country,
		--DateUpdated,
		DrinkDate,DrinkDate_Hi,Dryness,encodedKeyWords,
		--EntryN,erpTastingCount,
		EstimatedCost,
		--EstimatedCost_Hi,
		FixedId,
		--hasAGalloniTasting,HasCurrentPrice,hasDSchildknechtTasting,hasDThomasesTasting,hasErpTasting,hasJMillerTasting,
		--hasMSquiresTasting,hasMultipleWATastings,hasNMartinTasting,hasProducerProfile,HasProducerWebSite,hasPRovaniTasting,
		--hasRParkerTasting,
		hasWJtasting,
		--Idn,isActiveT,IsActiveTasting,
		IsActiveWineN,
		--isActiveWineN_old,isActiveWineN2,isActiveWineNRpwacm,IsBarrelTasting,isBorrowedDrinkDate,
		IsCurrentlyForSale,isCurrentlyOnAuction,
		--IsERPName,
		isErpTasting,
		--isMostRecentTasting,isNoTasting,
		Issue,isWjTasting,
		--joinA,joinX,
		LabelName,Locale,Location,Maturity,mostRecentAuctionPrice,
		--mostRecentAuctionPriceCnt,mostRecentAuctionPriceHi,
		MostRecentPrice,
		--MostRecentPriceCnt,
		MostRecentPriceHi,Notes,
		--notesLen,originalEstimatedCost,originalEstimatedCost_hi,Pages,
		Places,Producer,ProducerProfileFileName,ProducerShow,ProducerURL,Publication,Rating,
		--Rating_Hi,RatingQ,
		RatingShow,Region,ReviewerIdN,
		--ShortLabelName,
		ShortTitle,showForERP,showForWJ,Site,
		--SomeYearHasPrices,
		Source,SourceDate,
		--tasteDate,TastingCount,temp,ThisYearHasPrices,
		Variety,
		--Vin,
		VinN,Vintage,
		--WhoUpdated,
		WineN,
		--WineNameIdN,wineNameN,
		WineType
	from RPOErpIn..rpowinedataDWine;

	with
	a as (
		select FixedId, ROW_NUMBER() over(order by producerShow, vintage) ii 
		from RPOErpIn..rpowinedataDWine
	)
	update b set iiProducerVintage = a.ii
	from RPOErpIn..eWine b
		join a on a.FixedId = b.FixedId;

	alter index all on RPOErpIn..ewine rebuild;
 
	truncate table RPOErpIn..jwine;

	alter index all on RPOErpIn..jwine disable
	alter index ix_jwine_wineN on RPOErpIn..jwine rebuild

	insert into RPOErpIn..jwine(ArticleId,ArticleIdNKey,ArticleOrder,BottleSize,BottlesPerCosting,clumpName,ColorClass,CombinedLocation,Country,DateUpdated,DisabledFlag,DrinkDate,DrinkDate_Hi,Dryness,encodedKeyWords,erpTastingCount,EstimatedCost,EstimatedCost_Hi,FixedId,hasAGalloniTasting,HasCurrentPrice,hasDSchildknechtTasting,hasDThomasesTasting,HasERPTasting,hasJMillerTasting,hasMSquiresTasting,hasMultipleWATastings,hasNMartinTasting,hasProducerProfile,HasProducerWebSite,hasPRovaniTasting,hasRParkerTasting,HasUserNotes,HasWJTasting,IdN,IsActiveTasting,IsActiveWineN,isActiveWineN_old,IsBarrelTasting,isBorrowedDrinkDate,IsCurrentlyForSale,isCurrentlyOnAuction,isErpLocationOK,IsERPName,isErpProducerOK,isErpRegionOK,isErpTasting,isErpVarietyOK,isProducerTranslated,Issue,isVinnDeduced,isWineNDeduced,isWjTasting,joinx,LabelName,Locale,Location,Maturity,mostRecentAuctionPrice,mostRecentAuctionPriceCnt,mostRecentAuctionPriceHi,MostRecentPrice,mostRecentPriceAvg,MostRecentPriceCnt,MostRecentPriceHi,NameCreatorWhoN,Notes,Pages,Places,Producer,ProducerProfileFileName,ProducerShow,ProducerURL,Publication,qprAllShow,qprAllShowI,qprGroup,qprGroupRankShow,qprGroupRankShowI,qprGroupShow,qprGroupShowI,qprRaw,Rating,Rating_Hi,ratingQ,RatingShow,RecordCreatedDate,RecordCreatorWhoN,Region,ReviewerIdN,ShortLabelName,shortTitle,showForERP,showForWJ,Site,SomeYearHasPrices,Source,SourceDate,TastingCount,ThisYearHasPrices,UserCount,Variety,Vin,VinN,Vintage,WhoUpdated,Wid,WineN,wineNameIdN,wineNameN,WineType)
	select 
		ArticleId,ArticleIdNKey,ArticleOrder,BottleSize,BottlesPerCosting,clumpName,ColorClass,CombinedLocation,
		Country,DateUpdated,DisabledFlag,DrinkDate,DrinkDate_Hi,Dryness,encodedKeyWords,erpTastingCount,
		EstimatedCost,EstimatedCost_Hi,FixedId,hasAGalloniTasting,HasCurrentPrice,hasDSchildknechtTasting,
		hasDThomasesTasting,HasERPTasting,hasJMillerTasting,hasMSquiresTasting,hasMultipleWATastings,
		hasNMartinTasting,hasProducerProfile,HasProducerWebSite,hasPRovaniTasting,hasRParkerTasting,
		HasUserNotes,HasWJTasting,IdN,IsActiveTasting,IsActiveWineN,isActiveWineN_old,IsBarrelTasting,
		isBorrowedDrinkDate,IsCurrentlyForSale,isCurrentlyOnAuction,isErpLocationOK,IsERPName,isErpProducerOK,
		isErpRegionOK,isErpTasting,isErpVarietyOK,isProducerTranslated,Issue,isVinnDeduced,isWineNDeduced,
		isWjTasting,joinx,LabelName,Locale,Location,Maturity,mostRecentAuctionPrice,mostRecentAuctionPriceCnt,
		mostRecentAuctionPriceHi,MostRecentPrice,mostRecentPriceAvg,MostRecentPriceCnt,MostRecentPriceHi,
		NameCreatorWhoN,Notes,Pages,Places,Producer,ProducerProfileFileName,ProducerShow,ProducerURL,Publication,
		qprAllShow,qprAllShowI,qprGroup,qprGroupRankShow,qprGroupRankShowI,qprGroupShow,qprGroupShowI,qprRaw,
		Rating,Rating_Hi,ratingQ,RatingShow,RecordCreatedDate,RecordCreatorWhoN,Region,ReviewerIdN,ShortLabelName,
		shortTitle,showForERP,showForWJ,Site,SomeYearHasPrices,Source,SourceDate,TastingCount,ThisYearHasPrices,
		UserCount,Variety,Vin,VinN,Vintage,WhoUpdated,Wid,WineN,wineNameIdN,wineNameN,WineType
	from RPOErpIn..erpSearchDWine;

	alter index all on RPOErpIn..jwine rebuild;
 
end

