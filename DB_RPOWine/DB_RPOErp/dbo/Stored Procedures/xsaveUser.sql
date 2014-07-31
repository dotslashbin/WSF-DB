 
-- zapUser     saveUser     restoreUser		[=]
CREATE proc [dbo].[xsaveUser](@whN int, @saveName nvarChar(50))
as begin

--declare @whN int = 20, @saveName nvarChar(50) = 'Foo'

set noCount on
 
delete from savedTables..tasting where tasterN = @whN and saveName = @saveName;
delete from savedTables..whToWine where whN = @whN and saveName = @saveName;

delete from savedTables..whToTrustedTaster where whN = @whN and saveName = @saveName;
delete from savedTables..whToTrustedPub where whN = @whN and saveName = @saveName;

delete from savedTables..BottleLocation  where whN = @whN and saveName = @saveName;
delete from savedTables..Location where whN = @whN and saveName = @saveName;
delete from savedTables..Purchase where whN = @whN and saveName = @saveName;
delete from savedTables..Supplier where whN = @whN and saveName = @saveName;
 
set identity_insert savedTables..tasting on
insert into savedTables..tasting(
saveName, 
tastingN,wineN,vinN,wineNameN,pubN,pubDate,issue,pages,articleId,_x_articleIdNKey,articleOrder,articleURL,notes,tasterN,tasteDate,isMostRecentTasting,isNoTasting,isActiveForThisPub,_x_IsActiveWineN,isBorrowedDrinkDate,IsBarrelTasting,bottleSizeN,rating,ratingPlus,ratingHi,ratingShow,drinkDate,drinkDateHi,drinkWhenN,maturityN,estimatedCostLo,estimatedCostHi,originalCurrencyN,provenanceN,whereTastedN,isAvailabeToTastersGroups,isPostedToBB,isAnnonymous,isPrivate,updateWhN,_clumpName,_fixedId,_x_hasAGalloniTasting,_x_HasCurrentPrice,_x_hasDSchildknechtTasting,_x_hasDThomasesTasting,_x_hasErpTasting,_x_hasJMillerTasting,_x_hasMSquiresTasting,_x_hasMultipleWATastings,_x_hasNMartinTasting,_x_hasProducerProfile,_x_HasProducerWebSite,_x_hasPRovaniTasting,_x_hasRParkerTasting,_x_hasWJtasting,_x_reviewerIdN,ratingQ,createDate,createWh,isInactive,articleMasterN,decantedN)
	select @saveName	, tastingN,wineN,vinN,wineNameN,pubN,pubDate,issue,pages,articleId,_x_articleIdNKey,articleOrder,articleURL,notes,tasterN,tasteDate,isMostRecentTasting,isNoTasting,isActiveForThisPub,_x_IsActiveWineN,isBorrowedDrinkDate,IsBarrelTasting,bottleSizeN,rating,ratingPlus,ratingHi,ratingShow,drinkDate,drinkDateHi,drinkWhenN,maturityN,estimatedCostLo,estimatedCostHi,originalCurrencyN,provenanceN,whereTastedN,isAvailabeToTastersGroups,isPostedToBB,isAnnonymous,isPrivate,updateWhN,_clumpName,_fixedId,_x_hasAGalloniTasting,_x_HasCurrentPrice,_x_hasDSchildknechtTasting,_x_hasDThomasesTasting,_x_hasErpTasting,_x_hasJMillerTasting,_x_hasMSquiresTasting,_x_hasMultipleWATastings,_x_hasNMartinTasting,_x_hasProducerProfile,_x_HasProducerWebSite,_x_hasPRovaniTasting,_x_hasRParkerTasting,_x_hasWJtasting,_x_reviewerIdN,ratingQ,createDate,createWh,isInactive,articleMasterN,decantedN
		from tasting where tasterN = @whN
set identity_insert savedTables..tasting off
 
--declare @whN int = 20, @saveName nvarchar(50) = 'aaa'
insert into savedTables..whToWine(saveName, whN,wineN,isOfInterestShow,wantToTryShow,hasBottlesShow,hasTastingsShow,wantToBuyShow,wantToSellShow,hasBuyersShow,hasSellersShow,hasUserCommentsShow,isOfInterest,wantToTry,purchaseCount, bottleCount,hasMoreDetail,tastingCount,wantToSellBottleCount,wantToBuyBottleCount,buyerCount,sellerCount,userComments,isOfInterestR,wantToTryR,hasBottlesR,hasTastingsR,wantToBuyR,wantToSellR,hasBuyersR,hasSellersR,hasUserCommentsR,locationN,hasHadStuff,isDerived,warnings,isOfInterestX,wantToTryX,hasBottlesX,hasTastingsX,wantToBuyX,wantToSellX,hasBuyersX,hasSellersX,hasUserCommentsX,isOfInterestIndirect)
	                       select @saveName,whN,wineN,isOfInterestShow,wantToTryShow,hasBottlesShow,hasTastingsShow,wantToBuyShow,wantToSellShow,hasBuyersShow,hasSellersShow,hasUserCommentsShow,isOfInterest,wantToTry,purchaseCount,bottleCount,hasMoreDetail,tastingCount,wantToSellBottleCount,wantToBuyBottleCount,buyerCount,sellerCount,userComments,isOfInterestR,wantToTryR,hasBottlesR,hasTastingsR,wantToBuyR,wantToSellR,hasBuyersR,hasSellersR,hasUserCommentsR,locationN,hasHadStuff,isDerived,warnings,isOfInterestX,wantToTryX,hasBottlesX,hasTastingsX,wantToBuyX,wantToSellX,hasBuyersX,hasSellersX,hasUserCommentsX,isOfInterestIndirect
		from whToWine where whN = @whN





--set identity_insert savedTables..whToTrustedPub on
insert into savedTables..whToTrustedPub(saveName, whN, pubN, isDerived, dateCreated)
	select @saveName, whN, pubN, isDerived, dateCreated
		from whToTrustedPub where whN=@whN
--set identity_insert savedTables..whToTrustedPub on



--set identity_insert savedTables..whToTrustedTaster on
insert into savedTables..whToTrustedTaster(saveName, whN, tasterN, isDerived, dateCreated)
	select @saveName, whN, tasterN, isDerived, dateCreated
		from whToTrustedTaster where whN=@whN
--set identity_insert savedTables..whToTrustedTaster on








set identity_insert savedTables..BottleLocation on
insert into savedTables..BottleLocation(saveName, bottleLocationN,whN,locationN,prevItemIndex,purchaseN,bottleCountHere,bottleCountAvailable,createDate,updateDate)
	                       select @saveName,bottleLocationN,whN,locationN,prevItemIndex,purchaseN,bottleCountHere,bottleCountAvailable,createDate,updateDate
		from BottleLocation where whN = @whN
set identity_insert savedTables..BottleLocation off
 
set identity_insert savedTables..Location on
insert into savedTables..Location(saveName, locationN,whN,parentLocationN,prevItemIndex,name,createDate,updateDate)
	                       select @saveName,locationN,whN,parentLocationN,prevItemIndex,name,createDate,updateDate
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
 
