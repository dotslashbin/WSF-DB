CREATE TABLE [dbo].[UserRoles] (
    [ID]      INT           IDENTITY (1, 1) NOT NULL,
    [Name]    VARCHAR (30)  NOT NULL,
    [created] SMALLDATETIME CONSTRAINT [DF_UserRoles_created] DEFAULT (getdate()) NOT NULL,
    [updated] SMALLDATETIME NULL,
    CONSTRAINT [PK_UserRoles] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_UserRoles_Uniq]
    ON [dbo].[UserRoles]([Name] ASC);

