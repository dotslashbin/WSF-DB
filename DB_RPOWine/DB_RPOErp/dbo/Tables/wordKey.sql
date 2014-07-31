CREATE TABLE [dbo].[wordKey] (
    [wordN]     INT             IDENTITY (1, 1) NOT NULL,
    [wordBin]   VARBINARY (128) NOT NULL,
    [word]      NVARCHAR (200)  NOT NULL,
    [wineNameN] BIGINT          NULL,
    [keywords]  NVARCHAR (2000) NULL,
    CONSTRAINT [PK_wordKey] PRIMARY KEY CLUSTERED ([wordN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ix_wordKey_word]
    ON [dbo].[wordKey]([word] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_wordKey_wineNameN]
    ON [dbo].[wordKey]([wineNameN] ASC);

