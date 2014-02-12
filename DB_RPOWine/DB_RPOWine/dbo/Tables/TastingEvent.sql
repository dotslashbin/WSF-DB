CREATE TABLE [dbo].[TastingEvent] (
    [ID]            INT            IDENTITY (1, 1) NOT NULL,
    [ParentID]      INT            CONSTRAINT [DF_TastingEvent_ParentID] DEFAULT ((0)) NOT NULL,
    [UserId]        INT            NOT NULL,
    [Title]         NVARCHAR (255) NOT NULL,
    [StartDate]     DATE           NULL,
    [EndDate]       DATE           NULL,
    [Location]      NVARCHAR (100) NULL,
    [locCountryID]  INT            NULL,
    [locRegionID]   INT            NULL,
    [locLocationID] INT            NULL,
    [locLocaleID]   INT            NULL,
    [locSiteID]     INT            NULL,
    [Notes]         NVARCHAR (MAX) NULL,
    [SortOrder]     SMALLINT       CONSTRAINT [DF_TastingEvent_SortOrder] DEFAULT ((0)) NOT NULL,
    [created]       SMALLDATETIME  CONSTRAINT [DF_TastingEvent_created] DEFAULT (getdate()) NOT NULL,
    [updated]       SMALLDATETIME  NULL,
    [WF_StatusID]   SMALLINT       CONSTRAINT [DF_TastingEvent_WF_StatusID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_TastingEvent] PRIMARY KEY CLUSTERED ([ID] ASC) ON [TasteNotes],
    CONSTRAINT [FK_TastingEvent_TastingEvent] FOREIGN KEY ([ParentID]) REFERENCES [dbo].[TastingEvent] ([ID]),
    CONSTRAINT [FK_TastingEvent_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId])
) TEXTIMAGE_ON [TasteNotes];





