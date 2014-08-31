
CREATE proc [dbo].updateMasterTableLocProducerLocked (@wineNameN nvarchar(2000))
as begin
 
declare @date smallDatetime =getDate();
 
with
aa as (select 
				  case when producer like '%[0-z]%' then producer else null end producer
				, case when producerShow like '%[0-z]%' then producerShow else null end producerShow
				, case when country like '%[0-z]%' then country else null end country
				, case when region like '%[0-z]%' then region else null end region
				, case when location like '%[0-z]%' then location else null end location
				, case when locale like '%[0-z]%' then locale  else null end locale 
				, case when site like '%[0-z]%' then site  else null end site 
			from wineName b
					join (select distinct wineNameN from wine) c
						on b.wineNameN=c.wineNameN
				where (@wineNameN is null or @wineNameN=b.wineNameN)     )
, a as (	select	  isNull(site, isNull(locale, isNull(location, isNull(region, country)))) loc
				, producer, producerShow, country, region, location, locale subLocation, site detailedLocation
			from aa
			where (producer is not null or producerShow is not null) 
			group by producer, producerShow, country, region, location, locale, site     ) 
merge masterLocProducer b
	using a
		on (a.loc=b.loc or (a.loc is null and b.loc is null))
			and (a.producer=b.producer or (a.producer is null and b.producer is null))
			and (a.producerShow=b.producerShow or (a.producerShow is null and b.producerShow is null))
			and (a.country=b.country or (a.country is null and b.country is null))
			and (a.region=b.region or (a.region is null and b.region is null))
			and (a.location=b.location or (a.location is null and b.location is null))
			and (a.subLocation=b.subLocation or (a.subLocation is null and b.subLocation is null))
			and (a.detailedLocation=b.detailedLocation or (a.detailedLocation is null and b.detailedLocation is null))
when not matched by source and @wineNameN is null then
	delete
when not matched by target then
	insert(loc, producer, producerShow, country, region, location, subLocation, detailedLocation)
		values(loc, producer, producerShow, country, region, location, subLocation, detailedLocation); 
 
with
a as (	select producer, producerShow
			from masterLocProducer
			group by producer, producerShow     )
merge masterProducer b
	using a
		on (a.producer=b.producer or (a.producer is null and b.producer is null))
			and (a.producerShow=b.producerShow or (a.producerShow is null and b.producerShow is null))
when not matched by source then
	delete
when not matched by target then
	insert(producer, producerShow)
		values(producer,producerShow); 
 
end
 
 
 
 
 
 
 







