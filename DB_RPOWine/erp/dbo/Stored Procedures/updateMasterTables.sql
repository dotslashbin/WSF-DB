CREATE proc [dbo].[updateMasterTables]
as begin
/*
use erp
*/
 
------------------------------------------------------------------------------------------------------------------------------
-- Keywords
------------------------------------------------------------------------------------------------------------------------------

begin try
drop table #wordKey_temp
end try begin catch end catch;
with
a as	(select keyword wordBin, display_term word, document_id wineNameN
			from sys.dm_fts_index_keywords_by_document(  DB_ID('erp') , OBJECT_ID('wineName') )
			where column_id=(select column_id from sys.columns where object_id = object_id('wineName') and name='encodedKeywords')     )
,b as	(select a.*, b.encodedKeywords keywords
	from a
		join wineName b
			on a.wineNameN=b.wineNameN     )
select *
	into #wordKey_temp
	from b
	order by word, wineNameN;
 
merge wordKey c
	using #wordKey_temp b
		on b.wordBin=c.wordBin and b.wineNameN=c.wineNameN
	when matched and (c.word<>b.word or c.keywords<>b.keywords) then
		update set c.word=b.word, c.keywords=b.keywords
	when not matched by source then
		delete
	when not matched by target then
		insert(wordBin, word, wineNameN, keywords)
			values(wordBin, word, wineNameN, keywords);
 
 
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
			--where (producer is not null or producerShow is not null) and (country is not null or region is not null or location is not null or locale is not null or site is not null)
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
 
 
------------------------------------------------------------------------------------------------------------------------------
-- MasterVariety
------------------------------------------------------------------------------------------------------------------------------
--alter table masterVariety add colorClass nvarchar(20)
merge masterVariety m
	using (select distinct variety from markVariety) a
		on m.variety=a.variety
when matched then
	update set m.isPending=0
when not matched by target then
	insert(variety, isPending, isCommon)
		values(a.variety,0,0)
when not matched by source then
	update set isPending=1, isCommon=0;
 
with
a		as (select variety, colorClass from markVariety where colorClass like '%[0-z]%' group by variety, colorClass)
,bb		as (select variety, min(colorClass)colorClass,count(distinct colorClass)cntColor from a group by variety)
merge masterVariety m
	using bb b
		on m.variety=b.variety
--when matched and b.cntColor=1 then
--	update set colorClass = b.colorClass
when matched then
	update set colorClass = case when b.cntColor=1 then b.colorClass else null end
when not matched by source then
	update set colorClass=null;
 
/*
truncate table masterVariety
select * from masterVariety order by colorclass
*/
 
------------------------------------------------------------------------------------------------------------------------------
-- Color
------------------------------------------------------------------------------------------------------------------------------
/*
truncate table masterColorClass
select * from masterColorClass
*/
insert into masterColorClass(ColorClass) select distinct colorClass from masterVariety where colorClass is not null
 
 
 
end
 
 
 
 
 
 
/*
truncate table masterLocProducer
truncate table masterProducer
updateMaster
updateMasterKeywords
select * from masterProducer order by producer
*/
 
 
 
