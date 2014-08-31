create view vCounts as select
		  whN
		, wineN
		, bottleCount bottles
		, tastingCount tastings
		, wantToSellBottleCount sell
		, wantToBuyBottleCount buy
		, buyerCount buyer
		, sellerCount seller
		, purchaseCount purchase
		, toBeDeliveredBottleCount delivered
		, notYetCellaredBottleCount cellared
		, consumedCount consumed
	from whToWine