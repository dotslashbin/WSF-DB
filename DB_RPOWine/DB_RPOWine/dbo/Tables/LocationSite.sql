CREATE TABLE [dbo].[LocationSite] (
    [ID]          INT           IDENTITY (0, 1) NOT NULL,
    [Name]        NVARCHAR (50) NOT NULL,
    [created]     SMALLDATETIME DEFAULT (getdate()) NOT NULL,
    [updated]     SMALLDATETIME NULL,
    [WF_StatusID] SMALLINT      DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_LocationSite] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_LocationSite_WF_Statuses] FOREIGN KEY ([WF_StatusID]) REFERENCES [dbo].[WF_Statuses] ([ID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_LocationSite_Uniq]
    ON [dbo].[LocationSite]([Name] ASC);

