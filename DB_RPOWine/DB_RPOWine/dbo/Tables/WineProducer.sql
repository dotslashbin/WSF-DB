﻿CREATE TABLE [dbo].[WineProducer] (
    [ID]              INT            IDENTITY (0, 1) NOT NULL,
    [Name]            NVARCHAR (100) NOT NULL,
    [NameToShow]      NVARCHAR (100) NOT NULL,
    [WebSiteURL]      NVARCHAR (255) NULL,
    [locCountryID]    INT            CONSTRAINT [DF_WineProducer_locCountryID] DEFAULT ((0)) NOT NULL,
    [locRegionID]     INT            CONSTRAINT [DF_WineProducer_locRegionID] DEFAULT ((0)) NOT NULL,
    [locLocationID]   INT            CONSTRAINT [DF_WineProducer_locLocationID] DEFAULT ((0)) NOT NULL,
    [locLocaleID]     INT            CONSTRAINT [DF_WineProducer_locLocaleID] DEFAULT ((0)) NOT NULL,
    [locSiteID]       INT            CONSTRAINT [DF_WineProducer_locSiteID] DEFAULT ((0)) NOT NULL,
    [Profile]         NVARCHAR (MAX) NULL,
    [ContactInfo]     NVARCHAR (MAX) NULL,
    [created]         SMALLDATETIME  CONSTRAINT [DF_WineProducer_created] DEFAULT (getdate()) NOT NULL,
    [updated]         SMALLDATETIME  NULL,
    [WF_StatusID]     SMALLINT       CONSTRAINT [DF_WineProducer_WF_StatusID] DEFAULT ((0)) NOT NULL,
    [CreatorID]       INT            NULL,
    [EditorID]        INT            NULL,
    [ProfileFileName] VARCHAR (50)   NULL,
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

