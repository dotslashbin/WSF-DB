CREATE proc [dbo].update2TastingStep1Chunk (@iiLo int, @iiHi int)as begin
 
exec dbo.ooLog '     update2TastingStep1Chunk @1-@2 begin', @iiLo, @iiHi
 
declare @dataSourceErp int
select @dataSourceErp = whN from wh where tag = 'pubWa'
 
insert into vTastingNew     (
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
			--,bottleSizeN
			,canBeActiveTasting
			,_clumpName
			,updateDate
			--,updateWhN
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
			--,tasterN	--Transform
			,pubDate
			,tasteDate
			,VinN
			,wineN   
			,isAnnonymous
			,isPrivate  
			,joinX
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
			--,dbo.updateTranslateToBottleSizeN(BottleSize)
			,canBeActiveTasting
			,clumpName
			,DateUpdated
			--, @dataSourceErp
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
			--,dbo.updateTranslateToTasterN([Source])
			,SourceDate
			,tasteDate
			,VinN
			,WineN
			,0
			,0
			,joinX
	from veWine
	where iiProducerVintage between @iiLo and @iiHi
  
exec dbo.ooLog '     update2TastingStep1Chunk @1-@2 end', @iiLo, @iiHi
end
 
 
 
 
 
 
 
 
 
 
