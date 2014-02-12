CREATE TABLE [dbo].[Article] (
    [ID]               INT            IDENTITY (1, 1) NOT NULL,
    [UserId]           INT            NOT NULL,
    [Title]            NVARCHAR (255) NOT NULL,
    [Date]             DATE           NULL,
    [Notes]            NVARCHAR (MAX) NULL,
    [MetaTags]         NVARCHAR (MAX) NULL,
    [created]          SMALLDATETIME  CONSTRAINT [DF_Article_created] DEFAULT (getdate()) NOT NULL,
    [updated]          SMALLDATETIME  NULL,
    [WF_StatusID]      SMALLINT       CONSTRAINT [DF_Article_WF_StatusID] DEFAULT ((0)) NOT NULL,
    [oldArticleIdNKey] INT            NULL,
    [oldArticleId]     INT            NULL,
    CONSTRAINT [PK_Article] PRIMARY KEY CLUSTERED ([ID] ASC) ON [Articles],
    CONSTRAINT [FK_Article_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId])
) TEXTIMAGE_ON [Articles];



