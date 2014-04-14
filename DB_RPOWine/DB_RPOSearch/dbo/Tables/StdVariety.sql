CREATE TABLE [dbo].[StdVariety] (
    [IdN]       INT            IDENTITY (1, 1) NOT NULL,
    [Variety]   NVARCHAR (200) NULL,
    [Cnt]       INT            NULL,
    [IsOK]      BIT            NULL,
    [IsERP]     BIT            NULL,
    [DateAdded] SMALLDATETIME  NULL,
    CONSTRAINT [PK_StdVariety] PRIMARY KEY CLUSTERED ([IdN] ASC)
);

