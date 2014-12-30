CREATE TABLE [dbo].[WineProducer_WineImporter] (
    [ProducerID] INT           NOT NULL,
    [ImporterID] INT           NOT NULL,
    [created]    SMALLDATETIME CONSTRAINT [DF_WineProducer_WineImporter_created] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_WineProducer_WineImporter] PRIMARY KEY CLUSTERED ([ProducerID] ASC, [ImporterID] ASC),
    CONSTRAINT [FK_WineProducer_Importer_WineImporter] FOREIGN KEY ([ImporterID]) REFERENCES [dbo].[WineImporter] ([ID]),
    CONSTRAINT [FK_WineProducer_Importer_WineProducer] FOREIGN KEY ([ProducerID]) REFERENCES [dbo].[WineProducer] ([ID])
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_WineProducer_Importer]
    ON [dbo].[WineProducer_WineImporter]([ProducerID] ASC, [ImporterID] ASC);

