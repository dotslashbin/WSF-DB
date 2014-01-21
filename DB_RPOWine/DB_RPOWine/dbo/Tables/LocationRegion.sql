CREATE TABLE [dbo].[LocationRegion] (
    [ID]          INT           IDENTITY (0, 1) NOT NULL,
    [Name]        NVARCHAR (50) NOT NULL,
    [created]     SMALLDATETIME CONSTRAINT [DF_LocationRegion_created] DEFAULT (getdate()) NOT NULL,
    [updated]     SMALLDATETIME NULL,
    [WF_StatusID] SMALLINT      CONSTRAINT [DF_LocationRegion_WF_StatusID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_LocationRegion] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_LocationRegion_WF_Statuses] FOREIGN KEY ([WF_StatusID]) REFERENCES [dbo].[WF_Statuses] ([ID])
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_LocationRegion_Uniq]
    ON [dbo].[LocationRegion]([Name] ASC)
    INCLUDE([ID]);

