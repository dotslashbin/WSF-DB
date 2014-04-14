CREATE TABLE [dbo].[StdProducer] (
    [IdN]       INT            IDENTITY (1, 1) NOT NULL,
    [Producer]  NVARCHAR (200) NULL,
    [Cnt]       INT            NULL,
    [IsOK]      BIT            NULL,
    [IsERP]     BIT            NULL,
    [DateAdded] SMALLDATETIME  NULL,
    CONSTRAINT [PK_StdProducer] PRIMARY KEY CLUSTERED ([IdN] ASC)
);

