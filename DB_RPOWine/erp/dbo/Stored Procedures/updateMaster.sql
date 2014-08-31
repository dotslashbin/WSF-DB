CREATE proc [dbo].[updateMaster]
as begin
 
 
------------------------------------------------------------------------------------------------------------------------------
-- MasterLoc - update from Mark's Location table
------------------------------------------------------------------------------------------------------------------------------
with
aa as	(select 
				  dbo.dropParenNote(loc) loc
				, dbo.dropParenNote(country) country
				, dbo.dropParenNote(region) region
				, dbo.dropParenNote(location) location
				, dbo.dropParenNote(SubLocation) SubLocation
				, dbo.dropParenNote(DetailedLocation) DetailedLocation
			from locations     )
,ab as	(select
				  case when loc like '%[0-z]%' then loc else null end loc
				, case when country like '%[0-z]%' then country else null end country
				, case when region like '%[0-z]%' then region else null end region
				, case when location like '%[0-z]%' then location else null end location
				, case when subLocation like '%[0-z]%' then subLocation  else null end subLocation 
				, case when detailedLocation like '%[0-z]%' then detailedLocation  else null end detailedLocation 
			from aa     )
, a as	(select
				loc, country, region, location, subLocation, detailedLocation
			from ab
			where loc is not null
			group by loc, country, region, location, subLocation, detailedLocation     )
merge masterLoc b
	using a
		on (a.loc=b.loc or (a.loc is null and b.loc is null))
			and (a.country=b.country or (a.country is null and b.country is null))
			and (a.region=b.region or (a.region is null and b.region is null))
			and (a.location=b.location or (a.location is null and b.location is null))
			and (a.subLocation=b.subLocation or (a.subLocation is null and b.subLocation is null))
			and (a.detailedLocation=b.detailedLocation or (a.detailedLocation is null and b.detailedLocation is null))
when not matched by source then
	delete
when not matched by target then
	insert(loc, country, region, location, subLocation, detailedLocation)
		values(loc, country, region, location, subLocation, detailedLocation); 
 
 
------------------------------------------------------------------------------------------------------------------------------
-- MasterProducerLoc - derived from wineName table.  Need to resolve non-hierarchial Julian names.
------------------------------------------------------------------------------------------------------------------------------
with
aa as (select 
				  case when producer like '%[0-z]%' then producer else null end producer
				, case when producerShow like '%[0-z]%' then producerShow else null end producerShow
				, case when country like '%[0-z]%' then country else null end country
				, case when region like '%[0-z]%' then region else null end region
				, case when location like '%[0-z]%' then location else null end location
				, case when locale like '%[0-z]%' then locale  else null end locale 
				, case when site like '%[0-z]%' then site  else null end site 
			from wineName     )
, a as (	select	  isNull(site, isNull(locale, isNull(location, isNull(region, country)))) loc
				, producer, producerShow, country, region, location, locale subLocation, site detailedLocation
			from aa
			where (producer is not null or producerShow is not null) and (country is not null or region is not null or location is not null or locale is not null or site is not null)
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
when not matched by source then
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
 
 
 
/*
truncate table masterLocProducer
truncate table masterProducer
updateMaster
updateMasterKeywords
select * from masterProducer order by producer
*/
 
