CREATE FULLTEXT INDEX ON [dbo].[vWineVinNDetails]
    ([Country] LANGUAGE 1033, [Region] LANGUAGE 1033, [Location] LANGUAGE 1033, [Locale] LANGUAGE 1033, [Site] LANGUAGE 1033, [Appellation] LANGUAGE 1033, [Producer] LANGUAGE 1033, [ProducerToShow] LANGUAGE 1033, [Type] LANGUAGE 1033, [Label] LANGUAGE 1033, [Variety] LANGUAGE 1033, [Dryness] LANGUAGE 1033, [Color] LANGUAGE 1033)
    KEY INDEX [PK_vWineVinNDetails]
    ON ([RPOWine_FTSearchVin], FILEGROUP [WineIndx])
    WITH STOPLIST OFF;

