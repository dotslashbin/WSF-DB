CREATE TABLE [dbo].[whToWineBottle] (
    [whN]         INT           NOT NULL,
    [wineN]       INT           NOT NULL,
    [wineBottleN] INT           IDENTITY (1, 1) NOT NULL,
    [bottleCount] SMALLINT      NULL,
    [location]    VARCHAR (MAX) NULL,
    [createDate]  SMALLDATETIME CONSTRAINT [DF_whToWineBottle_createDate] DEFAULT (getdate()) NULL,
    [rowversion]  ROWVERSION    NULL,
    CONSTRAINT [PK_whoToWineBottle] PRIMARY KEY CLUSTERED ([whN] ASC, [wineN] ASC, [wineBottleN] ASC)
);

