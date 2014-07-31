CREATE TABLE [dbo].[pickWhereTasted] (
    [idN]         INT            IDENTITY (1, 1) NOT NULL,
    [displayName] NVARCHAR (100) NULL,
    CONSTRAINT [PK_pickWhereTasted] PRIMARY KEY CLUSTERED ([idN] ASC)
);

