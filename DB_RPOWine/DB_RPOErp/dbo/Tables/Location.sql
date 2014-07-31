CREATE TABLE [dbo].[Location] (
    [locationN]            INT           IDENTITY (1, 1) NOT NULL,
    [whN]                  INT           NOT NULL,
    [parentLocationN]      INT           NULL,
    [prevItemIndex]        INT           NULL,
    [name]                 VARCHAR (100) NOT NULL,
    [currentBottleCount]   SMALLINT      NULL,
    [maxBottleCount]       SMALLINT      NULL,
    [isBottle]             BIT           CONSTRAINT [DF_Location_isBottle] DEFAULT ((0)) NOT NULL,
    [purchaseN]            INT           NULL,
    [bottleCountHere]      INT           NULL,
    [bottleCountAvailable] INT           NULL,
    [createDate]           DATE          CONSTRAINT [DF_CellarLocation_createDate] DEFAULT (getdate()) NOT NULL,
    [updateDate]           DATE          CONSTRAINT [DF_CellarLocation_updateDate] DEFAULT (getdate()) NOT NULL,
    [hasManyWines]         BIT           CONSTRAINT [DF_Location_hasManyWines] DEFAULT ((0)) NULL,
    [locationCapacity]     SMALLINT      NULL,
    [handle]               INT           NULL,
    [rowVersion]           ROWVERSION    NOT NULL,
    CONSTRAINT [PK_CellarLocation] PRIMARY KEY CLUSTERED ([locationN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_ParentLocation]
    ON [dbo].[Location]([parentLocationN] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Pruchase]
    ON [dbo].[Location]([purchaseN] ASC);

