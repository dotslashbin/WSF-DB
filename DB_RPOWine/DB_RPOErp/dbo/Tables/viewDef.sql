CREATE TABLE [dbo].[viewDef] (
    [viewN]      INT          NOT NULL,
    [tableName]  VARCHAR (99) NOT NULL,
    [tableOrder] INT          NULL,
    [colName]    VARCHAR (99) NOT NULL,
    [colOrder]   FLOAT (53)   NULL,
    [colAlias]   VARCHAR (99) NULL,
    [isInactive] BIT          NULL,
    [examples]   VARCHAR (99) NULL,
    CONSTRAINT [PK_viewDef] PRIMARY KEY CLUSTERED ([viewN] ASC, [tableName] ASC, [colName] ASC)
);

