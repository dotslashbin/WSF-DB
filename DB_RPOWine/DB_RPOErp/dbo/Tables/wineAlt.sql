CREATE TABLE [dbo].[wineAlt] (
    [idN]                      INT           IDENTITY (1, 1) NOT NULL,
    [wineN]                    INT           NOT NULL,
    [wineNameN]                INT           NULL,
    [isActiveWineNameForWineN] BIT           CONSTRAINT [DF_wineAlt_isActiveWineNameForWineN] DEFAULT ((0)) NOT NULL,
    [vinn]                     INT           NULL,
    [vintage]                  VARCHAR (4)   NULL,
    [dateLo]                   SMALLDATETIME NULL,
    [dateHi]                   SMALLDATETIME NULL,
    [tastingCount]             INT           NULL,
    [rowversion]               ROWVERSION    NULL,
    [isInactive]               BIT           CONSTRAINT [df_wineAlt_isInactive] DEFAULT ((0)) NOT NULL,
    [createDate]               SMALLDATETIME CONSTRAINT [df_wineAlt_createDate] DEFAULT (getdate()) NULL,
    [encodedKeywords]          VARCHAR (MAX) NULL,
    CONSTRAINT [PK_wineAlts] PRIMARY KEY CLUSTERED ([idN] ASC)
);

