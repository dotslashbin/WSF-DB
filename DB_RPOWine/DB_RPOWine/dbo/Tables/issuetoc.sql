﻿CREATE TABLE [dbo].[issuetoc] (
    [issueTocN]     INT            IDENTITY (1, 1) NOT NULL,
    [issue]         NVARCHAR (MAX) NULL,
    [articleIdnKey] INT            NULL,
    [title]         NVARCHAR (MAX) NULL,
    [source]        NVARCHAR (MAX) NULL,
    [cntProducer]   INT            NULL,
    [cntWine]       INT            NULL
);



