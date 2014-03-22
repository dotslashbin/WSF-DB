CREATE TABLE [dbo].[LocationCity] (
    [ID]          INT           IDENTITY (0, 1) NOT NULL,
    [Name]        NVARCHAR (50) NOT NULL,
    [created]     SMALLDATETIME CONSTRAINT [DF_LocationCity_created] DEFAULT (getdate()) NOT NULL,
    [updated]     SMALLDATETIME NULL,
    [WF_StatusID] SMALLINT      CONSTRAINT [DF_LocationCity_WF_StatusID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_LocationCity] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_LocationCity_WF_Statuses] FOREIGN KEY ([WF_StatusID]) REFERENCES [dbo].[WF_Statuses] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_LocationCity_Uniq]
    ON [dbo].[LocationCity]([Name] ASC);

