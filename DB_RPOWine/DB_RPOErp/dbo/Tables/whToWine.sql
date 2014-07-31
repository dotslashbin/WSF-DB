CREATE TABLE [dbo].[whToWine] (
    [whN]                       INT             NOT NULL,
    [wineN]                     INT             NOT NULL,
    [isOfInterestShow]          BIT             CONSTRAINT [DF_whToWine_isOfInterest] DEFAULT (NULL) NULL,
    [wantToTryShow]             BIT             CONSTRAINT [DF_whToWine_wantToTry] DEFAULT (NULL) NULL,
    [hasBottlesShow]            BIT             CONSTRAINT [DF_whToWine_hasBottles] DEFAULT (NULL) NULL,
    [hasTastingsShow]           BIT             CONSTRAINT [DF_whToWine_hasTastings] DEFAULT (NULL) NULL,
    [wantToBuyShow]             BIT             CONSTRAINT [DF_whToWine_wantToBuy] DEFAULT (NULL) NULL,
    [wantToSellShow]            BIT             CONSTRAINT [DF_whToWine_wantToSell] DEFAULT (NULL) NULL,
    [hasBuyersShow]             BIT             CONSTRAINT [DF_whToWine_hasBuyers] DEFAULT (NULL) NULL,
    [hasSellersShow]            BIT             CONSTRAINT [DF_whToWine_hasSellers] DEFAULT (NULL) NULL,
    [hasUserCommentsShow]       BIT             CONSTRAINT [DF_whToWine_hasComments] DEFAULT (NULL) NULL,
    [isOfInterest]              BIT             CONSTRAINT [DF_whToWine_isOfInterest1_1] DEFAULT (NULL) NULL,
    [wantToTry]                 BIT             CONSTRAINT [DF_whToWine_wantToTry1_1] DEFAULT (NULL) NULL,
    [bottleCount]               SMALLINT        CONSTRAINT [DF_whToWine_bottleCount] DEFAULT (NULL) NULL,
    [hasMoreDetail]             BIT             CONSTRAINT [DF_whToWine_hasBottleDetail] DEFAULT (NULL) NULL,
    [tastingCount]              SMALLINT        CONSTRAINT [DF_whToWine_tastingCount] DEFAULT (NULL) NULL,
    [wantToSellBottleCount]     SMALLINT        CONSTRAINT [DF_whToWine_wantToSellCount] DEFAULT (NULL) NULL,
    [wantToBuyBottleCount]      SMALLINT        CONSTRAINT [DF_whToWine_wantToBuyCount] DEFAULT (NULL) NULL,
    [buyerCount]                SMALLINT        CONSTRAINT [DF_whToWine_buyerCount] DEFAULT (NULL) NULL,
    [sellerCount]               SMALLINT        CONSTRAINT [DF_whToWine_sellerCount] DEFAULT (NULL) NULL,
    [userComments]              NVARCHAR (100)  CONSTRAINT [DF_whToWine_userComments] DEFAULT (NULL) NULL,
    [isOfInterestR]             BIT             CONSTRAINT [DF_whToWine_isOfInterest1] DEFAULT (NULL) NULL,
    [wantToTryR]                BIT             CONSTRAINT [DF_whToWine_wantToTry1] DEFAULT (NULL) NULL,
    [hasBottlesR]               BIT             CONSTRAINT [DF_whToWine_hasBottles1] DEFAULT (NULL) NULL,
    [hasTastingsR]              BIT             CONSTRAINT [DF_whToWine_hasTastings1] DEFAULT (NULL) NULL,
    [wantToBuyR]                BIT             CONSTRAINT [DF_whToWine_wantToBuy1] DEFAULT (NULL) NULL,
    [wantToSellR]               BIT             CONSTRAINT [DF_whToWine_wantToSell1] DEFAULT (NULL) NULL,
    [hasBuyersR]                BIT             CONSTRAINT [DF_whToWine_hasBuyers1] DEFAULT (NULL) NULL,
    [hasSellersR]               BIT             CONSTRAINT [DF_whToWine_hasSellers1] DEFAULT (NULL) NULL,
    [hasUserCommentsR]          BIT             CONSTRAINT [DF_whToWine_hasComments1] DEFAULT (NULL) NULL,
    [rowversion]                ROWVERSION      NULL,
    [locationN]                 INT             CONSTRAINT [DF_whToWine_locationN] DEFAULT (NULL) NULL,
    [hasHadStuff]               BIT             CONSTRAINT [DF_whToWine_hasHadStuff] DEFAULT (NULL) NULL,
    [isDerived]                 BIT             CONSTRAINT [df_mapWhToWine_isDerived] DEFAULT (NULL) NULL,
    [warnings]                  NVARCHAR (1000) NULL,
    [isOfInterestX]             BIT             CONSTRAINT [DF_whToWine_isOfInterest1_2] DEFAULT (NULL) NULL,
    [wantToTryX]                BIT             CONSTRAINT [DF_whToWine_wantToTry1_2] DEFAULT (NULL) NULL,
    [hasBottlesX]               BIT             CONSTRAINT [DF_whToWine_hasBottles1_1] DEFAULT (NULL) NULL,
    [hasTastingsX]              BIT             CONSTRAINT [DF_whToWine_hasTastings1_1] DEFAULT (NULL) NULL,
    [wantToBuyX]                BIT             CONSTRAINT [DF_whToWine_wantToBuy1_1] DEFAULT (NULL) NULL,
    [wantToSellX]               BIT             CONSTRAINT [DF_whToWine_wantToSell1_1] DEFAULT (NULL) NULL,
    [hasBuyersX]                BIT             CONSTRAINT [DF_whToWine_hasBuyers1_1] DEFAULT (NULL) NULL,
    [hasSellersX]               BIT             CONSTRAINT [DF_whToWine_hasSellers1_1] DEFAULT (NULL) NULL,
    [hasUserCommentsX]          BIT             CONSTRAINT [DF_whToWine_hasUserComments1] DEFAULT (NULL) NULL,
    [isOfInterestIndirect]      BIT             NULL,
    [purchaseCount]             SMALLINT        NULL,
    [createDate]                SMALLDATETIME   CONSTRAINT [DF_whToWine_createDate] DEFAULT (getdate()) NULL,
    [bottleLocations]           VARCHAR (1000)  NULL,
    [valuation]                 INT             NULL,
    [toBeDelivered]             BIT             NULL,
    [notYetCellared]            BIT             NULL,
    [toBeDeliveredR]            BIT             NULL,
    [notYetCellaredR]           BIT             NULL,
    [toBeDeliveredX]            BIT             NULL,
    [notYetCellaredX]           BIT             NULL,
    [toBeDeliveredBottleCount]  SMALLINT        NULL,
    [notYetCellaredBottleCount] SMALLINT        NULL,
    [toBeDeliveredShow]         BIT             NULL,
    [notYetCellaredShow]        BIT             NULL,
    [consumedCount]             SMALLINT        NULL,
    [mostRecentDeliveryDate]    SMALLDATETIME   NULL,
    [hasBottles]                NCHAR (10)      NULL,
    [handle]                    INT             NULL,
    CONSTRAINT [PK_whoToWine] PRIMARY KEY CLUSTERED ([whN] ASC, [wineN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [k_whToWine_isOfInterest]
    ON [dbo].[whToWine]([isOfInterest] ASC);


GO
CREATE NONCLUSTERED INDEX [k_whToWine_hasTastingX]
    ON [dbo].[whToWine]([hasTastingsX] ASC);


GO
CREATE NONCLUSTERED INDEX [k_whToWine_isOfInterestX]
    ON [dbo].[whToWine]([isOfInterestX] ASC)
    INCLUDE([wantToTryX], [hasBottlesX], [hasTastingsX], [wantToBuyX], [wantToSellX], [hasBuyersX], [hasSellersX], [hasUserCommentsX], [toBeDeliveredX], [notYetCellaredX]);

