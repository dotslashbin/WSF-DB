CREATE TABLE [dbo].[InventoryData] (
    [id]        INT           IDENTITY (1, 1) NOT NULL,
    [CityState] VARCHAR (MAX) NULL,
    [Zipcode]   VARCHAR (50)  NULL,
    [Control]   VARCHAR (50)  NULL,
    [Email]     VARCHAR (MAX) NULL,
    CONSTRAINT [PK_ImportedCellars] PRIMARY KEY CLUSTERED ([id] ASC)
);

