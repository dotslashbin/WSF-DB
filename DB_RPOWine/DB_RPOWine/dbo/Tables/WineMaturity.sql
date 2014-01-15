CREATE TABLE [dbo].[WineMaturity] (
    [ID]         SMALLINT      IDENTITY (0, 1) NOT NULL,
    [Name]       NVARCHAR (20) NOT NULL,
    [Suggestion] NVARCHAR (20) NOT NULL,
    [created]    SMALLDATETIME CONSTRAINT [DF__WineMatur__creat__2E11BAA1] DEFAULT (getdate()) NOT NULL,
    [updated]    SMALLDATETIME NULL,
    CONSTRAINT [PK_WineMaturity] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_WineMaturity_Uniq]
    ON [dbo].[WineMaturity]([Name] ASC)
    INCLUDE([ID]);

