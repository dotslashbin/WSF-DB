﻿CREATE TABLE [dbo].[Wine] (
    [IsActiveWineN]             BIT             NULL,
    [WineN]                     INT             NOT NULL,
    [Vintage]                   VARCHAR (255)   NULL,
    [Variety]                   VARCHAR (255)   NULL,
    [LabelName]                 VARCHAR (255)   NULL,
    [Producer]                  VARCHAR (255)   NULL,
    [ProducerShow]              VARCHAR (255)   NULL,
    [RatingShow]                VARCHAR (20)    NULL,
    [Country]                   VARCHAR (255)   NULL,
    [Region]                    VARCHAR (255)   NULL,
    [Location]                  VARCHAR (255)   NULL,
    [Dryness]                   VARCHAR (255)   NULL,
    [ColorClass]                VARCHAR (255)   NULL,
    [WineType]                  VARCHAR (255)   NULL,
    [Source]                    VARCHAR (255)   NULL,
    [SourceDate]                DATETIME        NULL,
    [Publication]               VARCHAR (255)   NULL,
    [Issue]                     VARCHAR (255)   NULL,
    [Pages]                     VARCHAR (50)    NULL,
    [Rating]                    SMALLINT        NULL,
    [Rating_Hi]                 SMALLINT        NULL,
    [ratingQ]                   VARCHAR (MAX)   NULL,
    [DrinkDate]                 DATETIME        NULL,
    [DrinkDate_Hi]              DATETIME        NULL,
    [EstimatedCost]             MONEY           NULL,
    [EstimatedCost_Hi]          MONEY           NULL,
    [BottlesPerCosting]         SMALLINT        NULL,
    [BottleSize]                VARCHAR (255)   NULL,
    [Notes]                     VARCHAR (MAX)   NULL,
    [IsActiveTasting]           SMALLINT        NULL,
    [TastingCount]              SMALLINT        NULL,
    [DateUpdated]               DATETIME        NULL,
    [WhoUpdated]                VARCHAR (50)    NULL,
    [encodedKeyWords]           VARCHAR (MAX)   NULL,
    [Vin]                       VARCHAR (255)   NULL,
    [VinN]                      INT             NULL,
    [ThisYearHasPrices]         BIT             CONSTRAINT [DF_Wine_ThisYearHasPrices] DEFAULT ((0)) NOT NULL,
    [SomeYearHasPrices]         BIT             CONSTRAINT [DF_Wine_SomeYearHasPrices] DEFAULT ((0)) NOT NULL,
    [Locale]                    VARCHAR (255)   NULL,
    [HasProducerWebSite]        BIT             CONSTRAINT [DF_Wine_HasProducerWebSite] DEFAULT ((0)) NOT NULL,
    [Site]                      VARCHAR (255)   NULL,
    [IsBarrelTasting]           BIT             CONSTRAINT [DF_Wine_IsBarrelTasting] DEFAULT ((0)) NOT NULL,
    [ArticleIdNKey]             INT             NULL,
    [ArticleId]                 INT             NULL,
    [ArticleOrder]              INT             NULL,
    [CombinedLocation]          VARCHAR (MAX)   NULL,
    [Maturity]                  SMALLINT        NULL,
    [ProducerURL]               VARCHAR (MAX)   NULL,
    [Places]                    VARCHAR (MAX)   NULL,
    [ShortLabelName]            VARCHAR (255)   NULL,
    [HasCurrentPrice]           BIT             NULL,
    [DisabledFlag]              VARCHAR (50)    NULL,
    [NameCreatorWhoN]           INT             NULL,
    [UserCount]                 VARCHAR (255)   NULL,
    [HasERPTasting]             BIT             CONSTRAINT [DF_Wine_HasERPTasting] DEFAULT ((0)) NOT NULL,
    [RecordCreatorWhoN]         INT             NULL,
    [RecordCreatedDate]         DATETIME        NULL,
    [IsERPName]                 BIT             CONSTRAINT [DF_Wine_IsERPName] DEFAULT ((0)) NOT NULL,
    [MostRecentPrice]           MONEY           NULL,
    [MostRecentPriceHi]         MONEY           NULL,
    [MostRecentPriceCnt]        INT             NULL,
    [mostRecentAuctionPrice]    MONEY           NULL,
    [mostRecentAuctionPriceHi]  MONEY           NULL,
    [mostRecentAuctionPriceCnt] INT             NULL,
    [HasUserNotes]              BIT             CONSTRAINT [DF_Wine_HasUserNotes] DEFAULT ((0)) NOT NULL,
    [Wid]                       NCHAR (15)      NULL,
    [IsCurrentlyForSale]        BIT             CONSTRAINT [DF_Wine_IsCurrentlyForSale] DEFAULT ((0)) NOT NULL,
    [isCurrentlyOnAuction]      BIT             NULL,
    [ReviewerIdN]               INT             NULL,
    [IdN]                       INT             IDENTITY (1, 1) NOT NULL,
    [HasWJTasting]              BIT             CONSTRAINT [DF_Wine_HasWJTasting] DEFAULT ((0)) NOT NULL,
    [showForERP]                BIT             CONSTRAINT [DF_Wine_showForERP] DEFAULT ((0)) NOT NULL,
    [showForWJ]                 BIT             CONSTRAINT [DF_Wine_showForWJ] DEFAULT ((0)) NOT NULL,
    [hasAGalloniTasting]        BIT             CONSTRAINT [DF_Wine_hasAGalloniTasting] DEFAULT ((0)) NOT NULL,
    [hasDSchildknechtTasting]   BIT             CONSTRAINT [DF_Wine_hasDSchildknechtTasting] DEFAULT ((0)) NOT NULL,
    [hasDThomasesTasting]       BIT             CONSTRAINT [DF_Wine_hasDThomasesTasting] DEFAULT ((0)) NOT NULL,
    [hasJMillerTasting]         BIT             CONSTRAINT [DF_Wine_hasJMillerTasting] DEFAULT ((0)) NOT NULL,
    [hasMSquiresTasting]        BIT             CONSTRAINT [DF_Wine_hasMSquiresTasting] DEFAULT ((0)) NOT NULL,
    [hasNMartinTasting]         BIT             CONSTRAINT [DF_Wine_hasNMartinTasting] DEFAULT ((0)) NOT NULL,
    [hasPRovaniTasting]         BIT             CONSTRAINT [DF_Wine_hasPRovaniTasting] DEFAULT ((0)) NOT NULL,
    [hasRParkerTasting]         BIT             CONSTRAINT [DF_Wine_hasRParkerTasting] DEFAULT ((0)) NOT NULL,
    [FixedId]                   INT             NULL,
    [shortTitle]                VARCHAR (255)   NULL,
    [isErpLocationOK]           BIT             CONSTRAINT [DF_Wine_isLocationDeduced] DEFAULT ((0)) NOT NULL,
    [isErpProducerOK]           BIT             CONSTRAINT [DF_Wine_isProducerDeduced] DEFAULT ((0)) NOT NULL,
    [isProducerTranslated]      BIT             CONSTRAINT [DF_Wine_isProducerTranslated] DEFAULT ((0)) NOT NULL,
    [isErpRegionOK]             BIT             CONSTRAINT [DF_Wine_isRegionDeduced] DEFAULT ((0)) NOT NULL,
    [isErpVarietyOK]            BIT             CONSTRAINT [DF_Wine_isVarietyDeduced] DEFAULT ((0)) NOT NULL,
    [isVinnDeduced]             BIT             CONSTRAINT [DF_Wine_isVinnDeduced] DEFAULT ((0)) NOT NULL,
    [isWineNDeduced]            BIT             CONSTRAINT [DF_Wine_isWineNDeduced] DEFAULT ((0)) NOT NULL,
    [wineNameIdN]               INT             NULL,
    [hasProducerProfile]        BIT             NULL,
    [clumpName]                 VARCHAR (255)   NULL,
    [isBorrowedDrinkDate]       BIT             NULL,
    [hasMultipleWATastings]     BIT             NULL,
    [ProducerProfileFileName]   VARCHAR (255)   NULL,
    [isErpTasting]              BIT             NULL,
    [isWjTasting]               BIT             NULL,
    [mostRecentPriceAvg]        MONEY           NULL,
    [qprAllShow]                NCHAR (2)       NULL,
    [qprAllShowI]               INT             NULL,
    [qprRaw]                    INT             NULL,
    [qprGroup]                  INT             NULL,
    [qprGroupRankShow]          NCHAR (2)       NULL,
    [qprGroupRankShowI]         INT             NULL,
    [qprGroupShow]              NCHAR (2)       NULL,
    [qprGroupShowI]             INT             NULL,
    [erpTastingCount]           INT             NULL,
    [isActiveWineN_old]         BIT             NULL,
    [joinx]                     NVARCHAR (1000) NULL,
    [wineNameN]                 INT             NULL,
    [oldWineN]                  INT             NULL,
    CONSTRAINT [PK_Wine] PRIMARY KEY CLUSTERED ([IdN] ASC)
);








GO
CREATE NONCLUSTERED INDEX [IX_Producer]
    ON [dbo].[Wine]([Producer] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Wine_FixedId]
    ON [dbo].[Wine]([FixedId] ASC);

