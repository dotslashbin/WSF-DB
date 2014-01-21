CREATE TABLE [dbo].[WineType] (
    [ID]          INT           IDENTITY (0, 1) NOT NULL,
    [Name]        NVARCHAR (50) NOT NULL,
    [created]     SMALLDATETIME CONSTRAINT [DF_WineType_created] DEFAULT (getdate()) NOT NULL,
    [updated]     SMALLDATETIME NULL,
    [WF_StatusID] SMALLINT      CONSTRAINT [DF_WineType_WF_StatusID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_WineType] PRIMARY KEY CLUSTERED ([ID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_WineType_Uniq]
    ON [dbo].[WineType]([Name] ASC)
    INCLUDE([ID]);

