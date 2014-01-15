CREATE TABLE [dbo].[Publication_TasteNote] (
    [PublicationID] INT           NOT NULL,
    [TasteNoteID]   INT           NOT NULL,
    [created]       SMALLDATETIME CONSTRAINT [DF_Publication_TasteNote_created] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Publication_TasteNote] PRIMARY KEY CLUSTERED ([PublicationID] ASC, [TasteNoteID] ASC),
    CONSTRAINT [FK_Publication_TasteNote_Publication] FOREIGN KEY ([PublicationID]) REFERENCES [dbo].[Publication] ([ID]),
    CONSTRAINT [FK_Publication_TasteNote_TasteNote] FOREIGN KEY ([TasteNoteID]) REFERENCES [dbo].[TasteNote] ([ID])
);

