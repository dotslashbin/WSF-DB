-- ======= Locations ========
--
-- Data Source: RPOWineDataD.dbo, ArticlesParser.dbo
--
--
USE [RPOWine]
GO

print '--------- copy data --------'
GO
--------  Country
-- first dummy record for null values
set identity_insert LocationCountry on
insert into LocationCountry (ID, Name, WF_StatusID) values (0, N'', 0)
set identity_insert LocationCountry off
go
insert into LocationCountry (Name, WF_StatusID)
select Country, WF_StatusID = 100
from RPOWineDataD.dbo.Wine wn
	left join LocationCountry c on wn.Country = c.Name
where wn.Country is not null and LEN(wn.Country) > 0 and c.ID is NULL
group by wn.Country
GO

--------  Region
set identity_insert LocationRegion on
insert into LocationRegion (ID, Name, WF_StatusID) values (0, N'', 0)
set identity_insert LocationRegion off
go
insert into LocationRegion (Name, WF_StatusID)
select wn.Region, WF_StatusID = 100
from RPOWineDataD.dbo.Wine wn
	left join LocationRegion r on wn.Region = r.Name
where wn.Region is not null and LEN(wn.Region) > 0 and r.ID is NULL
group by wn.Region
GO

----- location
set identity_insert LocationLocation on
insert into LocationLocation (ID, Name, WF_StatusID) values (0, N'', 0)
set identity_insert LocationLocation off
go
insert into LocationLocation (Name, WF_StatusID)
select wn.Location, WF_StatusID = 100
from RPOWineDataD.dbo.Wine wn
	left join LocationLocation r on wn.Location = r.Name
where wn.Location is not null and LEN(wn.Location) > 0 and r.ID is NULL
group by wn.Location
GO

------ locale
set identity_insert LocationLocale on
insert into LocationLocale (ID, Name, WF_StatusID) values (0, N'', 0)
set identity_insert LocationLocale off
go
insert into LocationLocale (Name, WF_StatusID)
select wn.Locale, WF_StatusID = 100
from RPOWineDataD.dbo.Wine wn
	left join LocationLocale r on wn.Locale = r.Name
where wn.Locale is not null and LEN(wn.Locale) > 0 and r.ID is NULL
group by wn.Locale
GO

---- site
set identity_insert LocationSite on
insert into LocationSite (ID, Name, WF_StatusID) values (0, N'', 0)
set identity_insert LocationSite off
go
insert into LocationSite (Name, WF_StatusID)
select wn.Site, WF_StatusID = 100
from RPOWineDataD.dbo.Wine wn
	left join LocationSite r on wn.Site = r.Name
where wn.Site is not null and LEN(wn.Site) > 0 and r.ID is NULL
group by wn.Site
GO

---- places
set identity_insert LocationPlaces on
insert into LocationPlaces (ID, Name, WF_StatusID) values (0, N'', 0)
set identity_insert LocationPlaces off
go
insert into LocationPlaces (Name, WF_StatusID)
select wn.Places, WF_StatusID = 100
from RPOWineDataD.dbo.Wine wn
	left join LocationPlaces r on wn.Site = r.Name
where wn.Places is not null and LEN(wn.Places) > 0 and r.ID is NULL
group by wn.Places
GO

-------- State
set identity_insert LocationState on
insert into LocationState (ID, Name, WF_StatusID) values (0, N'', 0)
set identity_insert LocationState off
go
insert into LocationState (Name, WF_StatusID)
select a.State, WF_StatusID = 100
from ArticleParser.dbo.Articles a
	left join LocationState c on a.State = c.Name
where a.State is not null and LEN(a.State) > 0 and c.ID is NULL
	and a.State != 'xxxx' and a.State not like 'Maryland>%'
group by a.State
GO

-------- City
set identity_insert LocationCity on
insert into LocationCity (ID, Name, WF_StatusID) values (0, N'', 0)
set identity_insert LocationCity off
go
insert into LocationCity (Name, WF_StatusID)
select rtrim(ltrim(a.City)), WF_StatusID = 100
from ArticleParser.dbo.Articles a
	left join LocationCity c on a.City = c.Name
where a.City is not null and LEN(a.City) > 0 and c.ID is NULL
	and a.City != 'xxxx' 
group by rtrim(ltrim(a.City))
GO


print 'Done.'
GO
