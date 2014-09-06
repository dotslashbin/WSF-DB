﻿CREATE TABLE [dbo].[erpSearchDForSaleDetail] (
    [IdN]                       INT            IDENTITY (1, 1) NOT NULL,
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
    [retailerN]                 INT            NULL
);



