CREATE TABLE [dbo].[whToAcceptablePurchaser] (
    [whN]        INT           NULL,
    [purchaserN] INT           NULL,
    [rowversion] ROWVERSION    NULL,
    [isDerived]  BIT           CONSTRAINT [df_mapWhToAcceptablePurchaser_isDerived] DEFAULT ((0)) NULL,
    [createDate] SMALLDATETIME CONSTRAINT [DF_whToAcceptablePurchaser_createDate] DEFAULT (getdate()) NULL
);

