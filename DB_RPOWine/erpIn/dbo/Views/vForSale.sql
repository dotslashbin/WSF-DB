CREATE view vForSale as select ID, [WineAlert ID] wid, WineN, WineNN, Vintage, [Bottle Size] bottleSize, Retailer RetailerCode, retailerN, Price, Currency,dollarsPerLiter, [Tax/Notes] taxNotes
		, URL, [Actual Retailer Description] ActualRetailerDescription, [Overide Price Exception] OveridePriceException, Auction, errors, warnings, phase
		from waForSale
