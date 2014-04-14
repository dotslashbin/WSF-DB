CREATE TABLE [dbo].[StdDryness] (
    [IdN]       INT            IDENTITY (1, 1) NOT NULL,
    [Dryness]   NVARCHAR (200) NULL,
    [Cnt]       INT            NULL,
    [IsOK]      BIT            NULL,
    [IsERP]     BIT            NULL,
    [DateAdded] SMALLDATETIME  NULL,
    CONSTRAINT [PK_StdDryness] PRIMARY KEY CLUSTERED ([IdN] ASC)
);

