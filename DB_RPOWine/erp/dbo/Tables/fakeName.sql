CREATE TABLE [dbo].[fakeName] (
    [nameN]  INT          IDENTITY (1, 1) NOT NULL,
    [first]  VARCHAR (99) NULL,
    [last]   VARCHAR (99) NULL,
    [isUsed] BIT          NULL,
    CONSTRAINT [PK_fakeName] PRIMARY KEY CLUSTERED ([nameN] ASC)
);

