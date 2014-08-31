CREATE FULLTEXT INDEX ON [dbo].[tasting]
    ([notes] LANGUAGE 1033)
    KEY INDEX [PK_Tasting]
    ON [erpFullText]
    WITH STOPLIST [MWStopListEmpty];


GO
CREATE FULLTEXT INDEX ON [dbo].[wine]
    ([encodedKeywords] LANGUAGE 1033)
    KEY INDEX [PK_wine]
    ON [erpFullText]
    WITH STOPLIST [MWStopListEmpty];


GO
CREATE FULLTEXT INDEX ON [dbo].[wineName]
    ([producer] LANGUAGE 1033, [producerShow] LANGUAGE 1033, [labelName] LANGUAGE 1033, [variety] LANGUAGE 1033, [encodedKeyWords] LANGUAGE 1033)
    KEY INDEX [PK_wineName]
    ON [erpFullText];


GO
CREATE FULLTEXT INDEX ON [dbo].[masterLoc]
    ([loc] LANGUAGE 1033, [country] LANGUAGE 1033, [region] LANGUAGE 1033, [location] LANGUAGE 1033, [SubLocation] LANGUAGE 1033, [DetailedLocation] LANGUAGE 1033, [keywords] LANGUAGE 1033)
    KEY INDEX [PK_masterLoc]
    ON [erpFullText];


GO
CREATE FULLTEXT INDEX ON [dbo].[masterVariety]
    ([variety] LANGUAGE 1033)
    KEY INDEX [PK_masterVariety]
    ON [erpFullText];


GO
CREATE FULLTEXT INDEX ON [dbo].[masterLocProducer]
    ([loc] LANGUAGE 1033, [producer] LANGUAGE 1033, [producerShow] LANGUAGE 1033, [country] LANGUAGE 1033, [region] LANGUAGE 1033, [location] LANGUAGE 1033, [SubLocation] LANGUAGE 1033, [DetailedLocation] LANGUAGE 1033, [keywords] LANGUAGE 1033)
    KEY INDEX [PK_masterLocProducer]
    ON [erpFullText];


GO
CREATE FULLTEXT INDEX ON [dbo].[masterProducer]
    ([producer] LANGUAGE 1033, [producerShow] LANGUAGE 1033)
    KEY INDEX [PK_masterProducer]
    ON [erpFullText];


GO
CREATE FULLTEXT INDEX ON [dbo].[wordKey]
    ([word] LANGUAGE 1033, [keywords] LANGUAGE 1033)
    KEY INDEX [PK_wordKey]
    ON [erpFullText]
    WITH STOPLIST [MWStopListEmpty];


GO
CREATE FULLTEXT INDEX ON [dbo].[masterColorClass]
    ([ColorClass] LANGUAGE 1033)
    KEY INDEX [PK_masterColorClass]
    ON [erpFullText];


GO
CREATE FULLTEXT INDEX ON [dbo].[wh]
    ([displayName] LANGUAGE 1033, [email] LANGUAGE 1033, [userName] LANGUAGE 1033)
    KEY INDEX [PK_who]
    ON [erpTasterSearch]
    WITH STOPLIST [MWStopListEmpty];

