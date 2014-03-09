CREATE TABLE [dbo].[Assignment_ResourceD] (
    [AssignmentID] INT           NOT NULL,
    [TypeID]       INT           NOT NULL,
    [Deadline]     DATE          NOT NULL,
    [created]      SMALLDATETIME CONSTRAINT [DF_Assignment_ResourceD_created] DEFAULT (getdate()) NOT NULL,
    [updated]      SMALLDATETIME NULL,
    CONSTRAINT [PK_Assignment_ResourceD] PRIMARY KEY CLUSTERED ([AssignmentID] ASC, [TypeID] ASC),
    CONSTRAINT [FK_Assignment_ResourceD_Assignment] FOREIGN KEY ([AssignmentID]) REFERENCES [dbo].[Assignment] ([ID])
);



