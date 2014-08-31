

 
 
------------------------------------------------------------------------------------------------------------------------------
-- saveUser
------------------------------------------------------------------------------------------------------------------------------
 
-- zapUser     saveUser     restoreUser		[=]
CREATE proc [dbo].[CopyCellar](@whN int,@AdminwhN int, @saveName nvarChar(50))
as begin
--declare @whN int = 20, @saveName nvarChar(50) = 'Foo'
 
set noCount on
set ansi_padding on
 
 
delete from storage..BottleConsumed where saveName=@saveName and whN=@whN  and adminWhN=@AdminwhN
insert into storage..BottleConsumed(saveName,id,whN,numberOfBottles,locationN,purchaseN,consumeDate,handle,rowVersion,adminWhN) select @saveName,id,whN,numberOfBottles,locationN,purchaseN,consumeDate,handle,rowVersion,@adminWhN from BottleConsumed where whN=@whN
delete from storage..tasting where saveName=@saveName and tastingN=@whN and adminWhN=@AdminwhN
insert into storage..tasting(saveName,tastingN,wineN,vinN,wineNameN,pubN,pubDate,issue,pages,articleId,_x_articleIdNKey,articleOrder,articleURL,notes,tasterN,tasteDate,isMostRecentTasting,isNoTasting,isActiveForThisPub,_x_IsActiveWineN,isBorrowedDrinkDate,IsBarrelTasting,bottleSizeN,rating,ratingPlus,ratingHi,ratingShow,drinkDate,drinkDateHi,drinkWhenN,maturityN,estimatedCostLo,estimatedCostHi,originalCurrencyN,provenanceN,whereTastedN,isAvailabeToTastersGroups,isPostedToBB,isAnnonymous,isPrivate,updateWhN,_clumpName,_fixedId,_x_hasAGalloniTasting,_x_HasCurrentPrice,_x_hasDSchildknechtTasting,_x_hasDThomasesTasting,_x_hasErpTasting,_x_hasJMillerTasting,_x_hasMSquiresTasting,_x_hasMultipleWATastings,_x_hasNMartinTasting,_x_hasProducerProfile,_x_HasProducerWebSite,_x_hasPRovaniTasting,_x_hasRParkerTasting,_x_hasWJtasting,_x_reviewerIdN,ratingQ,createDate,createWh,rowversion,isInactive,articleMasterN,decantedN,isApproved,hasUserComplaint,updateDate,hasHad,userComplaintCount,hasRating,isErpTasting,ParkerZralyLevel,sourceIconN,isProTasting,canBeActiveTasting,_x_showForERP,_x_showForWJ,_fixedIdDeleted,dataIdN,dataIdNDeleted,dataSourceN,handle,adminWhN) select @saveName,tastingN,wineN,vinN,wineNameN,pubN,pubDate,issue,pages,articleId,_x_articleIdNKey,articleOrder,articleURL,notes,tasterN,tasteDate,isMostRecentTasting,isNoTasting,isActiveForThisPub,_x_IsActiveWineN,isBorrowedDrinkDate,IsBarrelTasting,bottleSizeN,rating,ratingPlus,ratingHi,ratingShow,drinkDate,drinkDateHi,drinkWhenN,maturityN,estimatedCostLo,estimatedCostHi,originalCurrencyN,provenanceN,whereTastedN,isAvailabeToTastersGroups,isPostedToBB,isAnnonymous,isPrivate,updateWhN,_clumpName,_fixedId,_x_hasAGalloniTasting,_x_HasCurrentPrice,_x_hasDSchildknechtTasting,_x_hasDThomasesTasting,_x_hasErpTasting,_x_hasJMillerTasting,_x_hasMSquiresTasting,_x_hasMultipleWATastings,_x_hasNMartinTasting,_x_hasProducerProfile,_x_HasProducerWebSite,_x_hasPRovaniTasting,_x_hasRParkerTasting,_x_hasWJtasting,_x_reviewerIdN,ratingQ,createDate,createWh,rowversion,isInactive,articleMasterN,decantedN,isApproved,hasUserComplaint,updateDate,hasHad,userComplaintCount,hasRating,isErpTasting,ParkerZralyLevel,sourceIconN,isProTasting,canBeActiveTasting,_x_showForERP,_x_showForWJ,_fixedIdDeleted,dataIdN,dataIdNDeleted,dataSourceN,handle,@adminWhN from tasting where tastingN=@whN
delete from storage..whToWine where saveName=@saveName and whN=@whN and adminWhN=@AdminwhN
insert into storage..whToWine(saveName,whN,wineN,isOfInterestShow,wantToTryShow,hasBottlesShow,hasTastingsShow,wantToBuyShow,wantToSellShow,hasBuyersShow,hasSellersShow,hasUserCommentsShow,isOfInterest,wantToTry,bottleCount,hasMoreDetail,tastingCount,wantToSellBottleCount,wantToBuyBottleCount,buyerCount,sellerCount,userComments,isOfInterestR,wantToTryR,hasBottlesR,hasTastingsR,wantToBuyR,wantToSellR,hasBuyersR,hasSellersR,hasUserCommentsR,rowversion,locationN,hasHadStuff,isDerived,warnings,isOfInterestX,wantToTryX,hasBottlesX,hasTastingsX,wantToBuyX,wantToSellX,hasBuyersX,hasSellersX,hasUserCommentsX,isOfInterestIndirect,purchaseCount,createDate,bottleLocations,valuation,toBeDelivered,notYetCellared,toBeDeliveredR,notYetCellaredR,toBeDeliveredX,notYetCellaredX,toBeDeliveredBottleCount,notYetCellaredBottleCount,toBeDeliveredShow,notYetCellaredShow,consumedCount,mostRecentDeliveryDate,hasBottles,handle,adminWhN) select @saveName,whN,wineN,isOfInterestShow,wantToTryShow,hasBottlesShow,hasTastingsShow,wantToBuyShow,wantToSellShow,hasBuyersShow,hasSellersShow,hasUserCommentsShow,isOfInterest,wantToTry,bottleCount,hasMoreDetail,tastingCount,wantToSellBottleCount,wantToBuyBottleCount,buyerCount,sellerCount,userComments,isOfInterestR,wantToTryR,hasBottlesR,hasTastingsR,wantToBuyR,wantToSellR,hasBuyersR,hasSellersR,hasUserCommentsR,rowversion,locationN,hasHadStuff,isDerived,warnings,isOfInterestX,wantToTryX,hasBottlesX,hasTastingsX,wantToBuyX,wantToSellX,hasBuyersX,hasSellersX,hasUserCommentsX,isOfInterestIndirect,purchaseCount,createDate,bottleLocations,valuation,toBeDelivered,notYetCellared,toBeDeliveredR,notYetCellaredR,toBeDeliveredX,notYetCellaredX,toBeDeliveredBottleCount,notYetCellaredBottleCount,toBeDeliveredShow,notYetCellaredShow,consumedCount,mostRecentDeliveryDate,hasBottles,handle,@adminWhN from whToWine where whN=@whN
delete from storage..whToTrustedTaster where saveName=@saveName and whN=@whN and adminWhN=@AdminwhN
insert into storage..whToTrustedTaster(saveName,whN,tasterN,isDerived,createDate,rowVersion,handle,adminWhN) select @saveName,whN,tasterN,isDerived,createDate,rowVersion,handle,@adminWhN from whToTrustedTaster where whN=@whN
delete from storage..whToTrustedPub where saveName=@saveName and whN=@whN and adminWhN=@AdminwhN
insert into storage..whToTrustedPub(saveName,whN,pubN,isDerived,createDate,rowVersion,handle,adminWhN) select @saveName,whN,pubN,isDerived,createDate,rowVersion,handle,@adminWhN from whToTrustedPub where whN=@whN
delete from storage..Location where saveName=@saveName and whN=@whN and adminWhN=@AdminwhN
insert into storage..Location(saveName,locationN,whN,parentLocationN,prevItemIndex,name,currentBottleCount,maxBottleCount,isBottle,purchaseN,bottleCountHere,bottleCountAvailable,createDate,updateDate,hasManyWines,locationCapacity,handle,rowVersion,adminWhN) select @saveName,locationN,whN,parentLocationN,prevItemIndex,name,currentBottleCount,maxBottleCount,isBottle,purchaseN,bottleCountHere,bottleCountAvailable,createDate,updateDate,hasManyWines,locationCapacity,handle,rowVersion,@adminWhN from Location where whN=@whN
delete from storage..Purchase where saveName=@saveName and whN=@whN and adminWhN=@AdminwhN
insert into storage..Purchase(saveName,purchaseN,whN,wineN,supplierN,bottleSizeN,purchaseDate,deliveryDate,pricePerBottle,bottleCount,notes,createDate,updateDate,bottleCountBought,handle,rowVersion,adminWhN) select @saveName,purchaseN,whN,wineN,supplierN,bottleSizeN,purchaseDate,deliveryDate,pricePerBottle,bottleCount,notes,createDate,updateDate,bottleCountBought,handle,rowVersion,@adminWhN from Purchase where whN=@whN
delete from storage..Supplier where saveName=@saveName and whN=@whN and adminWhN=@AdminwhN
insert into storage..Supplier(saveName,supplierN,whN,name,notes,createDate,updateDate,standardSupplierN,retailerN,handle,rowVersion,adminWhN) select @saveName,supplierN,whN,name,notes,createDate,updateDate,standardSupplierN,retailerN,handle,rowVersion,@adminWhN from Supplier where whN=@whN
 
delete from storage..savedVersions where saveName=@saveName and whN=@whN and adminWhN=@AdminwhN
insert into storage..savedVersions (whN,adminWhN,saveName,dateCreated) values (@whN,@AdminwhN ,@saveName ,GETDATE() )
 
set noCount off
end
 
/*
saveUser 22,'poo'
select * from savedTables..location order by locationN, saveName
*/
 
 
 
 








