CREATE TABLE [dbo].[idUse] (
    [idN]               INT           NOT NULL,
    [wid]               VARCHAR (30)  NULL,
    [vinN]              INT           NULL,
    [wineN]             INT           NULL,
    [wineNameN]         INT           NULL,
    [vintage]           VARCHAR (4)   NULL,
    [dateLo]            SMALLDATETIME NULL,
    [dateHi]            SMALLDATETIME NULL,
    [isLive]            BIT           NULL,
    [isWineNameVS]      BIT           NULL,
    [isPriorWineNameVS] BIT           NULL,
    [VSDateLo]          SMALLDATETIME NULL,
    [VSDateActive]      SMALLDATETIME NULL,
    [VSDateHi]          SMALLDATETIME NULL
);

