CREATE TABLE [dbo].[icon] (
    [iconN]       INT            IDENTITY (1, 1) NOT NULL,
    [whN]         INT            NULL,
    [sortName]    NVARCHAR (200) NULL,
    [displayName] NVARCHAR (200) NULL,
    [shortName]   NVARCHAR (50)  NULL,
    [tag]         NVARCHAR (50)  NULL,
    [createWhN]   INT            NULL,
    [createDate]  SMALLDATETIME  CONSTRAINT [DF_icon_createDate] DEFAULT (getdate()) NULL,
    [updateWhN]   INT            NULL,
    [comments]    VARCHAR (MAX)  NULL,
    [rowVersion]  ROWVERSION     NULL,
    [isInactive]  BIT            CONSTRAINT [df_icon_isInactive] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_icon] PRIMARY KEY CLUSTERED ([iconN] ASC)
);

