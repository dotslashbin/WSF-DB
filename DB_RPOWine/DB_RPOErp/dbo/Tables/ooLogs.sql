CREATE TABLE [dbo].[ooLogs] (
    [msg]        NVARCHAR (MAX) NULL,
    [timeOf]     DATETIME       NULL,
    [rowVersion] ROWVERSION     NOT NULL
);

