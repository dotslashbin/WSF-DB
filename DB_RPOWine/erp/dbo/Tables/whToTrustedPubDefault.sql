CREATE TABLE [dbo].[whToTrustedPubDefault] (
    [whN]        INT           NOT NULL,
    [pubN]       INT           NOT NULL,
    [isDerived]  BIT           NOT NULL,
    [rowVersion] ROWVERSION    NOT NULL,
    [createDate] SMALLDATETIME NULL
);

