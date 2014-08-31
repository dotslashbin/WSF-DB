CREATE TABLE [dbo].[BottleConsumed] (
    [id]              INT        IDENTITY (1, 1) NOT NULL,
    [whN]             INT        NOT NULL,
    [numberOfBottles] TINYINT    NOT NULL,
    [locationN]       INT        NOT NULL,
    [purchaseN]       INT        NOT NULL,
    [consumeDate]     DATE       CONSTRAINT [DF_Table_1_consumeDt] DEFAULT (getdate()) NOT NULL,
    [handle]          INT        NULL,
    [rowVersion]      ROWVERSION NOT NULL,
    CONSTRAINT [PK_BottleConsumed] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_BottleConsumed]
    ON [dbo].[BottleConsumed]([locationN] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_BottleConsumed_1]
    ON [dbo].[BottleConsumed]([purchaseN] ASC);

