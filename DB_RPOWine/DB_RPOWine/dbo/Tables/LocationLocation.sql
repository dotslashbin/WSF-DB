CREATE TABLE [dbo].[LocationLocation] (
    [ID]          INT           IDENTITY (0, 1) NOT NULL,
    [Name]        NVARCHAR (50) NOT NULL,
    [created]     SMALLDATETIME CONSTRAINT [DF_LocationLocation_created] DEFAULT (getdate()) NOT NULL,
    [updated]     SMALLDATETIME NULL,
    [WF_StatusID] SMALLINT      CONSTRAINT [DF_LocationLocation_WF_StatusID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_LocationLocation] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_LocationLocation_WF_Statuses] FOREIGN KEY ([WF_StatusID]) REFERENCES [dbo].[WF_Statuses] ([ID])
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_LocationLocation_Uniq]
    ON [dbo].[LocationLocation]([Name] ASC)
    INCLUDE([ID]);

