CREATE TABLE [dbo].[Issue_Article] (
    [IssueID]   INT           NOT NULL,
    [ArticleID] INT           NOT NULL,
    [created]   SMALLDATETIME CONSTRAINT [DF_Issue_Article_created] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Issue_Article] PRIMARY KEY CLUSTERED ([IssueID] ASC, [ArticleID] ASC) ON [Articles],
    CONSTRAINT [FK_Issue_Article_Article] FOREIGN KEY ([ArticleID]) REFERENCES [dbo].[Article] ([ID]),
    CONSTRAINT [FK_Issue_Article_Issue] FOREIGN KEY ([IssueID]) REFERENCES [dbo].[Issue] ([ID])
);

