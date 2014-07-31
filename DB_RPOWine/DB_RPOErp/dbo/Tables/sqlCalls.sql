CREATE TABLE [dbo].[sqlCalls] (
    [idN]         INT             IDENTITY (1, 1) NOT NULL,
    [dateCreated] DATETIME        NULL,
    [args]        NVARCHAR (3000) NULL,
    CONSTRAINT [PK_sqlCalls] PRIMARY KEY CLUSTERED ([idN] ASC)
);

