------------------------------------------------------------------------------------------------------------------------------
-- loadFromSave
------------------------------------------------------------------------------------------------------------------------------
CREATE proc [dbo].[loadFromSave](@fromWhN int,@saveName nvarChar(50),@toWhN int)
as begin
 
set noCount on
set ansi_padding on
 
--declare @toWhN int = 20, @saveName nvarchar(max) = 'Foo'
delete from tasting where tasterN=@toWhN
delete from whToWine where whN=@toWhN
delete from whToTrustedTaster where whN=@toWhN
delete from whToTrustedPub where whN=@toWhN
delete from Purchase where whN=@toWhN
delete from BottleConsumed where whN=@toWhN
delete from Location where whN=@toWhN
delete from Supplier where whN=@toWhN
 
insert into whToWine(whN,wineN,isOfInterestShow,wantToTryShow,hasBottlesShow,hasTastingsShow,wantToBuyShow,wantToSellShow,hasBuyersShow,hasSellersShow,hasUserCommentsShow,isOfInterest,wantToTry,bottleCount,hasMoreDetail,tastingCount,wantToSellBottleCount,wantToBuyBottleCount,buyerCount,sellerCount,userComments,isOfInterestR,wantToTryR,hasBottlesR,hasTastingsR,wantToBuyR,wantToSellR,hasBuyersR,hasSellersR,hasUserCommentsR,locationN,hasHadStuff,isDerived,warnings,isOfInterestX,wantToTryX,hasBottlesX,hasTastingsX,wantToBuyX,wantToSellX,hasBuyersX,hasSellersX,hasUserCommentsX,isOfInterestIndirect,purchaseCount,createDate,bottleLocations,valuation,toBeDelivered,notYetCellared,toBeDeliveredR,notYetCellaredR,toBeDeliveredX,notYetCellaredX,toBeDeliveredBottleCount,notYetCellaredBottleCount,toBeDeliveredShow,notYetCellaredShow,consumedCount,mostRecentDeliveryDate,hasBottles)
	select @toWhN,wineN,isOfInterestShow,wantToTryShow,hasBottlesShow,hasTastingsShow,wantToBuyShow,wantToSellShow,hasBuyersShow,hasSellersShow,hasUserCommentsShow,isOfInterest,wantToTry,bottleCount,hasMoreDetail,tastingCount,wantToSellBottleCount,wantToBuyBottleCount,buyerCount,sellerCount,userComments,isOfInterestR,wantToTryR,hasBottlesR,hasTastingsR,wantToBuyR,wantToSellR,hasBuyersR,hasSellersR,hasUserCommentsR,locationN,hasHadStuff,isDerived,warnings,isOfInterestX,wantToTryX,hasBottlesX,hasTastingsX,wantToBuyX,wantToSellX,hasBuyersX,hasSellersX,hasUserCommentsX,isOfInterestIndirect,purchaseCount,createDate,bottleLocations,valuation,toBeDelivered,notYetCellared,toBeDeliveredR,notYetCellaredR,toBeDeliveredX,notYetCellaredX,toBeDeliveredBottleCount,notYetCellaredBottleCount,toBeDeliveredShow,notYetCellaredShow,consumedCount,mostRecentDeliveryDate,hasBottles
		from SavedTables..whToWine
		where saveName = @saveName and whN=@fromWhN
		order by rowVersion asc
insert into whToTrustedTaster(whN,tasterN,isDerived,createDate)
	select @toWhN,tasterN,isDerived,createDate
		from SavedTables..whToTrustedTaster
		where saveName = @saveName and whN=@fromWhN
		order by rowVersion asc
insert into whToTrustedPub(whN,pubN,isDerived,createDate)
	select @toWhN,pubN,isDerived,createDate
		from SavedTables..whToTrustedPub
		where saveName = @saveName and whN=@fromWhN
		order by rowVersion asc
insert into tasting(handle,wineN,vinN,wineNameN,pubN,pubDate,issue,pages,articleId,_x_articleIdNKey,articleOrder,articleURL,notes,tasterN,tasteDate,isMostRecentTasting,isNoTasting,isActiveForThisPub,_x_IsActiveWineN,isBorrowedDrinkDate,IsBarrelTasting,bottleSizeN,rating,ratingPlus,ratingHi,ratingShow,drinkDate,drinkDateHi,drinkWhenN,maturityN,estimatedCostLo,estimatedCostHi,originalCurrencyN,provenanceN,whereTastedN,isAvailabeToTastersGroups,isPostedToBB,isAnnonymous,isPrivate,updateWhN,_clumpName,_fixedId,_x_hasAGalloniTasting,_x_HasCurrentPrice,_x_hasDSchildknechtTasting,_x_hasDThomasesTasting,_x_hasErpTasting,_x_hasJMillerTasting,_x_hasMSquiresTasting,_x_hasMultipleWATastings,_x_hasNMartinTasting,_x_hasProducerProfile,_x_HasProducerWebSite,_x_hasPRovaniTasting,_x_hasRParkerTasting,_x_hasWJtasting,_x_reviewerIdN,ratingQ,createDate,createWh,isInactive,articleMasterN,decantedN,isApproved,hasUserComplaint,updateDate,hasHad,userComplaintCount,hasRating,isErpTasting,ParkerZralyLevel,sourceIconN,isProTasting,canBeActiveTasting,_x_showForERP,_x_showForWJ,_fixedIdDeleted,dataIdN,dataIdNDeleted,dataSourceN)
	select tastingN,wineN,vinN,wineNameN,pubN,pubDate,issue,pages,articleId,_x_articleIdNKey,articleOrder,articleURL,notes,@toWhN,tasteDate,isMostRecentTasting,isNoTasting,isActiveForThisPub,_x_IsActiveWineN,isBorrowedDrinkDate,IsBarrelTasting,bottleSizeN,rating,ratingPlus,ratingHi,ratingShow,drinkDate,drinkDateHi,drinkWhenN,maturityN,estimatedCostLo,estimatedCostHi,originalCurrencyN,provenanceN,whereTastedN,isAvailabeToTastersGroups,isPostedToBB,isAnnonymous,isPrivate,updateWhN,_clumpName,_fixedId,_x_hasAGalloniTasting,_x_HasCurrentPrice,_x_hasDSchildknechtTasting,_x_hasDThomasesTasting,_x_hasErpTasting,_x_hasJMillerTasting,_x_hasMSquiresTasting,_x_hasMultipleWATastings,_x_hasNMartinTasting,_x_hasProducerProfile,_x_HasProducerWebSite,_x_hasPRovaniTasting,_x_hasRParkerTasting,_x_hasWJtasting,_x_reviewerIdN,ratingQ,createDate,createWh,isInactive,articleMasterN,decantedN,isApproved,hasUserComplaint,updateDate,hasHad,userComplaintCount,hasRating,isErpTasting,ParkerZralyLevel,sourceIconN,isProTasting,canBeActiveTasting,_x_showForERP,_x_showForWJ,_fixedIdDeleted,dataIdN,dataIdNDeleted,dataSourceN
		from SavedTables..tasting
		where saveName = @saveName and tasterN=@fromWhN
		order by rowVersion asc
insert into Supplier(handle,whN,name,notes,createDate,updateDate,standardSupplierN,retailerN)
	select supplierN,@toWhN,name,notes,createDate,updateDate,standardSupplierN,retailerN
		from SavedTables..Supplier
		where saveName = @saveName and whN=@fromWhN
		order by rowVersion asc
insert into Purchase(handle,whN,wineN,supplierN,bottleSizeN,purchaseDate,deliveryDate,pricePerBottle,bottleCount,notes,createDate,updateDate,bottleCountBought)
	select purchaseN,@toWhN,wineN,supplierN,bottleSizeN,purchaseDate,deliveryDate,pricePerBottle,bottleCount,notes,createDate,updateDate,bottleCountBought
		from SavedTables..Purchase
		where saveName = @saveName and whN=@fromWhN
		order by rowVersion asc
insert into Location(handle,whN,parentLocationN,prevItemIndex,name,currentBottleCount,maxBottleCount,isBottle,purchaseN,bottleCountHere,bottleCountAvailable,createDate,updateDate,hasManyWines,locationCapacity)
	select locationN,@toWhN,parentLocationN,prevItemIndex,name,currentBottleCount,maxBottleCount,isBottle,purchaseN,bottleCountHere,bottleCountAvailable,createDate,updateDate,hasManyWines,locationCapacity
		from SavedTables..Location
		where saveName = @saveName and whN=@fromWhN
		order by rowVersion asc
insert into BottleConsumed(handle,whN,numberOfBottles,locationN,purchaseN,consumeDate)
	select id,@toWhN,numberOfBottles,locationN,purchaseN,consumeDate
		from SavedTables..BottleConsumed
		where saveName = @saveName and whN=@fromWhN
		order by rowVersion asc
 
update a set a.supplierN=b.supplierN from purchase a join supplier b on a.supplierN=b.handle where a.whN=@toWhN and b.whN=@toWhN;
 
update a set a.purchaseN=b.purchaseN from BottleConsumed a join purchase b on a.purchaseN=b.handle where a.whN=@toWhN and b.whN=@toWhN;
update a set a.locationN=b.locationN from BottleConsumed a join location b on a.locationN=b.handle where a.whN=@toWhN and b.whN=@toWhN;
 
update a set a.purchaseN=b.purchaseN from Location a join purchase b on a.purchaseN=b.handle where a.whN=@toWhN and b.whN=@toWhN;
update a set a.parentLocationN=b.LocationN from Location a join location b on a.parentLocationN=b.handle where a.whN=@toWhN and b.whN=@toWhN;
update a set a.prevItemIndex=b.LocationN from Location a join location b on a.prevItemIndex=b.handle where a.whN=@toWhN and b.whN=@toWhN;
 
set noCount off
 
end
 
/*
 
select whN,saveName from savedTables..location
loadFromSave goo, 22,24
 
declare @toWhN int=24, @fromWhN int=22
update a set a.parentLocationN=b.LocationN from Location a join location b on a.parentLocationN=b.handle where a.whN=@toWhN and b.whN=@fromWhN
 
select handle handle2,* from location where whN in (22,23,24)
select handle handle2,* from savedTables..location where whN in (22,23,24)
 
*/
 
 
