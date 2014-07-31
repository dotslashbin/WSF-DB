create proc fixValues 
as begin
set nocount on

select * into price2 from price

insert into price(includesNotForSaleNow, includesAuction,priceGN,wineN,wineNameN,isForSaleNow,mostRecentPriceLo,mostRecentPriceHi,mostRecentPriceCnt,createDate,isFake,mostRecentPriceMedian,mostRecentDate)
		select 0, 1,priceGN,wineN,wineNameN,isForSaleNow,mostRecentPriceLo,mostRecentPriceHi,mostRecentPriceCnt,createDate,isFake,mostRecentPriceMedian,mostRecentDate
		from price
		where  
			includesNotForSaleNow = 0
			and includesAuction = 0;

insert into price(includesNotForSaleNow, includesAuction,priceGN,wineN,wineNameN,isForSaleNow,mostRecentPriceLo,mostRecentPriceHi,mostRecentPriceCnt,createDate,isFake,mostRecentPriceMedian,mostRecentDate)
		select 1, 0,priceGN,wineN,wineNameN,isForSaleNow,mostRecentPriceLo,mostRecentPriceHi,mostRecentPriceCnt,createDate,isFake,mostRecentPriceMedian,mostRecentDate
		from price
		where  
			includesNotForSaleNow = 0
			and includesAuction = 0;

insert into price(includesNotForSaleNow, includesAuction,priceGN,wineN,wineNameN,isForSaleNow,mostRecentPriceLo,mostRecentPriceHi,mostRecentPriceCnt,createDate,isFake,mostRecentPriceMedian,mostRecentDate)
		select 1, 1,priceGN,wineN,wineNameN,isForSaleNow,mostRecentPriceLo,mostRecentPriceHi,mostRecentPriceCnt,createDate,isFake,mostRecentPriceMedian,mostRecentDate
		from price
		where  
			includesNotForSaleNow = 0
			and includesAuction = 0;


end

/*
use erp
select * into price2 from price
od price, 'includesNotForSaleNow, includesAuction'

select distinct whN from whToWine
	22
	18255
	18256
	18262

summarizeBottleValuation 22,null, nulll
summarizeBottleValuation 18255,null, null
summarizeBottleValuation 18256,null, null
summarizeBottleValuation 18262,null, null
*/