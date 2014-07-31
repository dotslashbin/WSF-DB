CREATE TABLE [dbo].[price] (
    [priceGN]               INT           NOT NULL,
    [includesNotForSaleNow] BIT           CONSTRAINT [DF_price_includesNotForSaleNow] DEFAULT ((0)) NOT NULL,
    [includesAuction]       BIT           CONSTRAINT [DF_price_includesAuction] DEFAULT ((0)) NOT NULL,
    [wineN]                 INT           NOT NULL,
    [wineNameN]             INT           NOT NULL,
    [isForSaleNow]          BIT           CONSTRAINT [DF_price_isForSaleNow] DEFAULT ((0)) NOT NULL,
    [mostRecentPriceLo]     MONEY         NULL,
    [mostRecentPriceHi]     MONEY         NULL,
    [mostRecentPriceCnt]    INT           NULL,
    [createDate]            SMALLDATETIME CONSTRAINT [DF_price_createDate] DEFAULT (getdate()) NULL,
    [rowversion]            ROWVERSION    NULL,
    [isFake]                BIT           CONSTRAINT [DF_price_isFake] DEFAULT ((0)) NOT NULL,
    [mostRecentPriceMedian] MONEY         NULL,
    [mostRecentDate]        SMALLDATETIME NULL,
    CONSTRAINT [PK_price] PRIMARY KEY CLUSTERED ([priceGN] ASC, [includesAuction] ASC, [includesNotForSaleNow] ASC, [wineN] ASC)
);

