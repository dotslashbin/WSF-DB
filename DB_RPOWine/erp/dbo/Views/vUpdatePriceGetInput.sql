--database update [=]
CREATE view [dbo].[vUpdatePriceGetInput] as
select x.priceGN, isAuction, y.wineN, v.wineNameN, price
	from erpSearchD..forSaleDetail y
	join priceGToSeller x
		on y.retailerN = x.sellerN
	join erpSearchD..wine v		--new restriction to make sure we don't drag in bad wineN
		on y.wineN = v.wineN
	where 
		y.errors is  null and y.wineN is not null and y.dollarsPer750Bottle > 0;
