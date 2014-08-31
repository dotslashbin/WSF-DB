CREATE TABLE [dbo].[articleMaster] (
    [articleN]         INT            IDENTITY (1, 1) NOT NULL,
    [pubN]             INT            NULL,
    [pubDate]          SMALLDATETIME  NULL,
    [issue]            NVARCHAR (50)  NULL,
    [title]            NVARCHAR (500) NULL,
    [shortTitle]       NVARCHAR (500) NULL,
    [authors]          NVARCHAR (500) NULL,
    [pages]            VARCHAR (20)   NULL,
    [tasterN]          INT            NULL,
    [articleId]        INT            NULL,
    [clumpName]        VARCHAR (200)  NULL,
    [isErpArticle]     BIT            CONSTRAINT [DF_article_isErpArticle] DEFAULT ((0)) NOT NULL,
    [_x_articleIdnKey] INT            NULL,
    [joinA]            VARCHAR (1000) NULL,
    CONSTRAINT [PK_articleMaster] PRIMARY KEY CLUSTERED ([articleN] ASC)
);

