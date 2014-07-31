CREATE TABLE [dbo].[masterVariety] (
    [varietyN]   INT            IDENTITY (1, 1) NOT NULL,
    [variety]    NVARCHAR (255) NULL,
    [isPending]  BIT            NULL,
    [isCommon]   BIT            NULL,
    [colorClass] NVARCHAR (20)  NULL,
    CONSTRAINT [PK_masterVariety] PRIMARY KEY CLUSTERED ([varietyN] ASC)
);

