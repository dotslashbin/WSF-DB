CREATE TABLE [dbo].[Assignment_Resource] (
    [AssignmentID] INT           NOT NULL,
    [UserId]       INT           NOT NULL,
    [UserRoleID]   INT           NOT NULL,
    [created]      SMALLDATETIME CONSTRAINT [DF_Assignment_Resources_created] DEFAULT (getdate()) NOT NULL,
    [updated]      SMALLDATETIME NULL,
    CONSTRAINT [PK_Assignment_Resource] PRIMARY KEY CLUSTERED ([AssignmentID] ASC, [UserId] ASC),
    CONSTRAINT [FK_Assignment_Resource_UserRoles] FOREIGN KEY ([UserRoleID]) REFERENCES [dbo].[UserRoles] ([ID]),
    CONSTRAINT [FK_Assignment_Resources_Assignment] FOREIGN KEY ([AssignmentID]) REFERENCES [dbo].[Assignment] ([ID])
);



