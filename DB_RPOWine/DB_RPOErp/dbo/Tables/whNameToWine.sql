CREATE TABLE [dbo].[whNameToWine] (
    [whN]        INT            NOT NULL,
    [myWineName] NVARCHAR (200) NOT NULL,
    [vintage]    NCHAR (4)      NOT NULL,
    [wineN]      INT            NOT NULL,
    [isOld]      BIT            NOT NULL,
    [dateLo]     DATE           NULL,
    [dateHi]     DATE           NULL,
    CONSTRAINT [PK_whNameWineN] PRIMARY KEY CLUSTERED ([whN] ASC, [myWineName] ASC, [vintage] ASC, [wineN] ASC)
);

