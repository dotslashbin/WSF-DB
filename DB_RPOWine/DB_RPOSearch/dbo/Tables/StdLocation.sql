CREATE TABLE [dbo].[StdLocation] (
    [IdN]       INT            IDENTITY (1, 1) NOT NULL,
    [Location]  NVARCHAR (200) NULL,
    [Scale]     NVARCHAR (50)  NULL,
    [Cnt]       INT            NULL,
    [IsOK]      BIT            NULL,
    [IsERP]     BIT            NULL,
    [DateAdded] SMALLDATETIME  NULL,
    CONSTRAINT [PK_StdLocation] PRIMARY KEY CLUSTERED ([IdN] ASC)
);

