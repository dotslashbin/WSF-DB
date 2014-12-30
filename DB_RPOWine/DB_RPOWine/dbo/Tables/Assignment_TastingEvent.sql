CREATE TABLE [dbo].[Assignment_TastingEvent] (
    [AssignmentID]   INT           NOT NULL,
    [TastingEventID] INT           NOT NULL,
    [created]        SMALLDATETIME CONSTRAINT [DF_Assignment_TastingEvent_created] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Assignment_TastingEvent] PRIMARY KEY CLUSTERED ([AssignmentID] ASC, [TastingEventID] ASC) ON [Articles],
    CONSTRAINT [FK_Assignment_TastingEvent_Assignment1] FOREIGN KEY ([AssignmentID]) REFERENCES [dbo].[Assignment] ([ID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_Assignment_TastingEvent_TastingEvent1] FOREIGN KEY ([TastingEventID]) REFERENCES [dbo].[TastingEvent] ([ID]) ON DELETE CASCADE ON UPDATE CASCADE
);






GO
CREATE NONCLUSTERED INDEX [IX_Assignment_TastingEvent_TastingEventID]
    ON [dbo].[Assignment_TastingEvent]([TastingEventID] ASC)
    INCLUDE([AssignmentID])
    ON [Articles];

