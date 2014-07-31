-- zapUser     saveUser     restoreUser		[=]
CREATE proc [dbo].[restoreUser_oldSep4-2009](@whN int, @saveName nvarChar(50))
as begin
 
set noCount on
 
--declare @whN int = 20, @saveName nvarchar(max) = 'ccc'
delete from whToWine where whN = @whN
delete from tasting where tasterN = @whN
delete from erpCellar..bottleLocation  where whN = @whN
delete from erpCellar..Location where whN = @whN;
delete from erpCellar..Purchase where whN = @whN
delete from erpCellar..Supplier where whN = @whN
 
--whToWine needs to be first otherwise insert tastings creates stub records
insert into whToWine(whN,wineN,isOfInterestShow,wantToTryShow,hasBottlesShow,hasTastingsShow,wantToBuyShow,wantToSellShow,hasBuyersShow,hasSellersShow,hasUserCommentsShow,isOfInterest,wantToTry,purchaseCount,bottleCount,hasMoreDetail,tastingCount,wantToSellBottleCount,wantToBuyBottleCount,buyerCount,sellerCount,userComments,isOfInterestR,wantToTryR,hasBottlesR,hasTastingsR,wantToBuyR,wantToSellR,hasBuyersR,hasSellersR,hasUserCommentsR,locationN,hasHadStuff,isDerived,warnings,isOfInterestX,wantToTryX,hasBottlesX,hasTastingsX,wantToBuyX,wantToSellX,hasBuyersX,hasSellersX,hasUserCommentsX,isOfInterestIndirect)
	                       select whN,wineN,isOfInterestShow,wantToTryShow,hasBottlesShow,hasTastingsShow,wantToBuyShow,wantToSellShow,hasBuyersShow,hasSellersShow,hasUserCommentsShow,isOfInterest,wantToTry,purchaseCount,bottleCount,hasMoreDetail,tastingCount,wantToSellBottleCount,wantToBuyBottleCount,buyerCount,sellerCount,userComments,isOfInterestR,wantToTryR,hasBottlesR,hasTastingsR,wantToBuyR,wantToSellR,hasBuyersR,hasSellersR,hasUserCommentsR,locationN,hasHadStuff,isDerived,warnings,isOfInterestX,wantToTryX,hasBottlesX,hasTastingsX,wantToBuyX,wantToSellX,hasBuyersX,hasSellersX,hasUserCommentsX,isOfInterestIndirect
		from savedTables..whToWine where whN = @whN and saveName = @saveName
 
set identity_insert tasting on
insert into tasting(tastingN,wineN,vinN,wineNameN,pubN,pubDate,issue,pages,articleId,_x_articleIdNKey,articleOrder,articleURL,notes,tasterN,tasteDate,isMostRecentTasting,isNoTasting,isActiveForThisPub,_x_IsActiveWineN,isBorrowedDrinkDate,IsBarrelTasting,bottleSizeN,rating,ratingPlus,ratingHi,ratingShow,drinkDate,drinkDateHi,drinkWhenN,maturityN,estimatedCostLo,estimatedCostHi,originalCurrencyN,provenanceN,whereTastedN,isAvailabeToTastersGroups,isPostedToBB,isAnnonymous,isPrivate,updateWhN,_clumpName,_fixedId,_x_hasAGalloniTasting,_x_HasCurrentPrice,_x_hasDSchildknechtTasting,_x_hasDThomasesTasting,_x_hasErpTasting,_x_hasJMillerTasting,_x_hasMSquiresTasting,_x_hasMultipleWATastings,_x_hasNMartinTasting,_x_hasProducerProfile,_x_HasProducerWebSite,_x_hasPRovaniTasting,_x_hasRParkerTasting,_x_hasWJtasting,_x_reviewerIdN,ratingQ,createDate,createWh,isInactive,articleMasterN,decantedN)
	select tastingN,wineN,vinN,wineNameN,pubN,pubDate,issue,pages,articleId,_x_articleIdNKey,articleOrder,articleURL,notes,tasterN,tasteDate,isMostRecentTasting,isNoTasting,isActiveForThisPub,_x_IsActiveWineN,isBorrowedDrinkDate,IsBarrelTasting,bottleSizeN,rating,ratingPlus,ratingHi,ratingShow,drinkDate,drinkDateHi,drinkWhenN,maturityN,estimatedCostLo,estimatedCostHi,originalCurrencyN,provenanceN,whereTastedN,isAvailabeToTastersGroups,isPostedToBB,isAnnonymous,isPrivate,updateWhN,_clumpName,_fixedId,_x_hasAGalloniTasting,_x_HasCurrentPrice,_x_hasDSchildknechtTasting,_x_hasDThomasesTasting,_x_hasErpTasting,_x_hasJMillerTasting,_x_hasMSquiresTasting,_x_hasMultipleWATastings,_x_hasNMartinTasting,_x_hasProducerProfile,_x_HasProducerWebSite,_x_hasPRovaniTasting,_x_hasRParkerTasting,_x_hasWJtasting,_x_reviewerIdN,ratingQ,createDate,createWh,isInactive,articleMasterN,decantedN
		from savedTables..tasting where tasterN = @whN and saveName = @saveName
set identity_insert tasting off
 
set identity_insert erpCellar..Supplier on
insert into erpCellar..Supplier(supplierN,standardSupplierN,whN,name,notes,createDate,updateDate)
	                       select supplierN,standardSupplierN,whN,name,notes,createDate,updateDate
		from savedTables..Supplier where whN = @whN and saveName = @saveName
set identity_insert erpCellar..Supplier off
 
set identity_insert erpCellar..Location on
insert into erpCellar..Location(locationN,whN,parentLocationN,prevItemIndex,name,createDate,updateDate)
	                       select locationN,whN,parentLocationN,prevItemIndex,name,createDate,updateDate
		from savedTables..Location where whN = @whN and saveName = @saveName
set identity_insert erpCellar..Location off
 
set identity_insert erpCellar..Purchase on
insert into erpCellar..Purchase(purchaseN,whN,wineN,supplierN,bottleSizeN,purchaseDate,deliveryDate,pricePerBottle,bottleCount,bottlesRemaining,notes,createDate,updateDate)
	                       select purchaseN,whN,wineN,supplierN,bottleSizeN,purchaseDate,deliveryDate,pricePerBottle,bottleCount,bottlesRemaining,notes,createDate,updateDate
		from savedTables..Purchase where whN = @whN and saveName = @saveName
set identity_insert erpCellar..Purchase off
 
set identity_insert erpCellar..BottleLocation on
insert into erpCellar..BottleLocation(bottleLocationN,whN,locationN,prevItemIndex,purchaseN,bottleCountHere,bottleCountAvailable,createDate,updateDate)
	                       select bottleLocationN,whN,locationN,prevItemIndex,purchaseN,bottleCountHere,bottleCountAvailable,createDate,updateDate
		from savedTables..BottleLocation where whN = @whN and saveName = @saveName
set identity_insert erpCellar..BottleLocation off
 
set noCount off
 
end
 
/*
 
use erp
erp.dbo.saveUser 20, 'ccc'
 
erp.dbo.restoreUser 20, 'ccc'
erp.dbo.showMyCounts 20
 
 
*/
 
 
