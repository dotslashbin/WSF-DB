------------------------------------------------------------------------------------------------------------------------------
-- saveUserSQL
------------------------------------------------------------------------------------------------------------------------------
CREATE proc saveUserSQL (@tableName varchar(max), @db varchar(max) = 'SavedTables')
as begin
set noCount on
declare @s varchar(max), @q varchar(max)

--select @s= replace(dbo.concatFF(column_name), char(12),',') from information_schema.columns where table_name = @tableName and data_type not in ('rowVersion', 'timeStamp')
select @s= replace(dbo.concatFF(column_name), char(12),',') from information_schema.columns where table_name = @tableName

set @q='delete from savedTables..'+@tableName+' where saveName=@saveName and whN=@whN
insert into savedTables..'+@tableName+'(saveName,'+@s+') select @saveName,'+@s+' from '+@tableName+' where whN=@whN'

if @tableName='tasting' 
	begin
		set @q=replace(@q, ' whN=', ' tastingN=')
		set @q=replace(@q, ',whN,', ',tastingN,')
	end
print @q

end

/*
/*
truncate table savedTables..BottleConsumed
truncate table savedTables..tasting
truncate table savedTables..whToWine
truncate table savedTables..whToTrustedTaster
truncate table savedTables..whToTrustedPub
truncate table savedTables..Location
truncate table savedTables..Purchase
truncate table savedTables..Supplier


exec saveUserSQL BottleConsumed
exec saveUserSQL tasting
exec saveUserSQL whToWine
exec saveUserSQL whToTrustedTaster
exec saveUserSQL whToTrustedPub
exec saveUserSQL Location
exec saveUserSQL Purchase
exec saveUserSQL Supplier

=>
declare @saveName varchar(99)='foo',@whN int=22
delete from savedTables..BottleConsumed where saveName=@saveName and whN=@whN
insert into savedTables..BottleConsumed(saveName,id,whN,numberOfBottles,locationN,purchaseN,consumeDate,handle,rowVersion) select @saveName,id,whN,numberOfBottles,locationN,purchaseN,consumeDate,handle,rowVersion from BottleConsumed where whN=@whN
delete from savedTables..tasting where saveName=@saveName and tastingN=@whN
insert into savedTables..tasting(saveName,tastingN,wineN,vinN,wineNameN,pubN,pubDate,issue,pages,articleId,_x_articleIdNKey,articleOrder,articleURL,notes,tasterN,tasteDate,isMostRecentTasting,isNoTasting,isActiveForThisPub,_x_IsActiveWineN,isBorrowedDrinkDate,IsBarrelTasting,bottleSizeN,rating,ratingPlus,ratingHi,ratingShow,drinkDate,drinkDateHi,drinkWhenN,maturityN,estimatedCostLo,estimatedCostHi,originalCurrencyN,provenanceN,whereTastedN,isAvailabeToTastersGroups,isPostedToBB,isAnnonymous,isPrivate,updateWhN,_clumpName,_fixedId,_x_hasAGalloniTasting,_x_HasCurrentPrice,_x_hasDSchildknechtTasting,_x_hasDThomasesTasting,_x_hasErpTasting,_x_hasJMillerTasting,_x_hasMSquiresTasting,_x_hasMultipleWATastings,_x_hasNMartinTasting,_x_hasProducerProfile,_x_HasProducerWebSite,_x_hasPRovaniTasting,_x_hasRParkerTasting,_x_hasWJtasting,_x_reviewerIdN,ratingQ,createDate,createWh,rowversion,isInactive,articleMasterN,decantedN,isApproved,hasUserComplaint,updateDate,hasHad,userComplaintCount,hasRating,isErpTasting,ParkerZralyLevel,sourceIconN,isProTasting,canBeActiveTasting,_x_showForERP,_x_showForWJ,_fixedIdDeleted,dataIdN,dataIdNDeleted,dataSourceN,handle) select @saveName,tastingN,wineN,vinN,wineNameN,pubN,pubDate,issue,pages,articleId,_x_articleIdNKey,articleOrder,articleURL,notes,tasterN,tasteDate,isMostRecentTasting,isNoTasting,isActiveForThisPub,_x_IsActiveWineN,isBorrowedDrinkDate,IsBarrelTasting,bottleSizeN,rating,ratingPlus,ratingHi,ratingShow,drinkDate,drinkDateHi,drinkWhenN,maturityN,estimatedCostLo,estimatedCostHi,originalCurrencyN,provenanceN,whereTastedN,isAvailabeToTastersGroups,isPostedToBB,isAnnonymous,isPrivate,updateWhN,_clumpName,_fixedId,_x_hasAGalloniTasting,_x_HasCurrentPrice,_x_hasDSchildknechtTasting,_x_hasDThomasesTasting,_x_hasErpTasting,_x_hasJMillerTasting,_x_hasMSquiresTasting,_x_hasMultipleWATastings,_x_hasNMartinTasting,_x_hasProducerProfile,_x_HasProducerWebSite,_x_hasPRovaniTasting,_x_hasRParkerTasting,_x_hasWJtasting,_x_reviewerIdN,ratingQ,createDate,createWh,rowversion,isInactive,articleMasterN,decantedN,isApproved,hasUserComplaint,updateDate,hasHad,userComplaintCount,hasRating,isErpTasting,ParkerZralyLevel,sourceIconN,isProTasting,canBeActiveTasting,_x_showForERP,_x_showForWJ,_fixedIdDeleted,dataIdN,dataIdNDeleted,dataSourceN,handle from tasting where tastingN=@whN
delete from savedTables..whToWine where saveName=@saveName and whN=@whN
insert into savedTables..whToWine(saveName,whN,wineN,isOfInterestShow,wantToTryShow,hasBottlesShow,hasTastingsShow,wantToBuyShow,wantToSellShow,hasBuyersShow,hasSellersShow,hasUserCommentsShow,isOfInterest,wantToTry,bottleCount,hasMoreDetail,tastingCount,wantToSellBottleCount,wantToBuyBottleCount,buyerCount,sellerCount,userComments,isOfInterestR,wantToTryR,hasBottlesR,hasTastingsR,wantToBuyR,wantToSellR,hasBuyersR,hasSellersR,hasUserCommentsR,rowversion,locationN,hasHadStuff,isDerived,warnings,isOfInterestX,wantToTryX,hasBottlesX,hasTastingsX,wantToBuyX,wantToSellX,hasBuyersX,hasSellersX,hasUserCommentsX,isOfInterestIndirect,purchaseCount,createDate,bottleLocations,valuation,toBeDelivered,notYetCellared,toBeDeliveredR,notYetCellaredR,toBeDeliveredX,notYetCellaredX,toBeDeliveredBottleCount,notYetCellaredBottleCount,toBeDeliveredShow,notYetCellaredShow,consumedCount,mostRecentDeliveryDate,hasBottles,handle) select @saveName,whN,wineN,isOfInterestShow,wantToTryShow,hasBottlesShow,hasTastingsShow,wantToBuyShow,wantToSellShow,hasBuyersShow,hasSellersShow,hasUserCommentsShow,isOfInterest,wantToTry,bottleCount,hasMoreDetail,tastingCount,wantToSellBottleCount,wantToBuyBottleCount,buyerCount,sellerCount,userComments,isOfInterestR,wantToTryR,hasBottlesR,hasTastingsR,wantToBuyR,wantToSellR,hasBuyersR,hasSellersR,hasUserCommentsR,rowversion,locationN,hasHadStuff,isDerived,warnings,isOfInterestX,wantToTryX,hasBottlesX,hasTastingsX,wantToBuyX,wantToSellX,hasBuyersX,hasSellersX,hasUserCommentsX,isOfInterestIndirect,purchaseCount,createDate,bottleLocations,valuation,toBeDelivered,notYetCellared,toBeDeliveredR,notYetCellaredR,toBeDeliveredX,notYetCellaredX,toBeDeliveredBottleCount,notYetCellaredBottleCount,toBeDeliveredShow,notYetCellaredShow,consumedCount,mostRecentDeliveryDate,hasBottles,handle from whToWine where whN=@whN
delete from savedTables..whToTrustedTaster where saveName=@saveName and whN=@whN
insert into savedTables..whToTrustedTaster(saveName,whN,tasterN,isDerived,createDate,rowVersion,handle) select @saveName,whN,tasterN,isDerived,createDate,rowVersion,handle from whToTrustedTaster where whN=@whN
delete from savedTables..whToTrustedPub where saveName=@saveName and whN=@whN
insert into savedTables..whToTrustedPub(saveName,whN,pubN,isDerived,createDate,rowVersion,handle) select @saveName,whN,pubN,isDerived,createDate,rowVersion,handle from whToTrustedPub where whN=@whN
delete from savedTables..Location where saveName=@saveName and whN=@whN
insert into savedTables..Location(saveName,locationN,whN,parentLocationN,prevItemIndex,name,currentBottleCount,maxBottleCount,isBottle,purchaseN,bottleCountHere,bottleCountAvailable,createDate,updateDate,hasManyWines,locationCapacity,handle,rowVersion) select @saveName,locationN,whN,parentLocationN,prevItemIndex,name,currentBottleCount,maxBottleCount,isBottle,purchaseN,bottleCountHere,bottleCountAvailable,createDate,updateDate,hasManyWines,locationCapacity,handle,rowVersion from Location where whN=@whN
delete from savedTables..Purchase where saveName=@saveName and whN=@whN
insert into savedTables..Purchase(saveName,purchaseN,whN,wineN,supplierN,bottleSizeN,purchaseDate,deliveryDate,pricePerBottle,bottleCount,notes,createDate,updateDate,bottleCountBought,handle,rowVersion) select @saveName,purchaseN,whN,wineN,supplierN,bottleSizeN,purchaseDate,deliveryDate,pricePerBottle,bottleCount,notes,createDate,updateDate,bottleCountBought,handle,rowVersion from Purchase where whN=@whN
delete from savedTables..Supplier where saveName=@saveName and whN=@whN
insert into savedTables..Supplier(saveName,supplierN,whN,name,notes,createDate,updateDate,standardSupplierN,retailerN,handle,rowVersion) select @saveName,supplierN,whN,name,notes,createDate,updateDate,standardSupplierN,retailerN,handle,rowVersion from Supplier where whN=@whN
*/

use savedTables
ooi whtowine,nam
saveUserSQL whToWine
alter table savedTables..whToWine alter column rowVersion binary(8)
*/
