CREATE TABLE [dbo].[rowVersionHistory] (
    [xRowVersion] BIGINT   NOT NULL,
    [whN]         INT      NOT NULL,
    [whFinish]    INT      CONSTRAINT [df_rowVersionHistory_whFInish] DEFAULT ((0)) NOT NULL,
    [xDateTime]   DATETIME NOT NULL,
    CONSTRAINT [PK_xRowVersion] PRIMARY KEY CLUSTERED ([xRowVersion] ASC, [whN] ASC, [whFinish] ASC)
);

