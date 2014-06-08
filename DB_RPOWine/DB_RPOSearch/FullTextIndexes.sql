CREATE FULLTEXT INDEX ON [dbo].[Wine]
    ([Vintage] LANGUAGE 1033, [Variety] LANGUAGE 1033, [LabelName] LANGUAGE 1033, [Producer] LANGUAGE 1033, [ProducerShow] LANGUAGE 1033, [RatingShow] LANGUAGE 1033, [Country] LANGUAGE 1033, [Region] LANGUAGE 1033, [Location] LANGUAGE 1033, [Dryness] LANGUAGE 1033, [ColorClass] LANGUAGE 1033, [WineType] LANGUAGE 1033, [Source] LANGUAGE 1033, [Publication] LANGUAGE 1033, [Issue] LANGUAGE 1033, [BottleSize] LANGUAGE 1033, [Notes] LANGUAGE 1033, [encodedKeyWords] LANGUAGE 1033, [Locale] LANGUAGE 1033, [Site] LANGUAGE 1033, [CombinedLocation] LANGUAGE 1033, [Places] LANGUAGE 1033, [ShortLabelName] LANGUAGE 1033, [DisabledFlag] LANGUAGE 1033)
    KEY INDEX [PK_Wine]
    ON ([RPOSearch_FTSearch], FILEGROUP [FTSearch])
    WITH STOPLIST OFF;


GO
ALTER FULLTEXT INDEX ON [dbo].[Wine] DISABLE;




GO
CREATE FULLTEXT INDEX ON [dbo].[WineName]
    ([ProducerShow] LANGUAGE 1033, [LabelName] LANGUAGE 1033, [EncodedKeywords] LANGUAGE 1033)
    KEY INDEX [PK_WineName]
    ON ([RPOSearch_FTSearch], FILEGROUP [FTSearch])
    WITH STOPLIST OFF;


GO
ALTER FULLTEXT INDEX ON [dbo].[WineName] DISABLE;




GO
CREATE FULLTEXT INDEX ON [dbo].[ForSaleDetail]
    ([Vintage] LANGUAGE 1033, [BottleSize] LANGUAGE 1033, [Currency] LANGUAGE 1033, [TaxNotes] LANGUAGE 1033, [URL] LANGUAGE 1033, [RetailerDescriptionOfWine] LANGUAGE 1033, [RetailerIdN] LANGUAGE 1033, [RetailerCode] LANGUAGE 1033, [RetailerName] LANGUAGE 1033, [Country] LANGUAGE 1033, [State] LANGUAGE 1033, [City] LANGUAGE 1033, [Errors] LANGUAGE 1033)
    KEY INDEX [PK_ForSaleDetail]
    ON ([RPOSearch_FTSearch], FILEGROUP [FTSearch])
    WITH STOPLIST OFF;


GO
ALTER FULLTEXT INDEX ON [dbo].[ForSaleDetail] DISABLE;



