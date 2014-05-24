-- ======= Wine Types ========
--
-- Data Source: eRPSearchD.dbo.WAName
--
--
USE [RPOWine]
GO
print '--------- copy data --------'
GO
-------- WineTypes
--select WineType, erpWineType, count(*) from eRPSearchD.dbo.WAName group by WineType, erpWineType
insert into WineType (Name, WF_StatusID)
select isnull(wn.erpWineType, wn.WineType), WF_StatusID = 100
from eRPSearchD.dbo.WAName wn
	join eRPSearchD..ForSaleDetail sd on sd.Wid = wn.Wid
	left join WineType c on isnull(wn.erpWineType, wn.WineType) = c.Name
where wn.Wine_VinN_ID is NULL and isnull(sd.DollarsPer750Bottle, 0) > 0
	and isnull(wn.erpWineType, wn.WineType) is not null and LEN(isnull(wn.erpWineType, wn.WineType)) > 0 and c.ID is NULL
group by isnull(wn.erpWineType, wn.WineType)

----------- WineLabel
insert into WineLabel (Name, WF_StatusID)
select wn.LabelName, WF_StatusID = 100
from eRPSearchD.dbo.WAName wn
	join eRPSearchD..ForSaleDetail sd on sd.Wid = wn.Wid
	left join WineLabel l on wn.LabelName = l.Name
where wn.Wine_VinN_ID is NULL and isnull(sd.DollarsPer750Bottle, 0) > 0
	and wn.LabelName is not null and LEN(wn.LabelName) > 0  and l.ID is NULL
group by wn.LabelName

---------- WineProducer
--select top 20 * from WineProducer where Name like '%bott%' or NameToShow like '%bott%'
insert into WineProducer (Name, NameToShow, WebSiteURL, ProfileFileName, locCountryID,locRegionID,locLocationID,locLocaleID,locSiteID, WF_StatusID)
select isnull(wn.erpProducer,wn.Producer), NameToShow = max(isnull(wn.erpProducerShow,wn.ProducerShow)), WebSiteURL = '', ProfileFileName = '', 
	0,0,0,0,0, WF_StatusID = 100
from eRPSearchD.dbo.WAName wn
	join eRPSearchD..ForSaleDetail sd on sd.Wid = wn.Wid
	left join WineProducer l on isnull(wn.erpProducer,wn.Producer) = l.Name
where wn.Wine_VinN_ID is NULL and isnull(sd.DollarsPer750Bottle, 0) > 0
	and isnull(wn.erpProducer,wn.Producer) is not null and LEN(isnull(wn.erpProducer,wn.Producer)) > 0 
	and l.ID is NULL
group by isnull(wn.erpProducer,wn.Producer)

-------- WineDryness
--select max(len(Dryness)) from RPOWineData.dbo.Wine
insert into WineDryness (Name, WF_StatusID)
select wn.Dryness, WF_StatusID=100
from eRPSearchD.dbo.WAName wn
	join eRPSearchD..ForSaleDetail sd on sd.Wid = wn.Wid
	left join WineDryness l on wn.Dryness = l.Name
where wn.Wine_VinN_ID is NULL and isnull(sd.DollarsPer750Bottle, 0) > 0
	and wn.Dryness  is not null and LEN(wn.Dryness) > 0  and l.ID is NULL
group by wn.Dryness 

---------- WineColor
insert into WineColor (Name, WF_StatusID)
select wn.ColorClass, WF_StatusID = 100
from eRPSearchD.dbo.WAName wn
	join eRPSearchD..ForSaleDetail sd on sd.Wid = wn.Wid
	left join WineColor l on wn.ColorClass  = l.Name
where wn.Wine_VinN_ID is NULL and isnull(sd.DollarsPer750Bottle, 0) > 0
	and wn.ColorClass is not null and LEN(wn.ColorClass ) > 0 and l.ID is NULL
group by wn.ColorClass  

-------- WineVariety
--select * from WineVariety where Name like 'mos%'
insert into WineVariety (Name, WF_StatusID)
select wn.Variety, WF_StatusID = 100
from eRPSearchD.dbo.WAName wn
	join eRPSearchD..ForSaleDetail sd on sd.Wid = wn.Wid
	left join WineVariety l on wn.Variety = l.Name
where wn.Wine_VinN_ID is NULL and isnull(sd.DollarsPer750Bottle, 0) > 0
	and wn.Variety is not null and LEN(wn.Variety ) > 0  and l.ID is NULL
group by wn.Variety  

-------- WineVintage
insert into WineVintage (Name, WF_StatusID)
select sd.Vintage, WF_StatusID = 100
from eRPSearchD.dbo.WAName wn
	join eRPSearchD.dbo.ForSaleDetail sd on sd.Wid = wn.Wid
	left join WineVintage l on sd.Vintage = l.Name
where wn.Wine_VinN_ID is NULL and isnull(sd.DollarsPer750Bottle, 0) > 0
	and sd.Vintage is not null and LEN(sd.Vintage) > 0 and l.ID is NULL
group by sd.Vintage 

--------  Country
insert into LocationCountry (Name, WF_StatusID)
select wn.Country, WF_StatusID = 100
from eRPSearchD.dbo.WAName wn
	join eRPSearchD.dbo.ForSaleDetail sd on sd.Wid = wn.Wid
	left join LocationCountry c on wn.Country = c.Name
where wn.Wine_VinN_ID is NULL and isnull(sd.DollarsPer750Bottle, 0) > 0
	and wn.Country is not null and LEN(wn.Country) > 0 and c.ID is NULL
	and wn.Country != 'Table'
group by wn.Country

--------  Region
insert into LocationRegion (Name, WF_StatusID)
select wn.Region, WF_StatusID = 100
from eRPSearchD.dbo.WAName wn
	join eRPSearchD.dbo.ForSaleDetail sd on sd.Wid = wn.Wid
	left join LocationRegion r on wn.Region = r.Name
where wn.Wine_VinN_ID is NULL and isnull(sd.DollarsPer750Bottle, 0) > 0
	and wn.Region is not null and LEN(wn.Region) > 0 and r.ID is NULL
group by wn.Region

----- location
insert into LocationLocation (Name, WF_StatusID)
select wn.Location, WF_StatusID = 100
from eRPSearchD.dbo.WAName wn
	join eRPSearchD.dbo.ForSaleDetail sd on sd.Wid = wn.Wid
	left join LocationLocation r on wn.Location = r.Name
where wn.Wine_VinN_ID is NULL and isnull(sd.DollarsPer750Bottle, 0) > 0
	and wn.Location is not null and LEN(wn.Location) > 0 and r.ID is NULL
group by wn.Location

print 'Done.'
GO
