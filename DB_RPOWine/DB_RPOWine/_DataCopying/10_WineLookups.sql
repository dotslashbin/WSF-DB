-- ======= Wine Types ========
--
-- Data Source: RPOWineData.dbo
--
--
USE [RPOWine]
GO
print '--------- copy data --------'
GO
-------- WineMaturity
begin tran
	set identity_insert WineMaturity on
	insert into WineMaturity (ID, Name, Suggestion)
	values (-1, 'N/A', 'N/A'), (0, 'Young', 'Young'),
		(1, 'Early', 'Ready'), (2, 'Mature', 'Ready'), (3, 'Late', 'Ready'),
		(4, 'Old', 'Old'), (5, '', '')
	set identity_insert WineMaturity off
commit tran
GO

-------- WineTypes
set identity_insert WineType on
insert into WineType (ID, Name, WF_StatusID) values (0, N'', 0)
set identity_insert WineType off
go
insert into WineType (Name, WF_StatusID)
select wn.WineType, WF_StatusID = 100
from RPOWineData.dbo.Wine wn
	left join WineType c on wn.WineType = c.Name
where wn.WineType is not null and LEN(wn.WineType) > 0 and c.ID is NULL
group by wn.WineType
GO

----------- WineLabel
set identity_insert WineLabel on
insert into WineLabel (ID, Name, WF_StatusID) values (0, N'', 0)
set identity_insert WineLabel off
go
insert into WineLabel (Name, WF_StatusID)
select wn.LabelName, WF_StatusID = 100
from RPOWineData.dbo.Wine wn
	left join WineLabel l on wn.LabelName = l.Name
where wn.LabelName  is not null and LEN(wn.LabelName ) > 0  and l.ID is NULL
group by wn.LabelName 
GO

---------- WineProducer
--select top 200 * from RPOWineData.dbo.Wine
set identity_insert WineProducer on
insert into WineProducer (ID, Name, NameToShow, locCountryID,locRegionID,locLocationID,locLocaleID,locSiteID, WF_StatusID) 
values (0, N'', N'', 0,0,0,0,0,0)
set identity_insert WineProducer off
go
insert into WineProducer (Name, NameToShow, WebSiteURL, locCountryID,locRegionID,locLocationID,locLocaleID,locSiteID, WF_StatusID)
select wn.Producer, NameToShow = max(wn.ProducerShow), WebSiteURL = max(wn.ProducerURL), 
	0,0,0,0,0, WF_StatusID = 100
from RPOWineData.dbo.Wine wn
	left join WineProducer l on wn.Producer = l.Name
where wn.Producer is not null and LEN(wn.Producer) > 0 and l.ID is NULL
group by wn.Producer
GO
--select top 200 * from WineProducer where WebSiteURL is NOT NULL

-------- WineDryness
--select max(len(Dryness)) from RPOWineData.dbo.Wine
set identity_insert WineDryness on
insert into WineDryness (ID, Name, WF_StatusID) values (0, N'', 0)
set identity_insert WineDryness off
go
insert into WineDryness (Name, WF_StatusID)
select wn.Dryness, WF_StatusID=100
from RPOWineData.dbo.Wine wn
	left join WineDryness l on wn.Dryness = l.Name
where wn.Dryness  is not null and LEN(wn.Dryness ) > 0  and l.ID is NULL
group by wn.Dryness 
GO

---------- WineColor
set identity_insert WineColor on
insert into WineColor (ID, Name, WF_StatusID) values (0, N'', 0)
set identity_insert WineColor off
go
insert into WineColor (Name, WF_StatusID)
select wn.ColorClass, WF_StatusID = 100
from RPOWineData.dbo.Wine wn
	left join WineColor l on wn.ColorClass  = l.Name
where wn.ColorClass is not null and LEN(wn.ColorClass ) > 0 and l.ID is NULL
group by wn.ColorClass  
GO

-------- WineVariety
set identity_insert WineVariety on
insert into WineVariety (ID, Name, WF_StatusID) values (0, N'', 0)
set identity_insert WineVariety off
go
insert into WineVariety (Name, WF_StatusID)
select wn.Variety, WF_StatusID = 100
from RPOWineData.dbo.Wine wn
	left join WineVariety l on wn.Variety = l.Name
where wn.Variety is not null and LEN(wn.Variety ) > 0  and l.ID is NULL
group by wn.Variety  
GO

-------- Bottle Size
--select max(len(BottleSize)) from RPOWineData.dbo.Wine
--select top 20 * from RPOWineData.dbo.Wine
set identity_insert WineBottleSize on
insert into WineBottleSize (ID, Name, Volume, WF_StatusID) values (0, N'', 0, 0)
set identity_insert WineBottleSize off
go
insert into WineBottleSize (Name, Volume, WF_StatusID)
select name, Volume = litres, WF_StatusID = 0
from [erp].[dbo].[BottleSize] 
go
insert into WineBottleSize (Name, Volume, WF_StatusID)
select wn.BottleSize, Volume = 0, WF_StatusID = 0
from (select BottleSize = case
			when BottleSize = '375 Ml' then '375 ml - Half Bottle'
			when BottleSize = '500 ml' then '500 ml - Two Thirds Bottle'
			when BottleSize = '6 L (Imperial)' then '6 L - Imperial'
			when BottleSize = '750 ml' then '750 ml - Standard Bottle'
			else BottleSize
		end
		from RPOWineData.dbo.Wine)wn
	left join WineBottleSize l on wn.BottleSize = l.Name
where wn.BottleSize is not null and LEN(wn.BottleSize) > 0 and l.ID is NULL
group by wn.BottleSize   
GO
--select * from [erp].[dbo].[BottleSize]
--select * from WineBottleSize order by Name -- ?: ShortName, NameInSummary

-------- WineVintage
--select max(len(Vintage)) from RPOWineData.dbo.Wine
set identity_insert WineVintage on
insert into WineVintage (ID, Name, WF_StatusID) values (0, N'', 0)
set identity_insert WineVintage off
go
insert into WineVintage (Name, WF_StatusID)
select wn.Vintage, WF_StatusID = 100
from RPOWineData.dbo.Wine wn
	left join WineVintage l on wn.Vintage   = l.Name
where wn.Vintage is not null and LEN(wn.Vintage ) > 0  and l.ID is NULL
group by wn.Vintage  
GO

print 'Done.'
GO
