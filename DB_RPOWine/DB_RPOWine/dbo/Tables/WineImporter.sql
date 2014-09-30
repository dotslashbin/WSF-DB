CREATE TABLE [dbo].[WineImporter] (
    [ID]      INT            IDENTITY (1, 1) NOT NULL,
    [Name]    NVARCHAR (255) NOT NULL,
    [Address] NVARCHAR (255) NULL,
    [Phone1]  NVARCHAR (32)  NULL,
    [Phone2]  NVARCHAR (32)  NULL,
    [Fax]     NVARCHAR (32)  NULL,
    [Email]   NVARCHAR (64)  NULL,
    [URL]     NVARCHAR (64)  NULL,
    [created] SMALLDATETIME  CONSTRAINT [DF_WineImporter_created] DEFAULT (getdate()) NOT NULL,
    [updated] SMALLDATETIME  NULL,
    CONSTRAINT [PK_WineImporter] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_WineImporter]
    ON [dbo].[WineImporter]([Name] ASC);

