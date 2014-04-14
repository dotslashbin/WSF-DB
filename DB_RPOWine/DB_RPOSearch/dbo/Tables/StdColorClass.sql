CREATE TABLE [dbo].[StdColorClass] (
    [IdN]        INT            IDENTITY (1, 1) NOT NULL,
    [ColorClass] NVARCHAR (200) NULL,
    [Cnt]        INT            NULL,
    [IsOK]       BIT            NULL,
    [IsERP]      BIT            NULL,
    [DateAdded]  SMALLDATETIME  NULL,
    CONSTRAINT [PK_StdColorClass] PRIMARY KEY CLUSTERED ([IdN] ASC)
);

