CREATE view vCount as select
		  whN
		, a.wineN
		, (b.vintage + ' ' + c.producerShow + isNull(' ' + c.labelName, '')) fullName
		, bottleCount bottles
		, tastingCount tastings
		, wantToSellBottleCount sell
		, wantToBuyBottleCount buy
		, buyerCount buyer
		, sellerCount seller
		, purchaseCount purchase
		, toBeDeliveredBottleCount onOrder
		, notYetCellaredBottleCount notCellared
		, consumedCount consumed
		, mostRecentDeliveryDate delivered
	from whToWine a
		join wine b
			on a.wineN = b.wineN
		join wineName c
			on b.wineNameN = c.wineNameN
