CREATE TABLE [dbo].[LocationCountry] (
    [ID]          INT           IDENTITY (0, 1) NOT NULL,
    [Code]        CHAR (2)      NULL,
    [Name]        NVARCHAR (25) NOT NULL,
    [created]     SMALLDATETIME CONSTRAINT [DF_LocationCountry_created] DEFAULT (getdate()) NOT NULL,
    [updated]     SMALLDATETIME NULL,
    [WF_StatusID] SMALLINT      CONSTRAINT [DF_LocationCountry_WF_StatusID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_LocationCountry] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_LocationCountry_WF_Statuses] FOREIGN KEY ([WF_StatusID]) REFERENCES [dbo].[WF_Statuses] ([ID])
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_LocationCountry_Uniq]
    ON [dbo].[LocationCountry]([Name] ASC)
    INCLUDE([ID]);

