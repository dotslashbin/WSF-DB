CREATE TABLE [dbo].[WF_Statuses] (
    [ID]        SMALLINT      NOT NULL,
    [Name]      VARCHAR (30)  NOT NULL,
    [SortOrder] SMALLINT      CONSTRAINT [DF_WF_Statuses_SortOrder] DEFAULT ((0)) NOT NULL,
    [created]   SMALLDATETIME CONSTRAINT [DF_WF_Statuses_created] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_WF_Statuses] PRIMARY KEY CLUSTERED ([ID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_WF_Statuses_Uniq]
    ON [dbo].[WF_Statuses]([Name] ASC)
    INCLUDE([ID]);

