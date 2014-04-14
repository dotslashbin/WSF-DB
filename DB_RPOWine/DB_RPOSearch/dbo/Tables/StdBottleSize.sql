CREATE TABLE [dbo].[StdBottleSize] (
    [WAlertBottleSize]    NVARCHAR (255) NOT NULL,
    [MilliLitres]         INT            NULL,
    [BottlesPerStockItem] INT            NULL,
    [Pending]             BIT            NULL,
    [IsOK]                BIT            NULL,
    [DateAdded]           SMALLDATETIME  NULL
);

