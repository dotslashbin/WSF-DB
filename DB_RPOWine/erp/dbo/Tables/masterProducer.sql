CREATE TABLE [dbo].[masterProducer] (
    [masterProducerN] INT            IDENTITY (1, 1) NOT NULL,
    [producer]        NVARCHAR (200) NOT NULL,
    [producerShow]    NVARCHAR (200) NULL,
    CONSTRAINT [PK_masterProducer] PRIMARY KEY CLUSTERED ([masterProducerN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ix_masterProducer_producer]
    ON [dbo].[masterProducer]([producer] ASC);

