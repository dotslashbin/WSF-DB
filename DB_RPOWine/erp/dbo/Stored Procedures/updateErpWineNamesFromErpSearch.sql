--database update [=]
CREATE proc updateErpWineNamesFromErpSearch as begin 
------------------------------------------------------------------------
-- Set Up the Wine Name Table (new)
------------------------------------------------------------------------
		--update WineNameN back in the RpoWineDatad..wine so it gets copied out
		-- (alternative formulations are 100 times slower)

exec snapRowVersion erp;

update rpowinedatad..wine
	set producer = ltrim(rtrim(producer)), labelName = ltrim(rtrim(labelName)), colorClass = ltrim(rtrim(colorClass)), 
	country = ltrim(rtrim(country)), region = ltrim(rtrim(region)), location = ltrim(rtrim(location)), locale = ltrim(rtrim(locale)), site = ltrim(rtrim(site)), 
	variety = ltrim(rtrim(variety)), wineType = ltrim(rtrim(wineType)), dryness = ltrim(rtrim(dryness))

update erpsearchd..wine
	set producer = ltrim(rtrim(producer)), labelName = ltrim(rtrim(labelName)), colorClass = ltrim(rtrim(colorClass)), 
	country = ltrim(rtrim(country)), region = ltrim(rtrim(region)), location = ltrim(rtrim(location)), locale = ltrim(rtrim(locale)), site = ltrim(rtrim(site)), 
	variety = ltrim(rtrim(variety)), wineType = ltrim(rtrim(wineType)), dryness = ltrim(rtrim(dryness))

update z set joinX = dbo.getJoinx(z.Producer, z.labelName,z.colorClass, 
	z.country, z.region, z.location, z.locale, z.site, 	z.variety, z.wineType, z.dryness) 	
	from RpoWineDataD..wine z

update z set joinX = dbo.getJoinx(z.Producer, z.labelName,z.colorClass, 
	z.country, z.region, z.location, z.locale, z.site, 	z.variety, z.wineType, z.dryness) 	
	from erpSearchD..wine z

update z set joinX = dbo.getJoinx(z.Producer, z.labelName,z.colorClass, 
	z.country, z.region, z.location, z.locale, z.site, 	z.variety, z.wineType, z.dryness) 	
	from wineName z

exec snapRowVersion erp;

insert into wineName(colorClass,country,dryness,labelName,locale,location,namerwhN, producer,producerShow
	, region,site,variety,wineType)
select colorClass,country,dryness,labelName,locale,location,-1, producer,dbo.convertSurname(producer), region,site,variety,wineType
from rpowinedatad..wine z
	left join (select joinx from wineName) y
	on z.joinx = y.joinx
	where  y.joinx is null
	group by z.colorClass,z.country,z.dryness,z.labelName,z.locale,z.location,z.producer,z.region,z.site,z.variety,z.wineType, z.joinx
	order by producer,labelName,colorClass,country,region,location,locale,site,variety,wineType,dryness;

update z set joinX = dbo.getJoinx(z.Producer, z.labelName,z.colorClass, 
	z.country, z.region, z.location, z.locale, z.site, 	z.variety, z.wineType, z.dryness) 	
	from wineName z where joinx is null;


insert into wineName(colorClass,country,dryness,labelName,locale,location,namerwhN, producer,producerShow
	, region,site,variety,wineType) 
select colorClass,country,dryness,labelName,locale,location,-1, producer,dbo.convertSurname(producer), region,site,variety,wineType
from erpSearchD..wine z
	left join (select joinx from wineName) y
	on z.joinx = y.joinx
	where  y.joinx is null
	group by z.colorClass,z.country,z.dryness,z.labelName,z.locale,z.location,z.producer,z.region,z.site,z.variety,z.wineType
	order by producer,labelName,colorClass,country,region,location,locale,site,variety,wineType,dryness

update z set joinX = dbo.getJoinx(z.Producer, z.labelName,z.colorClass, 
	z.country, z.region, z.location, z.locale, z.site, 	z.variety, z.wineType, z.dryness)
	from wineName z where joinx is null;

exec snapRowVersion erp;


with 
a as (select (isNull(producerShow, '') + ' ' + isNull(colorClass, '') + ' ' + isNull(labelName, '') + ' ' +isNull(variety, '') + ' ' +
		isNull(country, '') + ' ' + isNull(region, '') + ' ' + isNull(location, '') + ' ' + isNull([site], '') + ' ' +
		isNull(dryness, '') + ' ' +isNull(wineType, '') + ' '
		) encodedKeyWords
		,winenameN
		from wineName)
update z set z.encodedKeyWords = a.encodedKeyWords
--select a.encodedKeywords, z.encodedKeywords, z.*
		from wineName z
		join a
				on z.winenameN = a.wineNameN
		--where z.encodedKeyWords <> a.encodedKeyWords
		where 0= dbo.isEq(z.encodedKeywords, a.encodedKeywords)

/* TEST
select count(*) from wineName where encodedKeywords is null
*/

update z set z.wineNameN = y.wineNameN
	from RpoWineDataD..wine z
	join erp..wineName y
		on z.joinX = y.joinX
	where y.namerwhN = -1 
	and z.wineNameN is null or z.wineNameN <> y.wineNameN

update z set z.wineNameN = y.wineNameN
	from erpSearchD..wine z
	join erp..wineName y
		on z.joinX = y.joinX
	where y.namerwhN = -1 
	and z.wineNameN is null or z.wineNameN <> y.wineNameN

update z
	set z.dateLo = y.dateLo, z.dateHi = y.dateHi, z.vintageLo = y.vintageLo, z.vintageHi = y.vintageHi, z.wineCount = y.wineCount
	from wineName z
		join (select wineNameN, min(sourceDate) dateLo, max(sourceDate) dateHi, min(vintage) vintageLo, max(vintage) vintageHi, count(*) wineCount
				from rpowinedatad..wine group by wineNameN) y
		on z.wineNameN = y.wineNameN
	where 
		isNull(z.dateLo, 0) <> isNull(y.dateLo, 0)
		or isNull(z.dateHi, 0) <> isNull(y.dateHi, 0)
		or isNull(z.vintageLo,0) <> isNull(y.vintageLo, '')
		or isNull(z.vintageHi, 0) <> isNull(y.vintageHi, '')
		or isNull(z.wineCount, 0) <> isNull(y.wineCount, 0)
		

end
