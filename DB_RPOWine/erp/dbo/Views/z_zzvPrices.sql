create view [z_zzvPrices] as
select x.fromPriceGroupN priceGroupN, isAuction, wineN, price
	from erpSearchD..forSaleDetail y
		join whFromPriceGroup x
		on y.retailerN = x.toWhN
	where 
		y.errors is  null and y.dollarsPer750Bottle > 0

