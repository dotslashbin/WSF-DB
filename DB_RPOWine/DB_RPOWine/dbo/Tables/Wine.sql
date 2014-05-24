﻿CREATE TABLE [dbo].[Wine] (
    [TasteNote_ID]            INT            NOT NULL,
    [Wine_N_ID]               INT            NOT NULL,
    [Wine_VinN_ID]            INT            NOT NULL,
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
    [IsActiveWineN]           BIT            NULL,
    [Issue]                   NVARCHAR (255) NOT NULL,
    [IsERPTasting]            BIT            NULL,
    [IsWJTasting]             BIT            NULL,
    [IsCurrentlyForSale]      BIT            NULL,
    [LabelName]               NVARCHAR (120) NOT NULL,
    [Location]                NVARCHAR (50)  NOT NULL,
    [Locale]                  NVARCHAR (50)  NOT NULL,
    [Maturity]                SMALLINT       NOT NULL,
    [MostRecentPrice]         MONEY          NULL,
    [MostRecentPriceHi]       MONEY          NULL,
    [MostRecentAuctionPrice]  MONEY          NULL,
    [Notes]                   NVARCHAR (MAX) NULL,
    [Producer]                NVARCHAR (100) NOT NULL,
    [ProducerShow]            NVARCHAR (100) NOT NULL,
    [ProducerURL]             NVARCHAR (255) NULL,
    [ProducerProfileFileName] VARCHAR (50)   NULL,
    [ShortTitle]              INT            NULL,
    [Publication]             NVARCHAR (50)  NOT NULL,
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
    CONSTRAINT [PK_Wine] PRIMARY KEY CLUSTERED ([TasteNote_ID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_Wine_WineNID]
    ON [dbo].[Wine]([Wine_N_ID] ASC)
    INCLUDE([TasteNote_ID], [Wine_VinN_ID]);

