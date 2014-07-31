CREATE TABLE [dbo].[whToTrusted] (
    [whN]        INT           NULL,
    [trustedN]   INT           NULL,
    [isDerived]  BIT           NULL,
    [rowversion] ROWVERSION    NOT NULL,
    [createDate] SMALLDATETIME CONSTRAINT [DF_whToTrusted_createDate] DEFAULT (getdate()) NULL
);

