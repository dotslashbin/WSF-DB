CREATE TABLE [dbo].[actions] (
    [actionN]             INT           IDENTITY (1, 1) NOT NULL,
    [timeOfOldestRequest] DATETIME      NULL,
    [actionName]          NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_action] PRIMARY KEY CLUSTERED ([actionN] ASC)
);

