CREATE TABLE [dbo].[whToTrustedTaster] (
    [whN]        INT           NOT NULL,
    [tasterN]    INT           NOT NULL,
    [isDerived]  INT           CONSTRAINT [DF_whToTrustedTaster_isDerived] DEFAULT ((0)) NOT NULL,
    [createDate] SMALLDATETIME CONSTRAINT [DF_whToTrustedTaster_dateCreated] DEFAULT (getdate()) NULL,
    [rowVersion] ROWVERSION    NULL,
    [handle]     INT           NULL,
    CONSTRAINT [PK_whToTrustedTaster] PRIMARY KEY CLUSTERED ([whN] ASC, [tasterN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ix_whToTrustedTaster_tasterN]
    ON [dbo].[whToTrustedTaster]([tasterN] ASC, [whN] ASC);

