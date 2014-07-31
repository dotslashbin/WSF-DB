CREATE TABLE [dbo].[whToTasting] (
    [whN]       INT NOT NULL,
    [tastingN]  INT NOT NULL,
    [isDerived] BIT CONSTRAINT [df_mapWhToTasting_isDerived] DEFAULT ((0)) NULL,
    CONSTRAINT [pk_mapWhToTasting] PRIMARY KEY CLUSTERED ([whN] ASC, [tastingN] ASC)
);

