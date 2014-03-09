CREATE TABLE [dbo].[Issue_TasteNote] (
    [IssueID]             INT           NOT NULL,
    [TasteNoteID]         INT           NOT NULL,
    [created]             SMALLDATETIME CONSTRAINT [DF_Issue_TasteNote_created] DEFAULT (getdate()) NOT NULL,
    [oldArticleIdNKey]    INT           NULL,
    [oldArticleId]        INT           NULL,
    [oldArticleClumpName] VARCHAR (30)  NULL,
    [oldPages]            VARCHAR (30)  NULL,
    [oldFixedId]          INT           NULL,
    CONSTRAINT [PK_Issue_TasteNote] PRIMARY KEY CLUSTERED ([IssueID] ASC, [TasteNoteID] ASC),
    CONSTRAINT [FK_Issue_TasteNote_Issue] FOREIGN KEY ([IssueID]) REFERENCES [dbo].[Issue] ([ID]),
    CONSTRAINT [FK_Issue_TasteNote_TasteNote] FOREIGN KEY ([TasteNoteID]) REFERENCES [dbo].[TasteNote] ([ID])
);






GO
CREATE NONCLUSTERED INDEX [IX_Issue_TasteNote_Old]
    ON [dbo].[Issue_TasteNote]([TasteNoteID] ASC)
    INCLUDE([IssueID], [oldArticleIdNKey], [oldArticleId]);

