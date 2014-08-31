CREATE TABLE [dbo].[whToGroup] (
    [whN]         INT           NOT NULL,
    [GroupN]      INT           NOT NULL,
    [createDate]  SMALLDATETIME CONSTRAINT [DF_whToGroup_createDate] DEFAULT (getdate()) NULL,
    [rowVerstion] ROWVERSION    NOT NULL,
    CONSTRAINT [PK_whToGroup] PRIMARY KEY CLUSTERED ([whN] ASC, [GroupN] ASC)
);

