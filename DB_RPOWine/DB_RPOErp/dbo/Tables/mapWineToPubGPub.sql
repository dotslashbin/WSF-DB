CREATE TABLE [dbo].[mapWineToPubGPub] (
    [wineN]                INT        NOT NULL,
    [pubGN]                INT        NOT NULL,
    [otherPubN]            INT        NOT NULL,
    [otherPubIconN]        SMALLINT   NULL,
    [otherPubTastingCount] INT        NULL,
    [rowversion]           ROWVERSION NOT NULL,
    CONSTRAINT [PK_mapWineToPubGPub] PRIMARY KEY CLUSTERED ([wineN] ASC, [pubGN] ASC, [otherPubN] ASC)
);

