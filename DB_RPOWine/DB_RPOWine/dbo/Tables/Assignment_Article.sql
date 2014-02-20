CREATE TABLE [dbo].[Assignment_Article] (
    [AssignmentID] INT           NOT NULL,
    [ArticleID]    INT           NOT NULL,
    [created]      SMALLDATETIME CONSTRAINT [DF_Assignment_Article_created] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Assignment_Article] PRIMARY KEY CLUSTERED ([AssignmentID] ASC, [ArticleID] ASC) ON [Articles],
    CONSTRAINT [FK_Assignment_Article_Article] FOREIGN KEY ([ArticleID]) REFERENCES [dbo].[Article] ([ID]),
    CONSTRAINT [FK_Assignment_Article_Assignment] FOREIGN KEY ([AssignmentID]) REFERENCES [dbo].[Assignment] ([ID])
);

