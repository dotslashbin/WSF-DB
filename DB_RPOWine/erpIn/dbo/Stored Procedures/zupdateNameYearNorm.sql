CREATE proc [dbo].[zupdateNameYearNorm] as begin 
 
delete from nameYearNorm
 
set identity_Insert nameYearNorm on 
insert into nameYearNorm(idn,wineN,vinN,wid,producer,producerShow,labelName,vintage,country,region,location,locale,site,variety,colorClass,dryness,wineType,dateCreated,dateUpdated,whoUpdated,fixedId)
select idn,wineN,vinN,wid,producer,producerShow,labelName,vintage,country,region,location,locale,site,variety,colorClass,dryness,wineType,getDate(), getDate(),whoUpdated,fixedId
	from nameYearRaw
set identity_Insert nameYearNorm off
 
update nameYearNorm set producer = dbo.normalizeName(producer)
update nameYearNorm set producerShow = dbo.normalizeName(producerShow)
update nameYearNorm set labelName = dbo.normalizeName(labelName)
update nameYearNorm set vintage = dbo.normalizeName(vintage)
update nameYearNorm set country = dbo.normalizeName(country)
update nameYearNorm set region = dbo.normalizeName(region)
update nameYearNorm set locale = dbo.normalizeName(locale)
update nameYearNorm set site = dbo.normalizeName(site)
update nameYearNorm set variety = dbo.normalizeName(variety)
update nameYearNorm set colorClass = dbo.normalizeName(colorClass)
update nameYearNorm set dryness = dbo.normalizeName(dryness)
update nameYearNorm set wineType = dbo.normalizeName(wineType)
 
end
 
 
