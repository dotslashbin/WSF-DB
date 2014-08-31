CREATE TABLE [dbo].[priceGToSeller] (
    [priceGN]    INT        NOT NULL,
    [sellerN]    INT        NOT NULL,
    [rowversion] ROWVERSION NULL,
    [isDerived]  BIT        CONSTRAINT [df_mapPriceGToWh_isDerived] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_mapPriceGroupToWh] PRIMARY KEY CLUSTERED ([priceGN] ASC, [sellerN] ASC)
);

