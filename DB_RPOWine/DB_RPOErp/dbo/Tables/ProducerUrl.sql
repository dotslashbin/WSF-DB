CREATE TABLE [dbo].[ProducerUrl] (
    [idN]          INT            NOT NULL,
    [producer]     NVARCHAR (MAX) NOT NULL,
    [producerShow] NVARCHAR (MAX) NULL,
    [priorURL]     NVARCHAR (MAX) NULL,
    [currentURL]   NVARCHAR (MAX) NULL,
    [newURL]       NVARCHAR (MAX) NULL,
    [hasTasting]   BIT            NOT NULL,
    [updateDate]   DATETIME       NULL
);

