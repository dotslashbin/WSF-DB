--database update		[=]
CREATE proc [zupdateDougErpSearchFromWeb] as begin 
------------------------------------------------------------------------
--Copy Julian tables from erpSearch2 => erpSearch
------------------------------------------------------------------------
--erpsearchd2..cols retail
delete from retailers
set identity_insert retailers on
insert into retailers( Address,City,Country,Email,Errors,ErrorsOnReadin,Fax,Phone,RetailerCode,RetailerIdN,RetailerName,ShipToCountry,State,URL,Warnings,Zip)
select Address,City,Country,Email,Errors,ErrorsOnReadin,Fax,Phone,RetailerCode,RetailerIdN,RetailerName,ShipToCountry,State,URL,Warnings,Zip
from erpsearchd2..retailers
set identity_insert retailers off

--erpsearchd2..cols ' forsaledetail '
delete from forsaledetail
set identity_insert forsaledetail on
insert into forSaleDetail(
BottleSize,City,Country,Currency,DollarsPer750Bottle,Errors
,ErrorsOnReadin,IdN,isAuction,isOverridePriceException,isTempWineN,isTrue750Bottle,isWineNDeduced,Price,RetailerCode
,RetailerDescriptionOfWine,RetailerIdN,RetailerName,State,TaxNotes,URL,VinN2,Vintage,Warnings,Wid,WineN,WineN2)
select 
BottleSize,City,Country,Currency,DollarsPer750Bottle,Errors
,ErrorsOnReadin,IdN,isAuction,isOverridePriceException,isTempWineN,isTrue750Bottle,isWineNDeduced,Price,RetailerCode
,RetailerDescriptionOfWine,RetailerIdN,RetailerName,State,TaxNotes,URL,VinN2,Vintage,Warnings,Wid,WineN,WineN2
from erpsearchd2..forsaledetail
set identity_insert forsaledetail off

--erpsearchd..cols ' forsale '
delete from forSale
set identity_insert forSale on
insert into forSale(
AuctionCnt,AuctionPrice,AuctionPriceHi,Errors,idN,IsActiveForSaleWineN,isTempWineN,isWineNDeduced,Price,PriceAvg
,PriceCnt,PriceHi,Vintage,Warnings,Wid,WineN)
select 
AuctionCnt,AuctionPrice,AuctionPriceHi,Errors,idN,IsActiveForSaleWineN,isTempWineN,isWineNDeduced,Price,PriceAvg
,PriceCnt,PriceHi,Vintage,Warnings,Wid,WineN
from erpsearchD2..forSale
set identity_insert forSale off  

--erpsearchd2..cols ' waname '
delete from waName
set identity_insert waName on
insert into waName(ColorClass,Country,Dryness,erpColorClass,erpCountry,erpDryness,erpLabelName,erpLocation,erpProducer,erpProducerShow,erpRegion,erpVariety,erpWineType
	,Errors,ErrorsOnReadin,idN,isColorClassTranslated,isCountryTranslated,isDrynessTranslated,isErpColorClassOK,isErpCountryOK,isErpDrynessOK,isErpLabelNameOK
	,isErpLocationOK,isErpProducerOK,isErpRegionOK,isErpVarietyOK,isErpWineTypeOK,isLabelNameTranslated,isLocationTranslated,isProducerTranslated,isRegionTranslated
	,isTempVinn,isVarietyTranslated,isVinnColorClassAmbiguous,isVinnCountryAmbiguous,IsVinnDeduced,isVinnDrynessAmbiguous,isVinnLabelNameAmbiguous
	,isVinnLocationAmbiguous,isVinnProducerAmbiguous,isVinnRegionAmbiguous,isVinnVarietyAmbiguous,isVinnWineTypeAmbiguous,isWineTypeTranslated
	,LabelName,Location,Producer,ProducerShow,Region,Variety,VinN,Warnings,Wid,WineType)
select ColorClass,Country,Dryness,erpColorClass,erpCountry,erpDryness,erpLabelName,erpLocation,erpProducer,erpProducerShow,erpRegion,erpVariety,erpWineType
	,Errors,ErrorsOnReadin,idN,isColorClassTranslated,isCountryTranslated,isDrynessTranslated,isErpColorClassOK,isErpCountryOK,isErpDrynessOK,isErpLabelNameOK
	,isErpLocationOK,isErpProducerOK,isErpRegionOK,isErpVarietyOK,isErpWineTypeOK,isLabelNameTranslated,isLocationTranslated,isProducerTranslated,isRegionTranslated
	,isTempVinn,isVarietyTranslated,isVinnColorClassAmbiguous,isVinnCountryAmbiguous,IsVinnDeduced,isVinnDrynessAmbiguous,isVinnLabelNameAmbiguous
	,isVinnLocationAmbiguous,isVinnProducerAmbiguous,isVinnRegionAmbiguous,isVinnVarietyAmbiguous,isVinnWineTypeAmbiguous,isWineTypeTranslated
	,LabelName,Location,Producer,ProducerShow,Region,Variety,VinN,Warnings,Wid,WineType
from erpSearchD2..waName
set identity_insert waName off




end
