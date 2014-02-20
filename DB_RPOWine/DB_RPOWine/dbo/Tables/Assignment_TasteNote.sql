CREATE TABLE [dbo].[Assignment_TasteNote] (
    [AssignmentID] INT           NOT NULL,
    [TasteNoteID]  INT           NOT NULL,
    [created]      SMALLDATETIME CONSTRAINT [DF_Assignment_TasteNote_created] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Assignment_TasteNote] PRIMARY KEY CLUSTERED ([AssignmentID] ASC, [TasteNoteID] ASC) ON [Articles],
    CONSTRAINT [FK_Assignment_TasteNote_Assignment] FOREIGN KEY ([AssignmentID]) REFERENCES [dbo].[Assignment] ([ID]),
    CONSTRAINT [FK_Assignment_TasteNote_TasteNote] FOREIGN KEY ([TasteNoteID]) REFERENCES [dbo].[TasteNote] ([ID])
);

