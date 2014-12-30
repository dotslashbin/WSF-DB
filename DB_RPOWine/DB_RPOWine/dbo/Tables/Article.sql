CREATE TABLE [dbo].[Article] (
    [ID]               INT            IDENTITY (1, 1) NOT NULL,
    [PublicationID]    INT            NOT NULL,
    [AuthorId]         INT            NOT NULL,
    [Author]           NVARCHAR (100) CONSTRAINT [DF_Article_Author] DEFAULT ('') NOT NULL,
    [Title]            NVARCHAR (255) NOT NULL,
    [ShortTitle]       NVARCHAR (150) NULL,
    [Date]             DATE           NULL,
    [Notes]            NVARCHAR (MAX) NULL,
    [MetaTags]         NVARCHAR (MAX) NULL,
    [Event]            NVARCHAR (120) NULL,
    [CuisineID]        INT            CONSTRAINT [DF_Article_CuisineID] DEFAULT ((0)) NOT NULL,
    [locCountryID]     INT            CONSTRAINT [DF_Article_locCountryID] DEFAULT ((0)) NOT NULL,
    [locRegionID]      INT            CONSTRAINT [DF_Article_locRegionID] DEFAULT ((0)) NOT NULL,
    [locLocationID]    INT            CONSTRAINT [DF_Article_locLocationID] DEFAULT ((0)) NOT NULL,
    [locLocaleID]      INT            CONSTRAINT [DF_Article_locLocaleID] DEFAULT ((0)) NOT NULL,
    [locSiteID]        INT            CONSTRAINT [DF_Article_locSiteID] DEFAULT ((0)) NOT NULL,
    [locStateID]       INT            CONSTRAINT [DF_Article_locStateID] DEFAULT ((0)) NOT NULL,
    [locCityID]        INT            CONSTRAINT [DF_Article_locCityID] DEFAULT ((0)) NOT NULL,
    [created]          SMALLDATETIME  CONSTRAINT [DF_Article_created] DEFAULT (getdate()) NOT NULL,
    [updated]          SMALLDATETIME  NULL,
    [WF_StatusID]      SMALLINT       CONSTRAINT [DF_Article_WF_StatusID] DEFAULT ((0)) NOT NULL,
    [oldArticleIdN]    INT            NULL,
    [oldArticleId]     INT            NULL,
    [oldArticleIdNKey] INT            NULL,
    [FileName]         VARCHAR (50)   NULL,
    [Producer]         NVARCHAR (100) NULL,
    [Source]           NVARCHAR (100) NULL,
    [Topic]            NVARCHAR (100) NULL,
    [Type]             NVARCHAR (100) NULL,
    [Wine_Numbers]     NVARCHAR (500) NULL,
    [Wines]            NVARCHAR (500) NULL,
    [Vintage]          NVARCHAR (100) NULL,
    [Appellation]      NVARCHAR (100) NULL,
    CONSTRAINT [PK_Article] PRIMARY KEY CLUSTERED ([ID] ASC) ON [Articles],
    CONSTRAINT [FK_Article_LocationCity] FOREIGN KEY ([locCityID]) REFERENCES [dbo].[LocationCity] ([ID]),
    CONSTRAINT [FK_Article_LocationCountry] FOREIGN KEY ([locCountryID]) REFERENCES [dbo].[LocationCountry] ([ID]),
    CONSTRAINT [FK_Article_LocationLocale] FOREIGN KEY ([locLocaleID]) REFERENCES [dbo].[LocationLocale] ([ID]),
    CONSTRAINT [FK_Article_LocationLocation] FOREIGN KEY ([locLocationID]) REFERENCES [dbo].[LocationLocation] ([ID]),
    CONSTRAINT [FK_Article_LocationRegion] FOREIGN KEY ([locRegionID]) REFERENCES [dbo].[LocationRegion] ([ID]),
    CONSTRAINT [FK_Article_LocationSite] FOREIGN KEY ([locSiteID]) REFERENCES [dbo].[LocationSite] ([ID]),
    CONSTRAINT [FK_Article_LocationState] FOREIGN KEY ([locStateID]) REFERENCES [dbo].[LocationState] ([ID]),
    CONSTRAINT [FK_Article_Publication] FOREIGN KEY ([PublicationID]) REFERENCES [dbo].[Publication] ([ID])
) TEXTIMAGE_ON [Articles];


















GO
CREATE NONCLUSTERED INDEX [IX_Article_oldarticleIdNKey]
    ON [dbo].[Article]([oldArticleIdNKey] ASC)
    INCLUDE([ID], [PublicationID], [AuthorId], [Title])
    ON [PRIMARY];

