CREATE TABLE [dbo].[WineVariety] (
    [ID]          INT           IDENTITY (0, 1) NOT NULL,
    [Name]        NVARCHAR (50) NOT NULL,
    [created]     SMALLDATETIME CONSTRAINT [DF_WineVarie_created] DEFAULT (getdate()) NOT NULL,
    [updated]     SMALLDATETIME NULL,
    [WF_StatusID] SMALLINT      CONSTRAINT [DF_WineVarie_WF_StatusID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_WineVariety] PRIMARY KEY CLUSTERED ([ID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_WineVariety_Uniq]
    ON [dbo].[WineVariety]([Name] ASC)
    INCLUDE([ID]);

