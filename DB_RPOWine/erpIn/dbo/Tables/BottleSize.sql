CREATE TABLE [dbo].[BottleSize] (
    [bottleSizeN]   INT          IDENTITY (1, 1) NOT NULL,
    [name]          VARCHAR (50) NOT NULL,
    [litres]        FLOAT (53)   NOT NULL,
    [createDate]    DATE         CONSTRAINT [DF_CellarBottleSize_createDate] DEFAULT (getdate()) NOT NULL,
    [updateDate]    DATE         CONSTRAINT [DF_CellarBottleSize_updateDate] DEFAULT (getdate()) NOT NULL,
    [shortName]     VARCHAR (50) NULL,
    [nameInSummary] VARCHAR (50) NULL,
    CONSTRAINT [PK_CellarBottleSize] PRIMARY KEY CLUSTERED ([bottleSizeN] ASC)
);

