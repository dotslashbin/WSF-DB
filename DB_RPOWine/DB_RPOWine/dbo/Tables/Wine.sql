CREATE TABLE [dbo].[Wine] (
    [ID]                      INT            IDENTITY (1, 1) NOT NULL,
    [TasteNote_ID]            INT            NOT NULL,
    [Wine_N_ID]               INT            NOT NULL,
    [Wine_VinN_ID]            INT            NOT NULL,
    [IdN]                     INT            NOT NULL,
    [ArticleID]               INT            NULL,
    [ArticleIdNKey]           INT            NULL,
    [ColorClass]              NVARCHAR (30)  NOT NULL,
    [Country]                 NVARCHAR (25)  NOT NULL,
    [ClumpName]               VARCHAR (50)   NULL,
    [Dryness]                 NVARCHAR (30)  NOT NULL,
    [DrinkDate]               DATE           NULL,
    [DrinkDate_hi]            DATE           NULL,
    [EstimatedCost]           MONEY          NULL,
    [encodedKeyWords]         NVARCHAR (255) NULL,
    [fixedId]                 INT            NULL,
    [HasWJTasting]            BIT            NULL,
    [IsActiveWineN]           SMALLINT       CONSTRAINT [DF_Wine_IsActiveWineN] DEFAULT ((0)) NOT NULL,
    [Issue]                   NVARCHAR (255) NULL,
    [IsERPTasting]            BIT            NULL,
    [IsWJTasting]             BIT            NULL,
    [IsCurrentlyForSale]      BIT            NULL,
    [IsCurrentlyOnAuction]    BIT            NULL,
    [LabelName]               NVARCHAR (120) NOT NULL,
    [Location]                NVARCHAR (50)  NOT NULL,
    [Locale]                  NVARCHAR (50)  NOT NULL,
    [Maturity]                SMALLINT       NULL,
    [MostRecentPrice]         MONEY          NULL,
    [MostRecentPriceHi]       MONEY          NULL,
    [MostRecentAuctionPrice]  MONEY          NULL,
    [Notes]                   NVARCHAR (MAX) NULL,
    [Producer]                NVARCHAR (100) NOT NULL,
    [ProducerShow]            NVARCHAR (100) NOT NULL,
    [ProducerURL]             NVARCHAR (255) NULL,
    [ProducerProfileFileName] VARCHAR (50)   NULL,
    [ShortTitle]              INT            NULL,
    [Publication]             NVARCHAR (50)  NULL,
    [Places]                  NVARCHAR (150) NOT NULL,
    [Region]                  NVARCHAR (50)  NOT NULL,
    [Rating]                  SMALLINT       NULL,
    [RatingShow]              VARCHAR (45)   NULL,
    [ReviewerIdN]             INT            NULL,
    [showForERP]              BIT            NULL,
    [showForWJ]               BIT            NULL,
    [source]                  NVARCHAR (101) NOT NULL,
    [SourceDate]              DATE           NULL,
    [Site]                    NVARCHAR (25)  NOT NULL,
    [Vintage]                 NVARCHAR (4)   NOT NULL,
    [Variety]                 NVARCHAR (50)  NOT NULL,
    [VinN]                    INT            NOT NULL,
    [WineN]                   INT            NOT NULL,
    [WineType]                NVARCHAR (50)  NOT NULL,
    [oldIdn]                  INT            NULL,
    [oldWineN]                INT            NULL,
    [oldVinN]                 INT            NULL,
    [created]                 SMALLDATETIME  CONSTRAINT [DF_tWine_created] DEFAULT (getdate()) NOT NULL,
    [updated]                 SMALLDATETIME  NULL,
    [RV_TasteNote]            BINARY (8)     CONSTRAINT [DF__Wine__RV_TasteNo__14B2A6A8] DEFAULT (0x00) NOT NULL,
    [RV_Wine_N]               BINARY (8)     CONSTRAINT [DF__Wine__RV_Wine_N__15A6CAE1] DEFAULT (0x00) NOT NULL,
    CONSTRAINT [PK_Wine] PRIMARY KEY CLUSTERED ([ID] ASC)
);














GO
CREATE NONCLUSTERED INDEX [IX_Wine_WineNID]
    ON [dbo].[Wine]([Wine_N_ID] ASC, [TasteNote_ID] ASC)
    INCLUDE([Wine_VinN_ID], [ID]);






GO
CREATE NONCLUSTERED INDEX [IX_Wine_IsActiveWineN]
    ON [dbo].[Wine]([IsActiveWineN] ASC, [IsERPTasting] ASC, [IsWJTasting] ASC)
    INCLUDE([ID]);

