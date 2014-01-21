CREATE TABLE [dbo].[WineLabel] (
    [ID]               INT            IDENTITY (0, 1) NOT NULL,
    [Name]             NVARCHAR (120) NOT NULL,
    [created]          SMALLDATETIME  CONSTRAINT [DF_WineLabel_created] DEFAULT (getdate()) NOT NULL,
    [updated]          SMALLDATETIME  NULL,
    [WF_StatusID]      SMALLINT       CONSTRAINT [DF_WineLabel_WF_StatusID] DEFAULT ((0)) NOT NULL,
    [DefaultColorID]   INT            CONSTRAINT [DF_WineLabel_DefaultColorID] DEFAULT ((-1)) NOT NULL,
    [DefaultDrynessID] INT            CONSTRAINT [DF_WineLabel_DefaultDrynessID] DEFAULT ((-1)) NOT NULL,
    CONSTRAINT [PK_WineLabel] PRIMARY KEY CLUSTERED ([ID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_WineLabel_Uniq]
    ON [dbo].[WineLabel]([Name] ASC)
    INCLUDE([ID], [DefaultColorID], [DefaultDrynessID]);

