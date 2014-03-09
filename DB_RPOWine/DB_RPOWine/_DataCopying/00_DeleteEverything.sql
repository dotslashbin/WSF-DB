USE [RPOWine]
GO
print '--------- delete General purpose data --------'
GO
delete Audit
delete Audit_ObjectTypes
delete Audit_EntryUsers
DBCC CHECKIDENT (Audit, RESEED, 1)
DBCC CHECKIDENT (Audit_ObjectTypes, RESEED, 1)
DBCC CHECKIDENT (Audit_EntryUsers, RESEED, 1)
GO
delete WFHist
delete WF
GO
print '--------- delete Publication: Assignment data --------'
GO
delete Assignment_TastingEvent
delete Assignment_TasteNote
delete Assignment_Resource
delete Assignment_ResourceD
delete Assignment_Article
delete Assignment
DBCC CHECKIDENT (Assignment, RESEED, 1)
GO
print '--------- delete Publication: Issue data --------'
GO
--delete Issue_TastingEvent
delete Issue_TasteNote
delete Issue_Article
delete Issue
DBCC CHECKIDENT (Issue, RESEED, 1)
GO
print '--------- delete Publication: TastingEvent data --------'
GO
delete TastingEvent_TasteNote
delete TastingEvent_Article
delete TastingEvent
DBCC CHECKIDENT (TastingEvent, RESEED, 1)
GO
print '--------- delete Publication: TasteNote data --------'
GO
delete Publication_TasteNote
delete TasteNote
DBCC CHECKIDENT (TasteNote, RESEED, 1)
GO
print '--------- delete Publication: Article data --------'
GO
delete Article
DBCC CHECKIDENT (Article, RESEED, 1)
GO
print '--------- delete Publication: Publication data --------'
GO
delete Publication
delete Publisher
DBCC CHECKIDENT (Publication, RESEED, 1)
DBCC CHECKIDENT (Publisher, RESEED, 0)
GO
print '--------- delete Wine data --------'
GO
truncate table Wine_N_Stat
delete Wine_N
delete Wine_VinN
truncate table WineBottleSize
delete WineColor
delete WineDryness
delete WineLabel
delete WineMaturity
delete WineProducer
delete WineType
delete WineVariety
delete WineVintage
DBCC CHECKIDENT (WineColor, RESEED, 0)
DBCC CHECKIDENT (WineDryness, RESEED, 0)
DBCC CHECKIDENT (WineLabel, RESEED, 0)
DBCC CHECKIDENT (WineMaturity, RESEED, 0)
DBCC CHECKIDENT (WineProducer, RESEED, 0)
DBCC CHECKIDENT (WineType, RESEED, 0)
DBCC CHECKIDENT (WineVariety, RESEED, 0)
DBCC CHECKIDENT (WineVintage, RESEED, 0)
DBCC CHECKIDENT (Wine_N, RESEED, 1)
DBCC CHECKIDENT (Wine_VinN, RESEED, 1)
GO
print '--------- delete Location data --------'
GO
delete LocationCountry
delete LocationRegion
delete LocationLocation
delete LocationLocale
delete LocationSite
delete LocationPlaces
DBCC CHECKIDENT (LocationCountry, RESEED, 0)
DBCC CHECKIDENT (LocationRegion, RESEED, 0)
DBCC CHECKIDENT (LocationLocation, RESEED, 0)
DBCC CHECKIDENT (LocationLocale, RESEED, 0)
DBCC CHECKIDENT (LocationSite, RESEED, 0)
DBCC CHECKIDENT (LocationPlaces, RESEED, 0)
GO
print '--------- delete Users data --------'
GO
delete UserRoles
delete Users
DBCC CHECKIDENT (UserRoles, RESEED, 1)
GO
