CREATE TABLE [dbo].[whToTrustedPub] (
    [whN]        INT           NOT NULL,
    [pubN]       INT           NOT NULL,
    [isDerived]  BIT           CONSTRAINT [DF_whToTrustedPub_isDerived] DEFAULT ((0)) NOT NULL,
    [createDate] SMALLDATETIME CONSTRAINT [DF_whToTrustedPub_dateCreated] DEFAULT (getdate()) NULL,
    [rowVersion] ROWVERSION    NULL,
    [handle]     INT           NULL,
    CONSTRAINT [PK_whToTrustedPub] PRIMARY KEY CLUSTERED ([whN] ASC, [pubN] ASC)
);

