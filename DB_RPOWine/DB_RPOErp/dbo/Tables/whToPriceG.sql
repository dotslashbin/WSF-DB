CREATE TABLE [dbo].[whToPriceG] (
    [whN]        INT        NULL,
    [priceGN]    INT        NULL,
    [rowversion] ROWVERSION NULL,
    [isDerived]  BIT        CONSTRAINT [df_mapWhToPriceGroup_isDerived] DEFAULT ((0)) NULL
);

