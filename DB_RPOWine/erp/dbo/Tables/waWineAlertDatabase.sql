CREATE TABLE [dbo].[waWineAlertDatabase] (
    [ID]            INT            NOT NULL,
    [WineAlert ID]  NVARCHAR (255) NULL,
    [Vinn]          NVARCHAR (255) NULL,
    [Prod]          NVARCHAR (255) NULL,
    [ProdShow]      NVARCHAR (255) NULL,
    [LabelName]     NVARCHAR (255) NULL,
    [Variety]       NVARCHAR (255) NULL,
    [ColorClass]    NVARCHAR (255) NULL,
    [Dryness]       NVARCHAR (255) NULL,
    [WineType]      NVARCHAR (255) NULL,
    [Country]       NVARCHAR (255) NULL,
    [Region]        NVARCHAR (255) NULL,
    [Location]      NVARCHAR (255) NULL,
    [vinn2]         INT            NULL,
    [producer2]     NVARCHAR (MAX) NULL,
    [producerShow2] NVARCHAR (MAX) NULL,
    [errors]        NVARCHAR (MAX) NULL,
    [warnings]      NVARCHAR (MAX) NULL
);

