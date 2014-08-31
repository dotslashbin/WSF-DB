CREATE TABLE [dbo].[tocSignature] (
    [tocN]       INT            NULL,
    [pubN]       INT            NULL,
    [issue]      NVARCHAR (50)  NULL,
    [pages]      NVARCHAR (50)  NULL,
    [source]     NVARCHAR (255) NULL,
    [sourceDate] DATETIME       NULL,
    [country]    NVARCHAR (255) NULL,
    [region]     NVARCHAR (255) NULL,
    [location]   NVARCHAR (255) NULL,
    [clumpName]  VARCHAR (255)  NULL,
    [articleId]  INT            NULL,
    [Cnt]        INT            NULL,
    [createDate] SMALLDATETIME  CONSTRAINT [df_tocSignature_createDate] DEFAULT (getdate()) NULL
);

