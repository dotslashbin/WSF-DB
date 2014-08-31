CREATE TABLE [dbo].[widMap] (
    [idN]        INT           IDENTITY (1, 1) NOT NULL,
    [wid]        NVARCHAR (20) NOT NULL,
    [vintage]    NVARCHAR (5)  NOT NULL,
    [jVinn]      INT           NULL,
    [jWineN]     INT           NULL,
    [wineN]      INT           NULL,
    [rowVersion] ROWVERSION    NULL,
    CONSTRAINT [PK_widMap] PRIMARY KEY CLUSTERED ([idN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_widMap_widVintage ]
    ON [dbo].[widMap]([wid] ASC, [vintage] ASC);

