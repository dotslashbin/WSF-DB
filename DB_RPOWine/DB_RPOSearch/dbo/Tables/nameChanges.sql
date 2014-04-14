CREATE TABLE [dbo].[nameChanges] (
    [ChangeCnt]    INT           NULL,
    [producerShow] VARCHAR (255) NULL,
    [labelName]    VARCHAR (255) NULL,
    [colorClass]   VARCHAR (50)  NULL,
    [inOld]        BIT           NOT NULL,
    [inNew]        BIT           NOT NULL,
    [Wid]          NCHAR (20)    NULL,
    [errors]       VARCHAR (MAX) NULL,
    [warnings]     VARCHAR (MAX) NULL,
    [idN]          INT           IDENTITY (1, 1) NOT NULL
);

