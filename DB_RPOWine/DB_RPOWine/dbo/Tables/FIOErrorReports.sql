CREATE TABLE [dbo].[FIOErrorReports] (
    [id]                INT      IDENTITY (1, 1) NOT NULL,
    [WineN]             INT      NOT NULL,
    [ErrorReport]       NTEXT    NOT NULL,
    [ReportCreatedDate] DATETIME NOT NULL,
    [ErrorFixedDate]    DATETIME NULL,
    [IdN]               INT      NOT NULL
);

