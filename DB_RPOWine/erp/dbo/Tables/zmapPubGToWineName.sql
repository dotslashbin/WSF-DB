CREATE TABLE [dbo].[zmapPubGToWineName] (
    [pubGN]     INT NOT NULL,
    [wineNameN] INT NOT NULL,
    CONSTRAINT [PK_mapPubGToWineName] PRIMARY KEY CLUSTERED ([pubGN] ASC, [wineNameN] ASC)
);

