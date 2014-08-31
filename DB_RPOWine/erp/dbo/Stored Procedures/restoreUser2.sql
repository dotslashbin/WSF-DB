 
-- zapUser     saveUser     restoreUser		[=]
CREATE proc [dbo].[restoreUser2](@fromWhN int, @toWhN int, @saveName nvarChar(50))
as begin
 
set noCount on
 
--declare @whN int = 20, @saveName nvarchar(max) = 'Foo'
delete from whToWine where whN = @toWhN
delete from whToTrustedPub where whN=@toWhN
delete from whToTrustedTaster where whN=@toWhN
delete from tasting where tasterN = @toWhN
delete from bottleLocation  where whN = @toWhN
delete from Location where whN = @toWhN;
delete from Purchase where whN = @toWhN
delete from Supplier where whN = @toWhN
 
--whToWine needs to be first otherwise insert tastings creates stub records
--declare @whN int = 20, @saveName nvarChar(50) = 'Foo'
insert into whToWine(whN,wineN,isOfInterestShow,wantToTryShow,hasBottlesShow,hasTastingsShow,wantToBuyShow,wantToSellShow,hasBuyersShow,hasSellersShow,hasUserCommentsShow,isOfInterest,wantToTry,bottleCount,hasMoreDetail,tastingCount,wantToSellBottleCount,wantToBuyBottleCount,buyerCount,sellerCount,userComments,isOfInterestR,wantToTryR,hasBottlesR,hasTastingsR,wantToBuyR,wantToSellR,hasBuyersR,hasSellersR,hasUserCommentsR,locationN,hasHadStuff,isDerived,warnings,isOfInterestX,wantToTryX,hasBottlesX,hasTastingsX,wantToBuyX,wantToSellX,hasBuyersX,hasSellersX,hasUserCommentsX,isOfInterestIndirect,purchaseCount,createDate)
	                       select @toWhN,wineN,isOfInterestShow,wantToTryShow,hasBottlesShow,hasTastingsShow,wantToBuyShow,wantToSellShow,hasBuyersShow,hasSellersShow,hasUserCommentsShow,isOfInterest,wantToTry,bottleCount,hasMoreDetail,tastingCount,wantToSellBottleCount,wantToBuyBottleCount,buyerCount,sellerCount,userComments,isOfInterestR,wantToTryR,hasBottlesR,hasTastingsR,wantToBuyR,wantToSellR,hasBuyersR,hasSellersR,hasUserCommentsR,locationN,hasHadStuff,isDerived,warnings,isOfInterestX,wantToTryX,hasBottlesX,hasTastingsX,wantToBuyX,wantToSellX,hasBuyersX,hasSellersX,hasUserCommentsX,isOfInterestIndirect,purchaseCount,createDate
		from savedTables..whToWine where whN = @fromWhN and saveName = @saveName
 
 
insert into whToTrustedPub(whN, pubN, isDerived, createDate)
	select @toWhN, pubN, isDerived, createDate
		from savedTables..whToTrustedPub where whN=@fromWhN and saveName = @saveName
 
insert into whToTrustedTaster(whN, TasterN, isDerived, createDate)
	select @toWhN, TasterN, isDerived, createDate
		from savedTables..whToTrustedTaster where whN=@fromWhN and saveName = @saveName
 
 
set identity_insert tasting on
insert into tasting(tastingN,wineN,vinN,wineNameN,pubN,pubDate,issue,pages,articleId,_x_articleIdNKey,articleOrder,articleURL,notes,tasterN,tasteDate,isMostRecentTasting,isNoTasting,isActiveForThisPub,_x_IsActiveWineN,isBorrowedDrinkDate,IsBarrelTasting,bottleSizeN,rating,ratingPlus,ratingHi,ratingShow,drinkDate,drinkDateHi,drinkWhenN,maturityN,estimatedCostLo,estimatedCostHi,originalCurrencyN,provenanceN,whereTastedN,isAvailabeToTastersGroups,isPostedToBB,isAnnonymous,isPrivate,updateWhN,_clumpName,_fixedId,_x_hasAGalloniTasting,_x_HasCurrentPrice,_x_hasDSchildknechtTasting,_x_hasDThomasesTasting,_x_hasErpTasting,_x_hasJMillerTasting,_x_hasMSquiresTasting,_x_hasMultipleWATastings,_x_hasNMartinTasting,_x_hasProducerProfile,_x_HasProducerWebSite,_x_hasPRovaniTasting,_x_hasRParkerTasting,_x_hasWJtasting,_x_reviewerIdN,ratingQ,createDate,createWh,isInactive,articleMasterN,decantedN,isApproved,hasUserComplaint,updateDate,hasHad,userComplaintCount,hasRating,isErpTasting,ParkerZralyLevel,sourceIconN,isProTasting)
	select tastingN,wineN,vinN,wineNameN,pubN,pubDate,issue,pages,articleId,_x_articleIdNKey,articleOrder,articleURL,notes,tasterN,tasteDate,isMostRecentTasting,isNoTasting,isActiveForThisPub,_x_IsActiveWineN,isBorrowedDrinkDate,IsBarrelTasting,bottleSizeN,rating,ratingPlus,ratingHi,ratingShow,drinkDate,drinkDateHi,drinkWhenN,maturityN,estimatedCostLo,estimatedCostHi,originalCurrencyN,provenanceN,whereTastedN,isAvailabeToTastersGroups,isPostedToBB,isAnnonymous,isPrivate,updateWhN,_clumpName,_fixedId,_x_hasAGalloniTasting,_x_HasCurrentPrice,_x_hasDSchildknechtTasting,_x_hasDThomasesTasting,_x_hasErpTasting,_x_hasJMillerTasting,_x_hasMSquiresTasting,_x_hasMultipleWATastings,_x_hasNMartinTasting,_x_hasProducerProfile,_x_HasProducerWebSite,_x_hasPRovaniTasting,_x_hasRParkerTasting,_x_hasWJtasting,_x_reviewerIdN,ratingQ,createDate,createWh,isInactive,articleMasterN,decantedN,isApproved,hasUserComplaint,updateDate,hasHad,userComplaintCount,hasRating,isErpTasting,ParkerZralyLevel,sourceIconN,isProTasting
		from savedTables..tasting where tasterN = @fromWhN and saveName = @saveName
set identity_insert tasting off
 
set identity_insert Supplier on
insert into Supplier(supplierN,standardSupplierN,whN,name,notes,createDate,updateDate)
	                       select supplierN,standardSupplierN,@toWhN,name,notes,createDate,updateDate
		from savedTables..Supplier where whN = @fromWhN and saveName = @saveName
set identity_insert Supplier off
 
set identity_insert Location on
insert into Location(locationN,whN,parentLocationN,prevItemIndex,name,currentBottleCount,maxBottleCount,isBottle,purchaseN,bottleCountHere,bottleCountAvailable,createDate,updateDate)
	                       select locationN,@toWhN,parentLocationN,prevItemIndex,name,currentBottleCount,maxBottleCount,isBottle,purchaseN,bottleCountHere,bottleCountAvailable,createDate,updateDate
		from savedTables..Location where whN = @fromWhN and saveName = @saveName
set identity_insert Location off
 
set identity_insert Purchase on
insert into Purchase(purchaseN,whN,wineN,supplierN,bottleSizeN,purchaseDate,deliveryDate,pricePerBottle,bottleCount,bottlesRemaining,notes,createDate,updateDate)
	                       select purchaseN,@toWhN,wineN,supplierN,bottleSizeN,purchaseDate,deliveryDate,pricePerBottle,bottleCount,bottlesRemaining,notes,createDate,updateDate
		from savedTables..Purchase where whN = @fromWhN and saveName = @saveName
set identity_insert Purchase off
 
/*
set identity_insert BottleLocation on
insert into BottleLocation(bottleLocationN,whN,locationN,prevItemIndex,purchaseN,bottleCountHere,bottleCountAvailable,createDate,updateDate)
	                       select bottleLocationN,@toWhN,locationN,prevItemIndex,purchaseN,bottleCountHere,bottleCountAvailable,createDate,updateDate
		from savedTables..BottleLocation where whN = @fromWhN and saveName = @saveName
set identity_insert BottleLocation off
*/
 
set noCount off
 
end
 
/*
 
use erp
erp.dbo.saveUser 20, 'ccc'
 
erp.dbo.restoreUser 20, 'ccc'
erp.dbo.showMyCounts 20
 
 
select * from savedTables..tasting where tasterN=20
 
 
oofr coun

os wh, 'where fullName like ''%flower%'''
	Doug1 Flower [#18264]
	
restoreUser2 20, 18264, 'Transfer'
 
*/
 
 
 
 
 
 
 
