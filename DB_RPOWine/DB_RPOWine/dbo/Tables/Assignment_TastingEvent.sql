CREATE TABLE [dbo].[Assignment_TastingEvent] (
    [AssignmentID]   INT           NOT NULL,
    [TastingEventID] INT           NOT NULL,
    [created]        SMALLDATETIME CONSTRAINT [DF_Assignment_TastingEvent_created] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Assignment_TastingEvent] PRIMARY KEY CLUSTERED ([AssignmentID] ASC, [TastingEventID] ASC) ON [Articles],
    CONSTRAINT [FK_Assignment_TastingEvent_Assignment] FOREIGN KEY ([AssignmentID]) REFERENCES [dbo].[Assignment] ([ID]),
    CONSTRAINT [FK_Assignment_TastingEvent_TastingEvent] FOREIGN KEY ([TastingEventID]) REFERENCES [dbo].[TastingEvent] ([ID])
);

