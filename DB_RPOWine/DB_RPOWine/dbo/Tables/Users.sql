CREATE TABLE [dbo].[Users] (
    [UserId]      INT            NOT NULL,
    [UserName]    NVARCHAR (120) NOT NULL,
    [FirstName]   NVARCHAR (50)  CONSTRAINT [DF_User_FirstName] DEFAULT ('') NULL,
    [LastName]    NVARCHAR (50)  CONSTRAINT [DF_User_LastName] DEFAULT ('') NULL,
    [IsAvailable] SMALLINT       NOT NULL,
    [created]     SMALLDATETIME  CONSTRAINT [DF_User_created] DEFAULT (getdate()) NOT NULL,
    [updated]     SMALLDATETIME  NULL,
    [FullName]    AS             (ltrim(rtrim((rtrim(isnull([FirstName],''))+' ')+ltrim(isnull([LastName],''))))),
    [UserIdProd]  INT            NULL,
    CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED ([UserId] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_Users_IsAvailable]
    ON [dbo].[Users]([IsAvailable] ASC, [FullName] ASC)
    INCLUDE([UserId], [UserName]);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_User_Uniq]
    ON [dbo].[Users]([UserName] ASC)
    INCLUDE([UserId], [IsAvailable]);

