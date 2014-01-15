CREATE TABLE [dbo].[Reviewer] (
    [ID]             INT            IDENTITY (0, 1) NOT NULL,
    [Name]           NVARCHAR (120) NOT NULL,
    [UserId]         INT            CONSTRAINT [DF_Reviewer_UserId] DEFAULT ((0)) NOT NULL,
    [oldReviewerIdN] INT            CONSTRAINT [DF_Reviewer_oldRevIdn] DEFAULT ((0)) NOT NULL,
    [created]        SMALLDATETIME  CONSTRAINT [DF_Reviewer_created] DEFAULT (getdate()) NOT NULL,
    [updated]        SMALLDATETIME  NULL,
    [WF_StatusID]    SMALLINT       CONSTRAINT [DF_Reviewer_WF_StatusID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Reviewer] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Reviewer_Uniq]
    ON [dbo].[Reviewer]([Name] ASC)
    INCLUDE([ID], [UserId]);

