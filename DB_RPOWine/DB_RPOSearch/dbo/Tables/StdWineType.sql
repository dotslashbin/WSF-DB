CREATE TABLE [dbo].[StdWineType] (
    [IdN]       INT            IDENTITY (1, 1) NOT NULL,
    [WineType]  NVARCHAR (200) NULL,
    [Cnt]       INT            NULL,
    [IsOK]      BIT            NULL,
    [IsERP]     BIT            NULL,
    [DateAdded] SMALLDATETIME  NULL,
    CONSTRAINT [PK_StdWineType] PRIMARY KEY CLUSTERED ([IdN] ASC)
);

