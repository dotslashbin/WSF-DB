CREATE TABLE [dbo].[WFHist] (
    [ObjectTypeID] INT           NOT NULL,
    [ObjectID]     INT           NOT NULL,
    [StatusID]     INT           NOT NULL,
    [AssignedByID] INT           NOT NULL,
    [AssignedToID] INT           NOT NULL,
    [AssignedDate] DATETIME      NOT NULL,
    [Note]         VARCHAR (MAX) NULL,
    CONSTRAINT [PK_WFHist] PRIMARY KEY CLUSTERED ([ObjectTypeID] ASC, [ObjectID] ASC, [AssignedDate] ASC) ON [WF],
    CONSTRAINT [FK_WFHist_WF] FOREIGN KEY ([ObjectTypeID], [ObjectID]) REFERENCES [dbo].[WF] ([ObjectTypeID], [ObjectID])
) TEXTIMAGE_ON [WF];

