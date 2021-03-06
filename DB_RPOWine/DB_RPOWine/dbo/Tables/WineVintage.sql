﻿CREATE TABLE [dbo].[WineVintage] (
    [ID]          INT           IDENTITY (0, 1) NOT NULL,
    [Name]        NVARCHAR (4)  NOT NULL,
    [created]     SMALLDATETIME CONSTRAINT [DF_WineVintage_created] DEFAULT (getdate()) NOT NULL,
    [updated]     SMALLDATETIME NULL,
    [WF_StatusID] SMALLINT      CONSTRAINT [DF_WineVintage_WF_StatusID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_WineVintage] PRIMARY KEY CLUSTERED ([ID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_WineVintage_Uniq]
    ON [dbo].[WineVintage]([Name] ASC)
    INCLUDE([ID]);

