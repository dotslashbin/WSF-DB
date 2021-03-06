﻿CREATE TABLE [dbo].[ForSaleDetail] (
    [IdN]                       INT            IDENTITY (1, 1) NOT NULL,
    [Wid]                       NVARCHAR (255) NULL,
    [WineN]                     INT            NULL,
    [isTempWineN]               BIT            NULL,
    [isWineNDeduced]            BIT            CONSTRAINT [DF_ForSaleDetail_isWineNDeduced] DEFAULT ((0)) NULL,
    [WineN2]                    INT            NULL,
    [VinN2]                     INT            NULL,
    [Vintage]                   NVARCHAR (255) NULL,
    [BottleSize]                NVARCHAR (255) NULL,
    [Price]                     FLOAT (53)     NULL,
    [Currency]                  NVARCHAR (255) NULL,
    [isTrue750Bottle]           BIT            CONSTRAINT [DF_ForSaleDetail_isTrue750Bottle] DEFAULT ((0)) NOT NULL,
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
    CONSTRAINT [PK_ForSaleDetail] PRIMARY KEY CLUSTERED ([IdN] ASC)
);








GO
CREATE NONCLUSTERED INDEX [IX_ForSaleDetail_Price]
    ON [dbo].[ForSaleDetail]([Price] ASC)
    INCLUDE([IdN], [Errors]);


GO
CREATE NONCLUSTERED INDEX [IX_ForSaleDetail_DollarsPer750Bottle]
    ON [dbo].[ForSaleDetail]([DollarsPer750Bottle] ASC)
    INCLUDE([IdN], [Errors]);


GO
CREATE NONCLUSTERED INDEX [IX_ForSaleDetail_Currency]
    ON [dbo].[ForSaleDetail]([Currency] ASC)
    INCLUDE([IdN], [BottleSize], [Price]);


GO
CREATE NONCLUSTERED INDEX [IX_ForSaleDetail_BottleSize]
    ON [dbo].[ForSaleDetail]([BottleSize] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ForSaleDetail_Wid]
    ON [dbo].[ForSaleDetail]([Wid] ASC)
    INCLUDE([IdN]);

