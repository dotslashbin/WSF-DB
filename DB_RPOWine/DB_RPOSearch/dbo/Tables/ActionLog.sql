CREATE TABLE [dbo].[ActionLog] (
    [idN]               INT           IDENTITY (1, 1) NOT NULL,
    [ActionDate]        DATETIME      NULL,
    [ActionDescription] VARCHAR (MAX) NULL,
    [Counter]           BIGINT        NULL,
    CONSTRAINT [PK_ActionHistory] PRIMARY KEY CLUSTERED ([idN] ASC)
);

