CREATE TABLE [dbo].[toc] (
    [tocN]         INT           IDENTITY (1, 1) NOT NULL,
    [pubN]         INT           NULL,
    [issue]        VARCHAR (20)  NULL,
    [title]        VARCHAR (200) NULL,
    [isOverlapOK]  BIT           NULL,
    [articleOrder] INT           NULL,
    [createDate]   SMALLDATETIME CONSTRAINT [df_toc_createDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [pk_toc] PRIMARY KEY CLUSTERED ([tocN] ASC)
);

