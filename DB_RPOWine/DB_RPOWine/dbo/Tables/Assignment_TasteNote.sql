CREATE TABLE [dbo].[Assignment_TasteNote] (
    [AssignmentID] INT           NOT NULL,
    [TasteNoteID]  INT           NOT NULL,
    [created]      SMALLDATETIME CONSTRAINT [DF_Assignment_TasteNote_created] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Assignment_TasteNote] PRIMARY KEY CLUSTERED ([AssignmentID] ASC, [TasteNoteID] ASC) ON [Articles],
    CONSTRAINT [FK_Assignment_TasteNote_Assignment1] FOREIGN KEY ([AssignmentID]) REFERENCES [dbo].[Assignment] ([ID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_Assignment_TasteNote_TasteNote1] FOREIGN KEY ([TasteNoteID]) REFERENCES [dbo].[TasteNote] ([ID]) ON DELETE CASCADE ON UPDATE CASCADE
);



