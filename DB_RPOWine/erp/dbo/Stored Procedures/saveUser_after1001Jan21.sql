﻿ 
 
-- zapUser     saveUser     restoreUser		[=]
CREATE proc [dbo].[saveUser_after1001Jan21](@whN int, @saveName nvarChar(50))
as begin
 
--declare @whN int = 20, @saveName nvarChar(50) = 'Foo'
 
set noCount on
 
delete from savedTables..tasting where tasterN = @whN and saveName = @saveName;
delete from savedTables..whToWine where whN = @whN and saveName = @saveName;
 
delete from savedTables..whToTrustedTaster where whN = @whN and saveName = @saveName;
delete from savedTables..whToTrustedPub where whN = @whN and saveName = @saveName;
 
delete from savedTables..Location where whN = @whN and saveName = @saveName;
delete from savedTables..Purchase where whN = @whN and saveName = @saveName;
delete from savedTables..Supplier where whN = @whN and saveName = @saveName;
 
 
--declare @whN int = 20, @saveName nvarChar(50) = 'Foo'
set identity_insert savedTables..tasting on
insert into savedTables..tasting(
		saveName
			,tastingN,wineN,vinN,wineNameN,pubN,pubDate,issue,pages,articleId,_x_articleIdNKey,articleOrder,articleURL,notes,tasterN,tasteDate,isMostRecentTasting,isNoTasting,isActiveForThisPub,_x_IsActiveWineN,isBorrowedDrinkDate,IsBarrelTasting,bottleSizeN,rating,ratingPlus,ratingHi,ratingShow,drinkDate,drinkDateHi,drinkWhenN,maturityN,estimatedCostLo,estimatedCostHi,originalCurrencyN,provenanceN,whereTastedN,isAvailabeToTastersGroups,isPostedToBB,isAnnonymous,isPrivate,updateWhN,_clumpName,_fixedId,_x_hasAGalloniTasting,_x_HasCurrentPrice,_x_hasDSchildknechtTasting,_x_hasDThomasesTasting,_x_hasErpTasting,_x_hasJMillerTasting,_x_hasMSquiresTasting,_x_hasMultipleWATastings,_x_hasNMartinTasting,_x_hasProducerProfile,_x_HasProducerWebSite,_x_hasPRovaniTasting,_x_hasRParkerTasting,_x_hasWJtasting,_x_reviewerIdN,ratingQ,createDate,createWh,isInactive,articleMasterN,decantedN,isApproved,hasUserComplaint,updateDate,hasHad,userComplaintCount,hasRating,isErpTasting,ParkerZralyLevel,sourceIconN,isProTasting)
		select @saveName
			,tastingN,wineN,vinN,wineNameN,pubN,pubDate,issue,pages,articleId,_x_articleIdNKey,articleOrder,articleURL,notes,tasterN,tasteDate,isMostRecentTasting,isNoTasting,isActiveForThisPub,_x_IsActiveWineN,isBorrowedDrinkDate,IsBarrelTasting,bottleSizeN,rating,ratingPlus,ratingHi,ratingShow,drinkDate,drinkDateHi,drinkWhenN,maturityN,estimatedCostLo,estimatedCostHi,originalCurrencyN,provenanceN,whereTastedN,isAvailabeToTastersGroups,isPostedToBB,isAnnonymous,isPrivate,updateWhN,_clumpName,_fixedId,_x_hasAGalloniTasting,_x_HasCurrentPrice,_x_hasDSchildknechtTasting,_x_hasDThomasesTasting,_x_hasErpTasting,_x_hasJMillerTasting,_x_hasMSquiresTasting,_x_hasMultipleWATastings,_x_hasNMartinTasting,_x_hasProducerProfile,_x_HasProducerWebSite,_x_hasPRovaniTasting,_x_hasRParkerTasting,_x_hasWJtasting,_x_reviewerIdN,ratingQ,createDate,createWh,isInactive,articleMasterN,decantedN,isApproved,hasUserComplaint,updateDate,hasHad,userComplaintCount,hasRating,isErpTasting,ParkerZralyLevel,sourceIconN,isProTasting
		from tasting where tasterN = @whN
set identity_insert savedTables..tasting off
 
 
--declare @whN int = 20, @saveName nvarChar(50) = 'Foo'
insert into savedTables..whToWine(
		saveName
			, whN,wineN,isOfInterestShow,wantToTryShow,hasBottlesShow,hasTastingsShow,wantToBuyShow,wantToSellShow,hasBuyersShow,hasSellersShow,hasUserCommentsShow,isOfInterest,wantToTry,bottleCount,hasMoreDetail,tastingCount,wantToSellBottleCount,wantToBuyBottleCount,buyerCount,sellerCount,userComments,isOfInterestR,wantToTryR,hasBottlesR,hasTastingsR,wantToBuyR,wantToSellR,hasBuyersR,hasSellersR,hasUserCommentsR,locationN,hasHadStuff,isDerived,warnings,isOfInterestX,wantToTryX,hasBottlesX,hasTastingsX,wantToBuyX,wantToSellX,hasBuyersX,hasSellersX,hasUserCommentsX,isOfInterestIndirect,purchaseCount,createDate,bottleLocations,notYetCellared,notYetCellaredBottleCount,notYetCellaredR,notYetCellaredX,toBeDelivered,toBeDeliveredBottleCount,toBeDeliveredR,toBeDeliveredX,valuation)
		select @saveName
			,whN,wineN,isOfInterestShow,wantToTryShow,hasBottlesShow,hasTastingsShow,wantToBuyShow,wantToSellShow,hasBuyersShow,hasSellersShow,hasUserCommentsShow,isOfInterest,wantToTry,bottleCount,hasMoreDetail,tastingCount,wantToSellBottleCount,wantToBuyBottleCount,buyerCount,sellerCount,userComments,isOfInterestR,wantToTryR,hasBottlesR,hasTastingsR,wantToBuyR,wantToSellR,hasBuyersR,hasSellersR,hasUserCommentsR,locationN,hasHadStuff,isDerived,warnings,isOfInterestX,wantToTryX,hasBottlesX,hasTastingsX,wantToBuyX,wantToSellX,hasBuyersX,hasSellersX,hasUserCommentsX,isOfInterestIndirect,purchaseCount,createDate,bottleLocations,notYetCellared,notYetCellaredBottleCount,notYetCellaredR,notYetCellaredX,toBeDelivered,toBeDeliveredBottleCount,toBeDeliveredR,toBeDeliveredX,valuation
		from whToWine where whN = @whN
  
 
insert into savedTables..whToTrustedPub(
		saveName
			, whN, pubN, isDerived, createDate)
		select @saveName
			, whN, pubN, isDerived, createDate
		from whToTrustedPub where whN=@whN
 
 
insert into savedTables..whToTrustedTaster(
		saveName
			, whN, tasterN, isDerived, createDate)
		select @saveName
			, whN, tasterN, isDerived, createDate
		from whToTrustedTaster where whN=@whN
 
 
--declare @whN int = 20, @savename varchar(max) = 'xxtest'
set identity_insert savedTables..Location on
insert into savedTables..Location(
		saveName
			, locationN,whN,parentLocationN,prevItemIndex,name,currentBottleCount,maxBottleCount,isBottle,purchaseN,bottleCountHere,bottleCountAvailable,createDate,updateDate,hasManyWines,locationCapacity)
		select @saveName
			,locationN,whN,parentLocationN,prevItemIndex,name,currentBottleCount,maxBottleCount,isBottle,purchaseN,bottleCountHere,bottleCountAvailable,createDate,updateDate,hasManyWines,locationCapacity
		from Location where whN = @whN
set identity_insert savedTables..Location off
 
 
set identity_insert savedTables..Purchase on
insert into savedTables..Purchase(saveName, purchaseN,whN,wineN,supplierN,bottleSizeN,purchaseDate,deliveryDate,pricePerBottle,bottleCount,bottlesRemaining,notes,createDate,updateDate)
	                       select @saveName,purchaseN,whN,wineN,supplierN,bottleSizeN,purchaseDate,deliveryDate,pricePerBottle,bottleCount,bottlesRemaining,notes,createDate,updateDate
		from Purchase where whN = @whN
set identity_insert savedTables..Purchase off
 
 
 
set identity_insert savedTables..Supplier on
insert into savedTables..Supplier(saveName, supplierN,standardSupplierN,whN,name,notes,createDate,updateDate)
	                       select @saveName,supplierN,standardSupplierN,whN,name,notes,createDate,updateDate
		from Supplier where whN = @whN
set identity_insert savedTables..Supplier off
 
set noCount off
end
 
 
 
 
