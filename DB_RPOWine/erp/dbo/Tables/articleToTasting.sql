CREATE TABLE [dbo].[articleToTasting] (
    [articleN]   INT        NOT NULL,
    [tastingN]   INT        NOT NULL,
    [rowversion] ROWVERSION NULL,
    [isDerived]  BIT        CONSTRAINT [df_mapArticleToWine_isDerived] DEFAULT ((0)) NULL,
    CONSTRAINT [pk_articleToWine] PRIMARY KEY CLUSTERED ([articleN] ASC, [tastingN] ASC)
);

