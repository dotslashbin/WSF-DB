CREATE TABLE [dbo].[WineColor] (
    [ID]          INT           IDENTITY (0, 1) NOT NULL,
    [Name]        NVARCHAR (30) NOT NULL,
    [created]     SMALLDATETIME DEFAULT (getdate()) NOT NULL,
    [updated]     SMALLDATETIME NULL,
    [WF_StatusID] SMALLINT      DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_WineColor] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_WineColor_Uniq]
    ON [dbo].[WineColor]([Name] ASC)
    INCLUDE([ID]);

