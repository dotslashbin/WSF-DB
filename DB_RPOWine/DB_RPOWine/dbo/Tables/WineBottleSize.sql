CREATE TABLE [dbo].[WineBottleSize] (
    [ID]          INT           IDENTITY (0, 1) NOT NULL,
    [Name]        NVARCHAR (30) NOT NULL,
    [Volume]      FLOAT (53)    CONSTRAINT [DF_WineBottle_Volume] DEFAULT ((0)) NOT NULL,
    [created]     SMALLDATETIME CONSTRAINT [DF_WineBottle_created] DEFAULT (getdate()) NOT NULL,
    [updated]     SMALLDATETIME NULL,
    [WF_StatusID] SMALLINT      CONSTRAINT [DF_WineBottle_WF_StatusID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_BottleSize] PRIMARY KEY CLUSTERED ([ID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_WineBottleSize_Uniq]
    ON [dbo].[WineBottleSize]([Name] ASC)
    INCLUDE([ID]);

