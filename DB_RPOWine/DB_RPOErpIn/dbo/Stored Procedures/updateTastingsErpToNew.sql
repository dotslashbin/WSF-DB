--use erpin
--select * into tastingNewErp from tastingNew
CREATE proc updateTastingsErpToNew
as begin
 
declare @dataSourceErp int
select @dataSourceErp = whN from erp..wh where tag = 'pubWa'
 
truncate table tastingNew;
 
insert into tastingNew     (
			------------------------------------------------------------------------------------------
			-- Target Fields
			------------------------------------------------------------------------------------------
			dataSourceN
			,dataIdN
			,dataIdNDeleted 

			,ArticleId
			,_x_articleIdNKey
			,articleMasterN
			,ArticleOrder
			,bottleSizeN
			,canBeActiveTasting
			,_clumpName
			,updateDate
			,drinkDate
			,drinkDateHi
			,estimatedCostLo
			,estimatedCostHi
			,_fixedId
			,_x_hasAGalloniTasting
			,_x_HasCurrentPrice
			,_x_hasDSchildknechtTasting
			,_x_hasDThomasesTasting
			,_x_hasErpTasting
			,_x_hasJMillerTasting
			,_x_hasMSquiresTasting
			,_x_hasMultipleWATastings
			,_x_hasNMartinTasting
			,_x_hasProducerProfile
			,_x_HasProducerWebSite
			,_x_hasPRovaniTasting
			,_x_hasRParkerTasting
			,_x_hasWJtasting
			,_x_IsActiveWineN
			,IsBarrelTasting
			,isBorrowedDrinkDate
			,isErpTasting
			,isMostRecentTasting
			,isNoTasting
			,Issue
			,maturityN	--same value, better name
			,Notes
			,Pages
			,Rating
			,RatingHi
			,RatingQ
			,RatingShow
			,_x_ReviewerIdN
			,_x_showForERP
			,_x_showForWJ
			,tasterN	--Transform
			,pubDate
			,tasteDate
			,VinN
			,wineN     
			)
Select
			------------------------------------------------------------------------------------------
			-- Source fields
			------------------------------------------------------------------------------------------
			@dataSourceErp	--dataSourceN
			,fixedId				--dataIdN
			,0						--dataIdNDeleted 

			,ArticleId
			,ArticleIdNKey
			,articleMasterN
			,ArticleOrder
			,dbo.updateTranslateToBottleSizeN(BottleSize)
			,canBeActiveTasting
			,clumpName
			,DateUpdated
			,DrinkDate
			,DrinkDate_Hi
			,EstimatedCost
			,EstimatedCost_Hi
			,FixedId
			,hasAGalloniTasting
			,HasCurrentPrice
			,hasDSchildknechtTasting
			,hasDThomasesTasting
			,hasErpTasting
			,hasJMillerTasting
			,hasMSquiresTasting
			,hasMultipleWATastings
			,hasNMartinTasting
			,hasProducerProfile
			,HasProducerWebSite
			,hasPRovaniTasting
			,hasRParkerTasting
			,hasWJtasting
			,IsActiveWineN
			,IsBarrelTasting
			,isBorrowedDrinkDate
			,isErpTasting
			,isMostRecentTasting
			,isNoTasting
			,Issue
			,Maturity
			,Notes
			,Pages
			,Rating
			,Rating_Hi
			,RatingQ
			,RatingShow
			,ReviewerIdN
			,showForERP
			,showForWJ
			,dbo.updateTranslateToTasterN([Source])
			,SourceDate
			,tasteDate
			,VinN
			,WineN
	from erp..mayWine
 
--select source from maywine
 
 
/*
------------------------------------------------------------------------------------------
-- Fields not transfered
------------------------------------------------------------------------------------------
--ArticleOrder
--EntryN
--erpTastingCount
--isActiveT
--IsActiveTasting
--isActiveWineN_old
--isActiveWineN2
--isActiveWineNRpwacm
--IsCurrentlyForSale
--isCurrentlyOnAuction
--IsERPName
--isWjTasting
--joinA
--joinX
--LabelName
--mostRecentAuctionPrice
--mostRecentAuctionPriceCnt
--mostRecentAuctionPriceHi
--MostRecentPrice
--MostRecentPriceCnt
--MostRecentPriceHi
--notesLen
--originalEstimatedCost
--originalEstimatedCost_hi
--Producer
--ProducerProfileFileName
--ProducerShow
--ProducerURL
--ShortLabelName
--Site
--SomeYearHasPrices
--TastingCount
--ThisYearHasPrices
--Vin
--WineNameIdN
--wineNameN
--WineType
*/
end
 
