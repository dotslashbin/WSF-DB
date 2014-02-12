CREATE TABLE [dbo].[Issue_TastingEvent] (
    [IssueID]        INT           NOT NULL,
    [TastingEventID] INT           NOT NULL,
    [created]        SMALLDATETIME CONSTRAINT [DF_Issue_TastingEvent_created] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Issue_TastingEvent] PRIMARY KEY CLUSTERED ([IssueID] ASC, [TastingEventID] ASC),
    CONSTRAINT [FK_Issue_TastingEvent_Issue] FOREIGN KEY ([IssueID]) REFERENCES [dbo].[Issue] ([ID]),
    CONSTRAINT [FK_Issue_TastingEvent_TastingEvent] FOREIGN KEY ([TastingEventID]) REFERENCES [dbo].[TastingEvent] ([ID])
);

