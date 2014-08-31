CREATE TABLE [dbo].[Supplier] (
    [supplierN]         INT           IDENTITY (1, 1) NOT NULL,
    [whN]               INT           NULL,
    [name]              VARCHAR (100) NOT NULL,
    [notes]             VARCHAR (255) NULL,
    [createDate]        DATE          CONSTRAINT [DF_CellarSupplier_createDate] DEFAULT (getdate()) NOT NULL,
    [updateDate]        DATE          CONSTRAINT [DF_CellarSupplier_updateDate] DEFAULT (getdate()) NOT NULL,
    [standardSupplierN] INT           NULL,
    [retailerN]         INT           NULL,
    [handle]            INT           NULL,
    [rowVersion]        ROWVERSION    NOT NULL,
    CONSTRAINT [PK_CellarSupplier] PRIMARY KEY CLUSTERED ([supplierN] ASC)
);

