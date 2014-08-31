CREATE TABLE [dbo].[Purchase] (
    [purchaseN]         INT             IDENTITY (1, 1) NOT NULL,
    [whN]               INT             NOT NULL,
    [wineN]             INT             NOT NULL,
    [supplierN]         INT             NOT NULL,
    [bottleSizeN]       INT             NOT NULL,
    [purchaseDate]      DATE            NOT NULL,
    [deliveryDate]      DATE            NULL,
    [pricePerBottle]    FLOAT (53)      NOT NULL,
    [bottleCount]       INT             NOT NULL,
    [notes]             VARBINARY (255) NULL,
    [createDate]        DATE            CONSTRAINT [DF_CellarPurchase_createDate] DEFAULT (getdate()) NOT NULL,
    [updateDate]        DATE            CONSTRAINT [DF_CellarPurchase_updateDate] DEFAULT (getdate()) NOT NULL,
    [bottleCountBought] INT             NULL,
    [handle]            INT             NULL,
    [rowVersion]        ROWVERSION      NOT NULL,
    CONSTRAINT [PK_CellarPurchase] PRIMARY KEY CLUSTERED ([purchaseN] ASC),
    CONSTRAINT [FK_CellarPurchase_CellarBottleSize] FOREIGN KEY ([bottleSizeN]) REFERENCES [dbo].[BottleSize] ([bottleSizeN]),
    CONSTRAINT [FK_CellarPurchase_CellarSupplier] FOREIGN KEY ([supplierN]) REFERENCES [dbo].[Supplier] ([supplierN])
);

