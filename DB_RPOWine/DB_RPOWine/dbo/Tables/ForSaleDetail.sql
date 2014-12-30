CREATE TABLE [dbo].[ForSaleDetail] (
    [IdN]                       INT            NOT NULL,
    [Wid]                       NVARCHAR (255) NULL,
    [WineN]                     INT            NULL,
    [isTempWineN]               BIT            NULL,
    [isWineNDeduced]            BIT            NULL,
    [WineN2]                    INT            NULL,
    [VinN2]                     INT            NULL,
    [Vintage]                   NVARCHAR (255) NULL,
    [BottleSize]                NVARCHAR (255) NULL,
    [Price]                     FLOAT (53)     NULL,
    [Currency]                  NVARCHAR (255) NULL,
    [isTrue750Bottle]           BIT            NOT NULL,
    [DollarsPer750Bottle]       MONEY          NULL,
    [TaxNotes]                  NVARCHAR (255) NULL,
    [URL]                       NVARCHAR (255) NULL,
    [RetailerDescriptionOfWine] NVARCHAR (255) NULL,
    [RetailerIdN]               NCHAR (10)     NULL,
    [RetailerCode]              NVARCHAR (255) NULL,
    [RetailerName]              NVARCHAR (255) NULL,
    [Country]                   NVARCHAR (255) NULL,
    [State]                     NVARCHAR (255) NULL,
    [City]                      NVARCHAR (255) NULL,
    [Errors]                    NVARCHAR (MAX) NULL,
    [Warnings]                  NVARCHAR (MAX) NULL,
    [isAuction]                 BIT            NULL,
    [isOverridePriceException]  BIT            NULL,
    [ErrorsOnReadin]            NVARCHAR (MAX) NULL,
    [retailerN]                 INT            NULL,
    [Wine_VinN_ID]              INT            NULL,
    [WineNOriginal]             INT            NULL,
    CONSTRAINT [PK_ForSaleDetail] PRIMARY KEY CLUSTERED ([IdN] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_ForSaleDetail_Currency]
    ON [dbo].[ForSaleDetail]([Currency] ASC)
    INCLUDE([IdN], [BottleSize], [Price]);


GO
CREATE NONCLUSTERED INDEX [IX_ForSaleDetail_BottleSize]
    ON [dbo].[ForSaleDetail]([BottleSize] ASC);

