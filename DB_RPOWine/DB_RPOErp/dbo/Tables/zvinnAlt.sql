CREATE TABLE [dbo].[zvinnAlt] (
    [idN]                 INT           IDENTITY (1, 1) NOT NULL,
    [vinn]                INT           NULL,
    [isActiveNameForVinn] BIT           CONSTRAINT [DF_vinnAlt_isActiveNameForVinn] DEFAULT ((0)) NOT NULL,
    [isActiveVinnForName] BIT           CONSTRAINT [DF_vinnAlt_isActiveVinnForName] DEFAULT ((0)) NOT NULL,
    [wineNameN]           INT           NULL,
    [dateLo]              SMALLDATETIME NULL,
    [dateHi]              SMALLDATETIME NULL,
    [vintageLo]           VARCHAR (4)   NULL,
    [vintageHi]           VARCHAR (4)   NULL,
    [tastingCount]        INT           NULL,
    [rowversion]          ROWVERSION    NULL,
    [isInactive]          BIT           CONSTRAINT [df_vinnAlt_isInactive] DEFAULT ((0)) NOT NULL,
    [createDate]          SMALLDATETIME CONSTRAINT [df_vinnAlt_createDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_vinnAlts] PRIMARY KEY CLUSTERED ([idN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ActiveVinn]
    ON [dbo].[zvinnAlt]([vinn] ASC, [isActiveNameForVinn] ASC)
    INCLUDE([wineNameN]);

