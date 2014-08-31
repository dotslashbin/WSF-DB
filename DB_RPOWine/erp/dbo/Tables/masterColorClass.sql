CREATE TABLE [dbo].[masterColorClass] (
    [ColorClassN] INT            IDENTITY (1, 1) NOT NULL,
    [ColorClass]  NVARCHAR (255) NULL,
    CONSTRAINT [PK_masterColorClass] PRIMARY KEY CLUSTERED ([ColorClassN] ASC)
);

