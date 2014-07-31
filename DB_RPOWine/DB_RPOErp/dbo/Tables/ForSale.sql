CREATE TABLE [dbo].[ForSale] (
    [idN]                  INT            IDENTITY (1, 1) NOT NULL,
    [Wid]                  NCHAR (10)     CONSTRAINT [DF_ForSale_Wid] DEFAULT (NULL) NULL,
    [WineN]                INT            CONSTRAINT [DF_ForSale_WineN] DEFAULT (NULL) NULL,
    [isTempWineN]          BIT            NULL,
    [IsActiveForSaleWineN] BIT            NULL,
    [isWineNDeduced]       BIT            CONSTRAINT [DF_ForSale_isWineNDeduced] DEFAULT ((0)) NOT NULL,
    [Vintage]              NCHAR (10)     CONSTRAINT [DF_ForSale_Vintage] DEFAULT (NULL) NULL,
    [Price]                MONEY          NULL,
    [PriceHi]              MONEY          NULL,
    [PriceCnt]             INT            NULL,
    [AuctionPrice]         MONEY          NULL,
    [AuctionPriceHi]       MONEY          NULL,
    [AuctionCnt]           INT            NULL,
    [Warnings]             NVARCHAR (MAX) CONSTRAINT [DF_ForSale_Warnings] DEFAULT (NULL) NULL,
    [Errors]               NVARCHAR (MAX) CONSTRAINT [DF_ForSale_Errors] DEFAULT (NULL) NULL,
    [PriceAvg]             MONEY          NULL,
    [rowversion]           ROWVERSION     NOT NULL,
    [createDate]           SMALLDATETIME  CONSTRAINT [df_ForSale_createDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_ForSale] PRIMARY KEY CLUSTERED ([idN] ASC)
);

