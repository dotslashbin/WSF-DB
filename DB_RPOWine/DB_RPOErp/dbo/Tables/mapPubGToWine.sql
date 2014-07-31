CREATE TABLE [dbo].[mapPubGToWine] (
    [pubGN]                INT          NOT NULL,
    [wineN]                INT          NOT NULL,
    [activeTastingN]       INT          NULL,
    [pubIconN]             SMALLINT     NULL,
    [maturity]             SMALLINT     NULL,
    [rating]               SMALLINT     NULL,
    [ratingShow]           VARCHAR (20) NULL,
    [tastingCountThisPubG] INT          NULL,
    [rowversion]           ROWVERSION   NULL,
    [wineNameN]            INT          NULL,
    CONSTRAINT [PK_mapPubGToWine] PRIMARY KEY CLUSTERED ([pubGN] ASC, [wineN] ASC)
);

