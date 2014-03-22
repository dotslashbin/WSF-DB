CREATE TABLE [dbo].[TastingEvent] (
    [ID]       INT            IDENTITY (1, 1) NOT NULL,
    [Title]    NVARCHAR (255) NOT NULL,
    [Location] NVARCHAR (100) NULL,
    [Notes]    NVARCHAR (MAX) NULL,
    [created]  SMALLDATETIME  CONSTRAINT [DF_TastingEvent_created] DEFAULT (getdate()) NOT NULL,
    [updated]  SMALLDATETIME  NULL,
    CONSTRAINT [PK_TastingEvent] PRIMARY KEY CLUSTERED ([ID] ASC) ON [TasteNotes]
) TEXTIMAGE_ON [TasteNotes];









