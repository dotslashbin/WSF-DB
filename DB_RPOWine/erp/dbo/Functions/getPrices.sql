CREATE FUNCTION [dbo].[getPrices] 
(
	-- Add the parameters for the function here
	@priceGroupN int
)
RETURNS 
@T TABLE 
(
	priceGroupN int, isAuction bit, wineN int, priceLo money, priceHi money, cnt int
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set


insert into @T(priceGroupN, isAuction, wineN, priceLo, priceHi, cnt)
select x.parentN, isAuction, wineN, min(dollarsPer750Bottle) priceLo, max(dollarsPer750Bottle) priceHi, count(*) Cnt
	from erpSearchD..forSaleDetail y
		join whFromPriceGroup x
		on y.retailerN = x.memberN
	where 
		y.errors is  null and y.dollarsPer750Bottle > 0
		and x.parentN = 18220
	group by parentN,  isAuction, wineN


	
	RETURN 
END
