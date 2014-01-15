CREATE TABLE [dbo].[WineProducer] (
    [ID]            INT            IDENTITY (0, 1) NOT NULL,
    [Name]          NVARCHAR (100) NOT NULL,
    [NameToShow]    NVARCHAR (100) NOT NULL,
    [WebSiteURL]    NVARCHAR (255) NULL,
    [locCountryID]  INT            NOT NULL,
    [locRegionID]   INT            NOT NULL,
    [locLocationID] INT            NOT NULL,
    [locLocaleID]   INT            NOT NULL,
    [locSiteID]     INT            NOT NULL,
    [Profile]       NVARCHAR (MAX) NULL,
    [ContactInfo]   NVARCHAR (MAX) NULL,
    [created]       SMALLDATETIME  CONSTRAINT [DF__WineProdu__creat__39987BE6] DEFAULT (getdate()) NOT NULL,
    [updated]       SMALLDATETIME  NULL,
    [WF_StatusID]   SMALLINT       CONSTRAINT [DF__WineProdu__WF_St__3A8CA01F] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_WineProducer] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_WineProducer_LocationCountry] FOREIGN KEY ([locCountryID]) REFERENCES [dbo].[LocationCountry] ([ID]),
    CONSTRAINT [FK_WineProducer_LocationLocale] FOREIGN KEY ([locLocaleID]) REFERENCES [dbo].[LocationLocale] ([ID]),
    CONSTRAINT [FK_WineProducer_LocationLocation] FOREIGN KEY ([locLocationID]) REFERENCES [dbo].[LocationLocation] ([ID]),
    CONSTRAINT [FK_WineProducer_LocationRegion] FOREIGN KEY ([locRegionID]) REFERENCES [dbo].[LocationRegion] ([ID]),
    CONSTRAINT [FK_WineProducer_LocationSite] FOREIGN KEY ([locSiteID]) REFERENCES [dbo].[LocationSite] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_WineProducer_Uniq]
    ON [dbo].[WineProducer]([Name] ASC)
    INCLUDE([ID], [NameToShow]);

