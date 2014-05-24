CREATE FULLTEXT INDEX ON [dbo].[vWineVinNDetails]
    ([Country] LANGUAGE 1033, [Region] LANGUAGE 1033, [Location] LANGUAGE 1033, [Locale] LANGUAGE 1033, [Site] LANGUAGE 1033, [Appellation] LANGUAGE 1033, [Producer] LANGUAGE 1033, [ProducerToShow] LANGUAGE 1033, [Type] LANGUAGE 1033, [Label] LANGUAGE 1033, [Variety] LANGUAGE 1033, [Dryness] LANGUAGE 1033, [Color] LANGUAGE 1033, [Name] LANGUAGE 1033)
    KEY INDEX [PK_vWineVinNDetails]
    ON ([RPOWine_FTSearchVin], FILEGROUP [WineIndx])
    WITH STOPLIST OFF;






GO
CREATE FULLTEXT INDEX ON [dbo].[Wine]
    ([ColorClass] LANGUAGE 1033, [Country] LANGUAGE 1033, [Dryness] LANGUAGE 1033, [encodedKeyWords] LANGUAGE 1033, [Issue] LANGUAGE 1033, [LabelName] LANGUAGE 1033, [Location] LANGUAGE 1033, [Locale] LANGUAGE 1033, [Notes] LANGUAGE 1033, [Producer] LANGUAGE 1033, [ProducerShow] LANGUAGE 1033, [Publication] LANGUAGE 1033, [Places] LANGUAGE 1033, [Region] LANGUAGE 1033, [RatingShow] LANGUAGE 1033, [source] LANGUAGE 1033, [Site] LANGUAGE 1033, [Vintage] LANGUAGE 1033, [Variety] LANGUAGE 1033, [WineType] LANGUAGE 1033)
    KEY INDEX [PK_Wine]
    ON [RPOWine_WineOld];

