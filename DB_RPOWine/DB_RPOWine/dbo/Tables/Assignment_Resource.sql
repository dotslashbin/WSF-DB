CREATE TABLE [dbo].[Assignment_Resource] (
    [AssignmentID] INT           NOT NULL,
    [UserId]       INT           NOT NULL,
    [UserRoleID]   INT           NOT NULL,
    [Deadline]     DATE          NULL,
    [created]      SMALLDATETIME CONSTRAINT [DF_Assignment_Resources_created] DEFAULT (getdate()) NOT NULL,
    [updated]      SMALLDATETIME NULL,
    CONSTRAINT [PK_Assignment_Resources_1] PRIMARY KEY CLUSTERED ([AssignmentID] ASC, [UserId] ASC),
    CONSTRAINT [FK_Assignment_Resources_Assignment] FOREIGN KEY ([AssignmentID]) REFERENCES [dbo].[Assignment] ([ID]),
    CONSTRAINT [FK_Assignment_Resources_UserRoles] FOREIGN KEY ([UserRoleID]) REFERENCES [dbo].[UserRoles] ([ID])
);

