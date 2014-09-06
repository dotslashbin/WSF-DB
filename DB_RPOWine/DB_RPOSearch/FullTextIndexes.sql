


GO





GO
CREATE FULLTEXT INDEX ON [dbo].[WineName]
    ([ProducerShow] LANGUAGE 1033, [LabelName] LANGUAGE 1033, [EncodedKeywords] LANGUAGE 1033)
    KEY INDEX [PK_WineName]
    ON ([RPOSearch_FTSearch], FILEGROUP [FTSearch])
    WITH STOPLIST OFF;




GO





GO
CREATE FULLTEXT INDEX ON [dbo].[ForSaleDetail]
    ([RetailerDescriptionOfWine] LANGUAGE 1033)
    KEY INDEX [PK_ForSaleDetail]
    ON [RPOSearch_FTSearch];




GO




