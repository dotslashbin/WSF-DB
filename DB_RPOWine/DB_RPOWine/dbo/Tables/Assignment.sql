CREATE TABLE [dbo].[Assignment] (
    [ID]          INT            IDENTITY (1, 1) NOT NULL,
    [AuthorId]    INT            NOT NULL,
    [Title]       NVARCHAR (255) NOT NULL,
    [Deadline]    DATE           NULL,
    [Notes]       NVARCHAR (MAX) NULL,
    [created]     SMALLDATETIME  CONSTRAINT [DF_Assignment_created] DEFAULT (getdate()) NOT NULL,
    [updated]     SMALLDATETIME  NULL,
    [WF_StatusID] SMALLINT       CONSTRAINT [DF_Assignment_WF_StatusID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Assignment] PRIMARY KEY CLUSTERED ([ID] ASC) ON [Articles]
) TEXTIMAGE_ON [Articles];


GO
CREATE NONCLUSTERED INDEX [IX_Assignment_Search]
    ON [dbo].[Assignment]([AuthorId] ASC, [Title] ASC, [WF_StatusID] ASC)
    INCLUDE([ID])
    ON [PRIMARY];

