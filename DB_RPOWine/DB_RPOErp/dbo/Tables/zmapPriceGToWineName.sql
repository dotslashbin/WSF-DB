CREATE TABLE [dbo].[zmapPriceGToWineName] (
    [includesNotForSaleNow] BIT CONSTRAINT [DF_mapPriceGToWineName_includesNotForSaleNow] DEFAULT ((0)) NOT NULL,
    [includesAuction]       BIT CONSTRAINT [DF_mapPriceGToWineName_includesAuction] DEFAULT ((0)) NOT NULL,
    [priceGN]               INT NOT NULL,
    [wineNameN]             INT NOT NULL,
    CONSTRAINT [PK_mapPriceGToWineName] PRIMARY KEY CLUSTERED ([includesNotForSaleNow] ASC, [includesAuction] ASC, [priceGN] ASC, [wineNameN] ASC)
);

