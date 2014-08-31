CREATE TABLE [dbo].[price2] (
    [priceGN]               INT           NOT NULL,
    [includesNotForSaleNow] BIT           NOT NULL,
    [includesAuction]       BIT           NOT NULL,
    [wineN]                 INT           NOT NULL,
    [wineNameN]             INT           NOT NULL,
    [isForSaleNow]          BIT           NOT NULL,
    [mostRecentPriceLo]     MONEY         NULL,
    [mostRecentPriceHi]     MONEY         NULL,
    [mostRecentPriceCnt]    INT           NULL,
    [createDate]            SMALLDATETIME NULL,
    [rowversion]            ROWVERSION    NULL,
    [isFake]                BIT           NOT NULL,
    [mostRecentPriceMedian] MONEY         NULL,
    [mostRecentDate]        SMALLDATETIME NULL
);

