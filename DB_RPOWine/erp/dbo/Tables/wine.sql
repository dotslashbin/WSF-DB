CREATE TABLE [dbo].[wine] (
    [wineN]                       INT           IDENTITY (1, 1) NOT NULL,
    [activeVinn]                  INT           NULL,
    [wineNameN]                   INT           NULL,
    [vintage]                     VARCHAR (4)   NULL,
    [estimatedCostHi]             MONEY         NULL,
    [estimatedCostLo]             MONEY         NULL,
    [rowversion]                  ROWVERSION    NULL,
    [isInactive]                  BIT           CONSTRAINT [df_wine_isInactive] DEFAULT ((0)) NULL,
    [createDate]                  SMALLDATETIME CONSTRAINT [df_wine_createDate] DEFAULT (getdate()) NULL,
    [_x_mostRecentPriceLo]        MONEY         NULL,
    [_x_mostRecentPriceHi]        MONEY         NULL,
    [mostRecentPriceCnt]          INT           NULL,
    [_x_tastingCount]             INT           NULL,
    [mostRecentAuctionPriceLoStd] MONEY         NULL,
    [mostRecentAuctionPriceHiStd] MONEY         NULL,
    [mostRecentAuctionPriceCnt]   INT           NULL,
    [_x_IsNowForSale]             BIT           NULL,
    [_x_isNowOnlyOnAuction]       BIT           NULL,
    [_x_hasErpTasting]            BIT           NULL,
    [encodedKeywords]             VARCHAR (MAX) NULL,
    [hasErpTasting]               BIT           NULL,
    [hasProTasting]               BIT           NULL,
    [mostRecentPriceLoStd]        MONEY         NULL,
    [mostRecentPriceHiStd]        MONEY         NULL,
    [isCurrentlyForSale]          BIT           NULL,
    [replacedByWineN]             INT           NULL,
    CONSTRAINT [PK_wine] PRIMARY KEY CLUSTERED ([wineN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [df_wine_wineName]
    ON [dbo].[wine]([wineNameN] ASC, [vintage] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_wineN]
    ON [dbo].[wine]([wineN] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_wine_winenVintageWinenamenVinn]
    ON [dbo].[wine]([wineN] ASC, [vintage] ASC, [wineNameN] ASC, [activeVinn] ASC);

