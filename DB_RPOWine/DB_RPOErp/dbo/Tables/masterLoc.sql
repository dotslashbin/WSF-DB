CREATE TABLE [dbo].[masterLoc] (
    [masterLocN]       INT            IDENTITY (1, 1) NOT NULL,
    [loc]              NVARCHAR (200) NOT NULL,
    [country]          NVARCHAR (200) NULL,
    [region]           NVARCHAR (200) NULL,
    [location]         NVARCHAR (200) NULL,
    [SubLocation]      NVARCHAR (200) NULL,
    [DetailedLocation] NVARCHAR (200) NULL,
    [keywords]         NVARCHAR (999) NULL,
    CONSTRAINT [PK_masterLoc] PRIMARY KEY CLUSTERED ([masterLocN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ix_masterLoc_country]
    ON [dbo].[masterLoc]([country] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_masterLoc_region]
    ON [dbo].[masterLoc]([region] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_masterLoc_location]
    ON [dbo].[masterLoc]([location] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_masterLoc_subLocation]
    ON [dbo].[masterLoc]([SubLocation] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_masterLoc_detailedLocation]
    ON [dbo].[masterLoc]([DetailedLocation] ASC);

