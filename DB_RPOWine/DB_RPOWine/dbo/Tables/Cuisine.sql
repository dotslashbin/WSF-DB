CREATE TABLE [dbo].[Cuisine] (
    [ID]          INT           IDENTITY (0, 1) NOT NULL,
    [Name]        NVARCHAR (30) NOT NULL,
    [created]     SMALLDATETIME CONSTRAINT [DF_Cuisine_created] DEFAULT (getdate()) NOT NULL,
    [updated]     SMALLDATETIME NULL,
    [WF_StatusID] SMALLINT      CONSTRAINT [DF_Cuisine_WF_StatusID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Cuisine] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Cuisine_Uniq]
    ON [dbo].[Cuisine]([Name] ASC)
    INCLUDE([ID]);

