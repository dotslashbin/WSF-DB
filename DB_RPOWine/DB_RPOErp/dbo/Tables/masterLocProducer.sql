CREATE TABLE [dbo].[masterLocProducer] (
    [masterLocProducerN] INT            IDENTITY (1, 1) NOT NULL,
    [loc]                NVARCHAR (200) NULL,
    [producer]           NVARCHAR (200) NOT NULL,
    [producerShow]       NVARCHAR (200) NULL,
    [country]            NVARCHAR (200) NULL,
    [region]             NVARCHAR (200) NULL,
    [location]           NVARCHAR (200) NULL,
    [SubLocation]        NVARCHAR (200) NULL,
    [DetailedLocation]   NVARCHAR (200) NULL,
    [keywords]           NVARCHAR (999) NULL,
    CONSTRAINT [PK_masterLocProducer] PRIMARY KEY CLUSTERED ([masterLocProducerN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ix_masterLocProducer_producer]
    ON [dbo].[masterLocProducer]([producer] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_masterLocProducer_country]
    ON [dbo].[masterLocProducer]([country] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_masterLocProducer_region]
    ON [dbo].[masterLocProducer]([region] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_masterLocProducer_location]
    ON [dbo].[masterLocProducer]([location] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_masterLocProducer_subLocation]
    ON [dbo].[masterLocProducer]([SubLocation] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_masterLocProducer_detailedLocation]
    ON [dbo].[masterLocProducer]([DetailedLocation] ASC);

