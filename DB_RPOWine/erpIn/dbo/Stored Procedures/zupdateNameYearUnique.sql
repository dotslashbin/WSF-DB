-------------------------------------------------------------------------------------------------------------------------
-- updateNameYearUnique
-------------------------------------------------------------------------------------------------------------------------
 
CREATE proc [dbo].[zupdateNameYearUnique] as begin 
 
delete from nameYear;
insert into nameYear(wineN,vinN,wid,producer,labelName,vintage,country,region,location,locale,site,variety,colorClass,dryness,wineType)
select wineN,vinN,wid, producer,labelName,vintage,country,region,location,locale,site,variety,colorClass,dryness,wineType
	from  nameYearNorm 
	group by wineN,vinN,wid,producer,labelName,vintage,country,region,location,locale,site,variety,colorClass,dryness,wineType
	order by producer,labelName,country,region,location,locale,site,variety,colorClass,dryness,wineType,vintage
 
update nameYear 
	set 
		  joinX = dbo.getJoinX(Producer, labelName, colorClass, country, region, location, locale, site, variety, wineType, dryness);
 
with
a as (select Producer, labelName, colorClass, country, region, location, locale, site, variety, wineType, dryness, MIN(joinX) joinX
			from nameYear
			group by Producer, labelName, colorClass, country, region, location, locale, site, variety, wineType, dryness
		)
insert into wineName (Producer, labelName, colorClass, country, region, location, locale, site, variety, wineType, dryness, createDate, joinx)
	select a.Producer, a.labelName, a.colorClass, a.country, a.region, a.location, a.locale, a.site, a.variety, a.wineType, a.dryness, getDate(), a.joinx
		from a
			left join wineName b
				on a.joinx = b.joinx
		where b.wineNameN is null;
 
update a
	set a.wineNameN = b.wineNameN
	from nameYear a
		join wineName b
			on a.joinx = b.joinx;
 
 
with
a as (select getDate() dateLo, getDate() dateHi, min(vintage)vintageLo, max(vintage)vintageHi, count(*)wineCount, joinx from nameYear group by joinx)
,b as (select dateLo, dateHi, vintageLo, vintageHi, wineCount, joinx from wineName)
,c as
	(
		select min(dateLo)dateLo, max(dateHi)dateHi, min(vintageLo)vintageLo, max(vintageHi)vintageHi, max(wineCount)wineCount, joinx from
		(
			select * 	from a
			union 
			select * from b
		)d
		group by joinx
	)
update e set dateLo=c.dateLo, dateHi=c.dateHi, vintageLo=c.vintageLo, vintageHi=c.vintageHi, wineCount=c.wineCount, e.isOld = 0
	from wineName e
		join c
			on e.joinx = c.joinx
 
merge wineName as aa
	using	(select distinct joinx from nameyear
		) as bb
	on aa.joinx = bb.joinx
when matched then
	update set aa.isOld = 0
when not matched by source then
	update set aa.isOld = 1;
 
 
 
merge emap as aa
	using	(select wid, vinn, wineN, vintage from nameYear group by wid, vinn, wineN, vintage
		) as bb
	--on aa.wid = bb.wid and aa.vinn=bb.vinn and aa.wineN = bb.wineN and aa.vintage = bb.vintage
	on isNull(aa.wid, '') = isNull(bb.wid, '') and isnull(aa.vinn,0)=isnull(bb.vinn,0) and isnull(aa.wineN, 0) = isnull(bb.wineN, 0) and isnull(aa.vintage, '') = isnull(bb.vintage, '')
when matched then
	update set aa.isOld = 0
when not matched by target then
	insert  (wid, vinn, wineN, vintage, isOld)
		values(bb.wid, bb.vinn, bb.wineN, bb.vintage, 0)
when not matched by source then
	update set aa.isOld = 1;
 
 
 
 
 
 
 
end
/*
	delete from emap
	
	select * from nameYear
	select * from wineName
	select dateLo, dateHi, count(*)cnt from wineName group by dateLo, dateHi
	
	ooi nameyear,cre
	
	update nameYear set wineNameN = null
	select count(*) from nameYear where wineNameN is null
	
	ooi dateLo
*/
 
 
 
 
 
 
 
 
