CREATE TABLE [dbo].[TastingEvent_TasteNote] (
    [TastingEventID] INT           NOT NULL,
    [TasteNoteID]    INT           NOT NULL,
    [created]        SMALLDATETIME CONSTRAINT [DF_TastingEvent_TasteNote_created] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_TastingEvent_TasteNote] PRIMARY KEY CLUSTERED ([TastingEventID] ASC, [TasteNoteID] ASC),
    CONSTRAINT [FK_TastingEvent_TasteNote_TasteNote] FOREIGN KEY ([TasteNoteID]) REFERENCES [dbo].[TasteNote] ([ID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_TastingEvent_TasteNote_TastingEvent1] FOREIGN KEY ([TastingEventID]) REFERENCES [dbo].[TastingEvent] ([ID]) ON DELETE CASCADE ON UPDATE CASCADE
);



