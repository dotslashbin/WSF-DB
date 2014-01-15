CREATE TABLE [dbo].[LocationLocale] (
    [ID]          INT           IDENTITY (0, 1) NOT NULL,
    [Name]        NVARCHAR (50) NOT NULL,
    [created]     SMALLDATETIME DEFAULT (getdate()) NOT NULL,
    [updated]     SMALLDATETIME NULL,
    [WF_StatusID] SMALLINT      DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_LocationLocale] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_LocationLocale_WF_Statuses] FOREIGN KEY ([WF_StatusID]) REFERENCES [dbo].[WF_Statuses] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_LocationLocale_Uniq]
    ON [dbo].[LocationLocale]([Name] ASC)
    INCLUDE([ID]);

