CREATE TABLE [dbo].[eWine] (
    [Idn]                       INT            NOT NULL,
    [EntryN]                    INT            NOT NULL,
    [IsActiveWineN]             BIT            NOT NULL,
    [WineN]                     INT            NOT NULL,
    [Vintage]                   NVARCHAR (255) NULL,
    [Variety]                   NVARCHAR (255) NULL,
    [LabelName]                 NVARCHAR (255) NULL,
    [Producer]                  NVARCHAR (255) NULL,
    [ProducerShow]              NVARCHAR (255) NULL,
    [Country]                   NVARCHAR (255) NULL,
    [Region]                    NVARCHAR (255) NULL,
    [Location]                  NVARCHAR (255) NULL,
    [Dryness]                   NVARCHAR (255) NULL,
    [ColorClass]                NVARCHAR (255) NULL,
    [WineType]                  NVARCHAR (255) NULL,
    [Source]                    NVARCHAR (255) NULL,
    [SourceDate]                DATETIME       NULL,
    [Publication]               NVARCHAR (50)  NULL,
    [Issue]                     NVARCHAR (50)  NULL,
    [Pages]                     NVARCHAR (50)  NULL,
    [Rating]                    SMALLINT       NULL,
    [RatingQ]                   NVARCHAR (MAX) NULL,
    [Rating_Hi]                 SMALLINT       NULL,
    [DrinkDate]                 DATETIME       NULL,
    [DrinkDate_Hi]              DATETIME       NULL,
    [EstimatedCost]             MONEY          NULL,
    [EstimatedCost_Hi]          MONEY          NULL,
    [BottlesPerCosting]         SMALLINT       NULL,
    [BottleSize]                NVARCHAR (50)  NULL,
    [Notes]                     NVARCHAR (MAX) NULL,
    [IsActiveTasting]           SMALLINT       NULL,
    [TastingCount]              SMALLINT       NULL,
    [DateUpdated]               DATETIME       NULL,
    [WhoUpdated]                NVARCHAR (50)  NULL,
    [FixedId]                   INT            NOT NULL,
    [encodedKeyWords]           NVARCHAR (255) NULL,
    [Vin]                       NVARCHAR (255) NULL,
    [VinN]                      INT            NULL,
    [ThisYearHasPrices]         BIT            NOT NULL,
    [SomeYearHasPrices]         BIT            NOT NULL,
    [Locale]                    NVARCHAR (255) NULL,
    [HasProducerWebSite]        BIT            NOT NULL,
    [Site]                      NVARCHAR (255) NULL,
    [IsBarrelTasting]           BIT            NOT NULL,
    [ArticleIdNKey]             INT            NULL,
    [ArticleId]                 INT            NULL,
    [ArticleOrder]              INT            NULL,
    [CombinedLocation]          NVARCHAR (255) NULL,
    [Maturity]                  SMALLINT       NULL,
    [ProducerURL]               NVARCHAR (255) NULL,
    [Places]                    NVARCHAR (255) NULL,
    [ShortLabelName]            NVARCHAR (255) NULL,
    [ShortTitle]                NVARCHAR (255) NULL,
    [ReviewerIdN]               INT            NULL,
    [hasWJtasting]              BIT            NULL,
    [hasErpTasting]             BIT            NULL,
    [hasAGalloniTasting]        BIT            NULL,
    [hasDSchildknechtTasting]   BIT            NULL,
    [hasDThomasesTasting]       BIT            NULL,
    [hasJMillerTasting]         BIT            NULL,
    [hasMSquiresTasting]        BIT            NULL,
    [hasNMartinTasting]         BIT            NULL,
    [hasPRovaniTasting]         BIT            NULL,
    [hasRParkerTasting]         BIT            NULL,
    [WineNameIdN]               INT            NULL,
    [RatingShow]                VARCHAR (20)   NULL,
    [MostRecentPrice]           MONEY          NULL,
    [MostRecentPriceHi]         MONEY          NULL,
    [MostRecentPriceCnt]        INT            NULL,
    [mostRecentAuctionPrice]    MONEY          NULL,
    [mostRecentAuctionPriceHi]  MONEY          NULL,
    [mostRecentAuctionPriceCnt] INT            NULL,
    [IsCurrentlyForSale]        BIT            NULL,
    [isCurrentlyOnAuction]      BIT            NULL,
    [hasProducerProfile]        BIT            NULL,
    [originalEstimatedCost]     MONEY          NULL,
    [originalEstimatedCost_hi]  MONEY          NULL,
    [HasCurrentPrice]           BIT            NULL,
    [IsERPName]                 BIT            NULL,
    [showForERP]                BIT            NULL,
    [showForWJ]                 BIT            NULL,
    [articleHandle]             INT            NULL,
    [clumpName]                 VARCHAR (255)  NULL,
    [isBorrowedDrinkDate]       BIT            NULL,
    [isActiveWineNRpwacm]       BIT            NULL,
    [hasMultipleWATastings]     BIT            NULL,
    [ProducerProfileFileName]   VARCHAR (255)  NULL,
    [isErpTasting]              BIT            NULL,
    [isWjTasting]               BIT            NULL,
    [temp]                      VARCHAR (MAX)  NULL,
    [tasteDate]                 DATETIME       NULL,
    [notesLen]                  INT            NULL,
    [isActiveWineN2]            BIT            NULL,
    [isActiveT]                 BIT            NULL,
    [isNoTasting]               BIT            NULL,
    [isMostRecentTasting]       BIT            NULL,
    [erpTastingCount]           INT            NULL,
    [isActiveWineN_old]         BIT            NULL,
    [wineNameN]                 INT            NULL,
    [joinX]                     NVARCHAR (350) NULL,
    [articleMasterN]            INT            NULL,
    [joinA]                     NVARCHAR (350) NULL,
    [canBeActiveTasting]        BIT            NULL,
    [iiProducerVintage]         INT            NULL
);


GO
CREATE CLUSTERED INDEX [ix_eWine_idN]
    ON [dbo].[eWine]([Idn] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_eWine_joinx]
    ON [dbo].[eWine]([joinX] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_eWine_wineN]
    ON [dbo].[eWine]([WineN] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_eWine_vinnVintage]
    ON [dbo].[eWine]([VinN] ASC, [Vintage] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_eWine_winenVintage]
    ON [dbo].[eWine]([WineN] ASC, [Vintage] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_ewine_iiProducerVintage]
    ON [dbo].[eWine]([iiProducerVintage] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_ewine_source]
    ON [dbo].[eWine]([Source] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_ewine_publication]
    ON [dbo].[eWine]([Publication] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_ewine_fixedId]
    ON [dbo].[eWine]([FixedId] ASC);

