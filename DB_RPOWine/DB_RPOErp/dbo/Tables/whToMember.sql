CREATE TABLE [dbo].[whToMember] (
    [whN]         INT           NOT NULL,
    [MemberN]     INT           NOT NULL,
    [createDate]  SMALLDATETIME CONSTRAINT [DF_whToMember_createDate] DEFAULT (getdate()) NULL,
    [rowVerstion] ROWVERSION    NOT NULL,
    CONSTRAINT [PK_whToMember] PRIMARY KEY CLUSTERED ([whN] ASC, [MemberN] ASC)
);

