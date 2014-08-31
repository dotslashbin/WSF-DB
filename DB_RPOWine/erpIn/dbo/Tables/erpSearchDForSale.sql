CREATE TABLE [dbo].[erpSearchDForSale] (
    [idN]                  INT            IDENTITY (1, 1) NOT NULL,
    [Wid]                  NCHAR (10)     NULL,
    [WineN]                INT            NULL,
    [isTempWineN]          BIT            NULL,
    [IsActiveForSaleWineN] BIT            NULL,
    [isWineNDeduced]       BIT            NOT NULL,
    [Vintage]              NCHAR (10)     NULL,
    [Price]                MONEY          NULL,
    [PriceHi]              MONEY          NULL,
    [PriceCnt]             INT            NULL,
    [AuctionPrice]         MONEY          NULL,
    [AuctionPriceHi]       MONEY          NULL,
    [AuctionCnt]           INT            NULL,
    [Warnings]             NVARCHAR (MAX) NULL,
    [Errors]               NVARCHAR (MAX) NULL,
    [PriceAvg]             MONEY          NULL
);

