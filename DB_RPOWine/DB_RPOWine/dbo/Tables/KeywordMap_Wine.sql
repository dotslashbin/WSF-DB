CREATE TABLE [dbo].[KeywordMap_Wine] (
    [Source]      NVARCHAR (120) NOT NULL,
    [Destination] NVARCHAR (240) NOT NULL,
    CONSTRAINT [PK_KeywordMap_Wine] PRIMARY KEY CLUSTERED ([Source] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_KeywordMap_Wine_Uniq]
    ON [dbo].[KeywordMap_Wine]([Source] ASC)
    INCLUDE([Destination]);

