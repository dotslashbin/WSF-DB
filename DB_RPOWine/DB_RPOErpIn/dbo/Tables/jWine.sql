﻿CREATE TABLE [dbo].[jWine] (
    [IsActiveWineN]             BIT            NULL,
    [WineN]                     INT            NOT NULL,
    [Vintage]                   VARCHAR (255)  NULL,
    [Variety]                   VARCHAR (255)  NULL,
    [LabelName]                 VARCHAR (255)  NULL,
    [Producer]                  VARCHAR (255)  NULL,
    [ProducerShow]              VARCHAR (255)  NULL,
    [RatingShow]                VARCHAR (20)   NULL,
    [Country]                   VARCHAR (255)  NULL,
    [Region]                    VARCHAR (255)  NULL,
    [Location]                  VARCHAR (255)  NULL,
    [Dryness]                   VARCHAR (255)  NULL,
    [ColorClass]                VARCHAR (255)  NULL,
    [WineType]                  VARCHAR (255)  NULL,
    [Source]                    VARCHAR (255)  NULL,
    [SourceDate]                DATETIME       NULL,
    [Publication]               VARCHAR (255)  NULL,
    [Issue]                     VARCHAR (255)  NULL,
    [Pages]                     VARCHAR (50)   NULL,
    [Rating]                    SMALLINT       NULL,
    [Rating_Hi]                 SMALLINT       NULL,
    [ratingQ]                   VARCHAR (MAX)  NULL,
    [DrinkDate]                 DATETIME       NULL,
    [DrinkDate_Hi]              DATETIME       NULL,
    [EstimatedCost]             MONEY          NULL,
    [EstimatedCost_Hi]          MONEY          NULL,
    [BottlesPerCosting]         SMALLINT       NULL,
    [BottleSize]                VARCHAR (255)  NULL,
    [Notes]                     VARCHAR (MAX)  NULL,
    [IsActiveTasting]           SMALLINT       NULL,
    [TastingCount]              SMALLINT       NULL,
    [DateUpdated]               DATETIME       NULL,
    [WhoUpdated]                VARCHAR (50)   NULL,
    [encodedKeyWords]           VARCHAR (MAX)  NULL,
    [Vin]                       VARCHAR (255)  NULL,
    [VinN]                      INT            NULL,
    [ThisYearHasPrices]         BIT            NOT NULL,
    [SomeYearHasPrices]         BIT            NOT NULL,
    [Locale]                    VARCHAR (255)  NULL,
    [HasProducerWebSite]        BIT            NOT NULL,
    [Site]                      VARCHAR (255)  NULL,
    [IsBarrelTasting]           BIT            NOT NULL,
    [ArticleIdNKey]             INT            NULL,
    [ArticleId]                 INT            NULL,
    [ArticleOrder]              INT            NULL,
    [CombinedLocation]          VARCHAR (MAX)  NULL,
    [Maturity]                  SMALLINT       NULL,
    [ProducerURL]               VARCHAR (MAX)  NULL,
    [Places]                    VARCHAR (MAX)  NULL,
    [ShortLabelName]            VARCHAR (255)  NULL,
    [HasCurrentPrice]           BIT            NULL,
    [DisabledFlag]              VARCHAR (50)   NULL,
    [NameCreatorWhoN]           INT            NULL,
    [UserCount]                 VARCHAR (255)  NULL,
    [HasERPTasting]             BIT            NOT NULL,
    [RecordCreatorWhoN]         INT            NULL,
    [RecordCreatedDate]         DATETIME       NULL,
    [IsERPName]                 BIT            NOT NULL,
    [MostRecentPrice]           MONEY          NULL,
    [MostRecentPriceHi]         MONEY          NULL,
    [MostRecentPriceCnt]        INT            NULL,
    [mostRecentAuctionPrice]    MONEY          NULL,
    [mostRecentAuctionPriceHi]  MONEY          NULL,
    [mostRecentAuctionPriceCnt] INT            NULL,
    [HasUserNotes]              BIT            NOT NULL,
    [Wid]                       NCHAR (15)     NULL,
    [IsCurrentlyForSale]        BIT            NOT NULL,
    [isCurrentlyOnAuction]      BIT            NULL,
    [ReviewerIdN]               INT            NULL,
    [IdN]                       INT            NOT NULL,
    [HasWJTasting]              BIT            NOT NULL,
    [showForERP]                BIT            NOT NULL,
    [showForWJ]                 BIT            NOT NULL,
    [hasAGalloniTasting]        BIT            NOT NULL,
    [hasDSchildknechtTasting]   BIT            NOT NULL,
    [hasDThomasesTasting]       BIT            NOT NULL,
    [hasJMillerTasting]         BIT            NOT NULL,
    [hasMSquiresTasting]        BIT            NOT NULL,
    [hasNMartinTasting]         BIT            NOT NULL,
    [hasPRovaniTasting]         BIT            NOT NULL,
    [hasRParkerTasting]         BIT            NOT NULL,
    [FixedId]                   INT            NULL,
    [shortTitle]                VARCHAR (255)  NULL,
    [isErpLocationOK]           BIT            NOT NULL,
    [isErpProducerOK]           BIT            NOT NULL,
    [isProducerTranslated]      BIT            NOT NULL,
    [isErpRegionOK]             BIT            NOT NULL,
    [isErpVarietyOK]            BIT            NOT NULL,
    [isVinnDeduced]             BIT            NOT NULL,
    [isWineNDeduced]            BIT            NOT NULL,
    [wineNameIdN]               INT            NULL,
    [hasProducerProfile]        BIT            NULL,
    [clumpName]                 VARCHAR (255)  NULL,
    [isBorrowedDrinkDate]       BIT            NULL,
    [hasMultipleWATastings]     BIT            NULL,
    [ProducerProfileFileName]   VARCHAR (255)  NULL,
    [isErpTasting]              BIT            NULL,
    [isWjTasting]               BIT            NULL,
    [mostRecentPriceAvg]        MONEY          NULL,
    [qprAllShow]                NCHAR (2)      NULL,
    [qprAllShowI]               INT            NULL,
    [qprRaw]                    INT            NULL,
    [qprGroup]                  INT            NULL,
    [qprGroupRankShow]          NCHAR (2)      NULL,
    [qprGroupRankShowI]         INT            NULL,
    [qprGroupShow]              NCHAR (2)      NULL,
    [qprGroupShowI]             INT            NULL,
    [erpTastingCount]           INT            NULL,
    [isActiveWineN_old]         BIT            NULL,
    [joinx]                     NVARCHAR (350) NULL,
    [wineNameN]                 INT            NULL
);


GO
CREATE CLUSTERED INDEX [ix_jwine_winen]
    ON [dbo].[jWine]([WineN] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_jwine_joinx]
    ON [dbo].[jWine]([joinx] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_jwine_vinnVintage]
    ON [dbo].[jWine]([VinN] ASC, [Vintage] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_jWine_widVintage]
    ON [dbo].[jWine]([Wid] ASC, [Vintage] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_jWine_winenVintage]
    ON [dbo].[jWine]([WineN] ASC, [Vintage] ASC);

