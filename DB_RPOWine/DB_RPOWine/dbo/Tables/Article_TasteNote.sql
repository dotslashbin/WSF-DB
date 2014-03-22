CREATE TABLE [dbo].[Article_TasteNote] (
    [ArticleID]   INT           NOT NULL,
    [TasteNoteID] INT           NOT NULL,
    [created]     SMALLDATETIME CONSTRAINT [DF_Article_TasteNote_created] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Article_TasteNote] PRIMARY KEY CLUSTERED ([ArticleID] ASC, [TasteNoteID] ASC) ON [Articles],
    CONSTRAINT [FK_Article_TasteNote_Article] FOREIGN KEY ([ArticleID]) REFERENCES [dbo].[Article] ([ID]),
    CONSTRAINT [FK_Article_TasteNote_TasteNote] FOREIGN KEY ([TasteNoteID]) REFERENCES [dbo].[TasteNote] ([ID])
);

