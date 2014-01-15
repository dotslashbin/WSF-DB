-- ======= Locations ========
--
-- Data Source: RPOWineData.dbo
--
--
USE [RPOWine]
GO
print '--------- delete data --------'
GO
--delete WineProducer
--delete Wine_VinN
delete LocationCountry
delete LocationRegion
delete LocationLocation
delete LocationLocale
delete LocationSite
DBCC CHECKIDENT (LocationCountry, RESEED, 0)
DBCC CHECKIDENT (LocationRegion, RESEED, 0)
DBCC CHECKIDENT (LocationLocation, RESEED, 0)
DBCC CHECKIDENT (LocationLocale, RESEED, 0)
DBCC CHECKIDENT (LocationSite, RESEED, 0)
GO

print '--------- copy data --------'
GO
--------  Country
-- first dummy record for null values
insert into LocationCountry (Name, WF_StatusID) values (N'', 0)
go
insert into LocationCountry (Name, WF_StatusID)
select Country, WF_StatusID = 100
from RPOWineData.dbo.Wine wn
	left join LocationCountry c on wn.Country = c.Name
where wn.Country is not null and LEN(wn.Country) > 0 and c.ID is NULL
group by wn.Country
GO

--------  Region
insert into LocationRegion (Name, WF_StatusID) values (N'', 0)
go
insert into LocationRegion (Name, WF_StatusID)
select wn.Region, WF_StatusID = 100
from RPOWineData.dbo.Wine wn
	left join LocationRegion r on wn.Region = r.Name
where wn.Region is not null and LEN(wn.Region) > 0 and r.ID is NULL
group by wn.Region
GO

----- location
insert into LocationLocation (Name, WF_StatusID) values (N'', 0)
go
insert into LocationLocation (Name, WF_StatusID)
select wn.Location, WF_StatusID = 100
from RPOWineData.dbo.Wine wn
	left join LocationLocation r on wn.Location = r.Name
where wn.Location is not null and LEN(wn.Location) > 0 and r.ID is NULL
group by wn.Location
GO

------ locale
insert into LocationLocale (Name, WF_StatusID) values (N'', 0)
go
insert into LocationLocale (Name, WF_StatusID)
select wn.Locale, WF_StatusID = 100
from RPOWineData.dbo.Wine wn
	left join LocationLocale r on wn.Locale = r.Name
where wn.Locale is not null and LEN(wn.Locale) > 0 and r.ID is NULL
group by wn.Locale
GO

---- site
insert into LocationSite (Name, WF_StatusID) values (N'', 0)
go
insert into LocationSite (Name, WF_StatusID)
select wn.Site, WF_StatusID = 100
from RPOWineData.dbo.Wine wn
	left join LocationSite r on wn.Site = r.Name
where wn.Site is not null and LEN(wn.Site) > 0 and r.ID is NULL
group by wn.Site
GO

print 'Done.'
GO
