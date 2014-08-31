CREATE TABLE [dbo].[mustdrink2] (
    [whN]             INT            NOT NULL,
    [wineN]           INT            NOT NULL,
    [vintage]         VARCHAR (4)    NULL,
    [producerShow]    NVARCHAR (100) NOT NULL,
    [labelName]       NVARCHAR (150) NULL,
    [matchName]       NVARCHAR (500) NULL,
    [bottleCount]     SMALLINT       NULL,
    [proUnifiedN]     SMALLINT       NULL,
    [userUnifiedN]    SMALLINT       NULL,
    [trustedUnifiedN] SMALLINT       NULL
);


GO
CREATE NONCLUSTERED INDEX [pk_mustDrink2_whNwineN]
    ON [dbo].[mustdrink2]([whN] ASC, [wineN] ASC);

