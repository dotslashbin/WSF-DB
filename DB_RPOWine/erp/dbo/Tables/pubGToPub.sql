CREATE TABLE [dbo].[pubGToPub] (
    [pubGN]      INT           NOT NULL,
    [pubN]       INT           NOT NULL,
    [isDerived]  BIT           CONSTRAINT [DF_pubGToPub_isDerived] DEFAULT ((0)) NOT NULL,
    [rowVersion] ROWVERSION    NULL,
    [createDate] SMALLDATETIME CONSTRAINT [DF_pubGToPub_createDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_pubGToPub] PRIMARY KEY CLUSTERED ([pubGN] ASC, [pubN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ix_pubGToPub_pubN]
    ON [dbo].[pubGToPub]([pubN] ASC, [pubGN] ASC);

