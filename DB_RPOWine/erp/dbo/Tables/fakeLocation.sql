CREATE TABLE [dbo].[fakeLocation] (
    [ii]                   INT           NULL,
    [locationN]            INT           NULL,
    [whN]                  INT           NOT NULL,
    [name]                 VARCHAR (100) NOT NULL,
    [currentBottleCount]   SMALLINT      NULL,
    [maxBottleCount]       SMALLINT      NULL,
    [remainingBottleCount] SMALLINT      NULL
);


GO
CREATE NONCLUSTERED INDEX [ix_fakeLocationRemainingBottleCount	]
    ON [dbo].[fakeLocation]([remainingBottleCount] ASC);

