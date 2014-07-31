CREATE TABLE [dbo].[BottleLocation] (
    [bottleLocationN]      INT  NOT NULL,
    [whN]                  INT  NOT NULL,
    [locationN]            INT  NOT NULL,
    [prevItemIndex]        INT  NOT NULL,
    [purchaseN]            INT  NOT NULL,
    [bottleCountHere]      INT  NOT NULL,
    [bottleCountAvailable] INT  NOT NULL,
    [createDate]           DATE NOT NULL,
    [updateDate]           DATE NOT NULL
);

