CREATE TABLE [dbo].[TastingEvent_Article] (
    [TastingEventID] INT           NOT NULL,
    [ArticleID]      INT           NOT NULL,
    [created]        SMALLDATETIME CONSTRAINT [DF_TastingEvent_Article_created] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_TastingEvent_Article] PRIMARY KEY CLUSTERED ([TastingEventID] ASC, [ArticleID] ASC) ON [Articles],
    CONSTRAINT [FK_TastingEvent_Article_Article] FOREIGN KEY ([ArticleID]) REFERENCES [dbo].[Article] ([ID]),
    CONSTRAINT [FK_TastingEvent_Article_TastingEvent] FOREIGN KEY ([TastingEventID]) REFERENCES [dbo].[TastingEvent] ([ID])
);

