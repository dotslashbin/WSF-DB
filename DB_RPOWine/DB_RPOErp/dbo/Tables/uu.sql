CREATE TABLE [dbo].[uu] (
    [id]           INT           IDENTITY (1, 1) NOT NULL,
    [MyWines]      VARCHAR (MAX) NULL,
    [Supplier]     VARCHAR (MAX) NULL,
    [Quantity]     VARCHAR (MAX) NULL,
    [BottleSize]   VARCHAR (MAX) NULL,
    [PurchaseDate] DATETIME      NULL,
    [DeliveryDate] DATETIME      NULL,
    [Price]        VARCHAR (MAX) NULL,
    [Location]     VARCHAR (MAX) NULL,
    [erpWineName]  VARCHAR (MAX) NULL,
    [wineN]        INT           NULL,
    [myVintage]    VARCHAR (MAX) NULL,
    [noMatch]      BIT           NULL
);

