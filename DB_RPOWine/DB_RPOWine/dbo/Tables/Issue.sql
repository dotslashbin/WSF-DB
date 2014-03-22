CREATE TABLE [dbo].[Issue] (
    [ID]                INT            IDENTITY (1, 1) NOT NULL,
    [PublicationID]     INT            NOT NULL,
    [ChiefEditorUserId] INT            NULL,
    [Title]             NVARCHAR (255) NOT NULL,
    [CreatedDate]       DATE           NOT NULL,
    [PublicationDate]   DATE           NOT NULL,
    [Notes]             NVARCHAR (MAX) NULL,
    [created]           SMALLDATETIME  CONSTRAINT [DF_Issue_created] DEFAULT (getdate()) NOT NULL,
    [updated]           SMALLDATETIME  NULL,
    [WF_StatusID]       INT            CONSTRAINT [DF_Issue_WF_StatusID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Issue] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Issue_Publication] FOREIGN KEY ([PublicationID]) REFERENCES [dbo].[Publication] ([ID])
);






GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Issue_Uniq]
    ON [dbo].[Issue]([PublicationID] ASC, [Title] ASC)
    INCLUDE([ID]);

