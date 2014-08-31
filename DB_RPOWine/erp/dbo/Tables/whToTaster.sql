CREATE TABLE [dbo].[whToTaster] (
    [whN]         INT           NOT NULL,
    [tasterN]     INT           NOT NULL,
    [createDate]  SMALLDATETIME CONSTRAINT [DF_whToTaster_createDate] DEFAULT (getdate()) NULL,
    [rowVerstion] ROWVERSION    NOT NULL,
    CONSTRAINT [PK_whToTaster] PRIMARY KEY CLUSTERED ([whN] ASC, [tasterN] ASC)
);

