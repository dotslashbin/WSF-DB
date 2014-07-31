CREATE TABLE [dbo].[allocateWidVinn] (
    [wid]    VARCHAR (30) NOT NULL,
    [vinn]   INT          NOT NULL,
    [isAuto] BIT          NULL,
    CONSTRAINT [PK_allocateWidVinn] PRIMARY KEY CLUSTERED ([wid] ASC)
);

