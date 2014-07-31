CREATE TABLE [dbo].[TTT] (
    [locationN]       INT            NULL,
    [parentLocationN] INT            NULL,
    [prevItemIndex]   INT            NULL,
    [name]            VARCHAR (200)  NULL,
    [isBottle]        BIT            NULL,
    [path]            VARCHAR (2000) NULL,
    [rooted]          BIT            NULL,
    [iiPrev]          INT            NULL,
    [iiParent]        INT            NULL,
    [iiPath]          VARCHAR (300)  NULL,
    [depth]           INT            NULL,
    [ii]              INT            NULL
);

