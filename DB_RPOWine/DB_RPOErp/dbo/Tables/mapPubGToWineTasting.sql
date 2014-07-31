CREATE TABLE [dbo].[mapPubGToWineTasting] (
    [pubGN]      INT        NOT NULL,
    [wineN]      INT        NOT NULL,
    [tastingN]   INT        NOT NULL,
    [rowversion] ROWVERSION NULL,
    CONSTRAINT [PK_mapPubGToWineTasting] PRIMARY KEY CLUSTERED ([pubGN] ASC, [wineN] ASC, [tastingN] ASC)
);

