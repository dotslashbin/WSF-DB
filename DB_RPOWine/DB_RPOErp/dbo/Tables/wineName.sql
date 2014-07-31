CREATE TABLE [dbo].[wineName] (
    [wineNameN]           INT             IDENTITY (1, 1) NOT NULL,
    [activeVinn]          INT             NULL,
    [namerWhN]            INT             NULL,
    [producer]            NVARCHAR (100)  NOT NULL,
    [producerProfileFile] VARCHAR (500)   NULL,
    [producerShow]        NVARCHAR (100)  NOT NULL,
    [producerURL]         NVARCHAR (500)  NULL,
    [labelName]           NVARCHAR (150)  NULL,
    [colorClass]          NVARCHAR (20)   NULL,
    [variety]             NVARCHAR (100)  NULL,
    [dryness]             NVARCHAR (500)  NULL,
    [wineType]            NVARCHAR (500)  NULL,
    [country]             NVARCHAR (100)  NULL,
    [locale]              NVARCHAR (100)  NULL,
    [location]            NVARCHAR (100)  NULL,
    [region]              NVARCHAR (100)  NULL,
    [site]                NVARCHAR (100)  NULL,
    [places]              NVARCHAR (500)  NULL,
    [encodedKeyWords]     NVARCHAR (2000) NULL,
    [dateLo]              SMALLDATETIME   NULL,
    [dateHi]              SMALLDATETIME   NULL,
    [vintageLo]           VARCHAR (4)     NULL,
    [vintageHi]           VARCHAR (4)     NULL,
    [wineCount]           NCHAR (10)      NULL,
    [joinX]               NVARCHAR (450)  NULL,
    [createDate]          SMALLDATETIME   CONSTRAINT [DF_wineName_createDate] DEFAULT (getdate()) NULL,
    [createWhN]           INT             NULL,
    [updateWhN]           INT             NULL,
    [rowversion]          ROWVERSION      NULL,
    [isInactive]          BIT             CONSTRAINT [df_winename_isInactive] DEFAULT ((0)) NULL,
    [producerUrlN]        INT             NULL,
    [activeDate]          SMALLDATETIME   NULL,
    [stopDate]            SMALLDATETIME   NULL,
    [joinW]               NVARCHAR (500)  NULL,
    [matchName]           NVARCHAR (500)  NULL,
    CONSTRAINT [PK_wineName] PRIMARY KEY CLUSTERED ([wineNameN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ix_winename_producerShow]
    ON [dbo].[wineName]([producerShow] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_winename_labelname]
    ON [dbo].[wineName]([labelName] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_wineName_variety]
    ON [dbo].[wineName]([variety] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_winename_joinx]
    ON [dbo].[wineName]([joinX] ASC);

