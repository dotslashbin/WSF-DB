CREATE TABLE [dbo].[whToAcceptableSeller] (
    [whN]        INT           NULL,
    [sellerN]    INT           NULL,
    [rowversion] ROWVERSION    NULL,
    [isDerived]  BIT           CONSTRAINT [df_mapWhToAcceptableSeller_isDerived] DEFAULT ((0)) NULL,
    [createDate] SMALLDATETIME CONSTRAINT [DF_whToAcceptableSeller_createDate] DEFAULT (getdate()) NULL
);

