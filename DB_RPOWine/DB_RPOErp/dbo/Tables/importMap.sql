CREATE TABLE [dbo].[importMap] (
    [idN]          INT            IDENTITY (1, 1) NOT NULL,
    [whN]          INT            NULL,
    [myVintage]    NVARCHAR (4)   NULL,
    [myWineName]   NVARCHAR (500) NULL,
    [erpVintage]   NVARCHAR (4)   NULL,
    [erpWineName]  NVARCHAR (500) NULL,
    [wineN]        INT            NULL,
    [alreadyThere] BIT            NULL,
    [isOld]        BIT            NULL,
    CONSTRAINT [PK_importMap] PRIMARY KEY CLUSTERED ([idN] ASC)
);

