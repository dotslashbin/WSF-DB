CREATE TABLE [dbo].[bugLocation] (
    [locationN]            INT           IDENTITY (1, 1) NOT NULL,
    [whN]                  INT           NOT NULL,
    [parentLocationN]      INT           NULL,
    [prevItemIndex]        INT           NULL,
    [name]                 VARCHAR (100) NOT NULL,
    [currentBottleCount]   SMALLINT      NULL,
    [maxBottleCount]       SMALLINT      NULL,
    [isBottle]             BIT           NOT NULL,
    [purchaseN]            INT           NULL,
    [bottleCountHere]      INT           NULL,
    [bottleCountAvailable] INT           NULL,
    [createDate]           DATE          NOT NULL,
    [updateDate]           DATE          NOT NULL,
    [hasManyWines]         BIT           NULL,
    [locationCapacity]     SMALLINT      NULL,
    [handle]               INT           NULL,
    [rowVersion]           ROWVERSION    NOT NULL
);

