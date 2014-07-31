--database update [=]
CREATE procedure [dbo].[zupdateErpWineAndVinnAltFromErp] as begin

------------------------------------------------------------------------
-- Update wineAlt + vinnAlt
------------------------------------------------------------------------
exec snapRowVersion erp;

delete from wineAlt where wineN < 0

insert into wineAlt(wineN, wineNameN)
	select wineN, wineNameN
		from 
			(select wineN, wineNameN
				from erpSearchD..wine
				group by wineN, wineNameN
				) z
		where not exists
			(select * 
				from wineAlt 
				where z.wineN = wineN and z.wineNameN = wineNameN)
		order by wineN

update z set 
		 z.vinn = y.vinn
		,z.vintage = y.vintage
		,z.dateLo = y.dateLo
		,z.dateHi = y.dateHi
		,z.tastingCount = y.tastingCount
	from wineAlt z
		join 
				(select 
						 wineN
						,wineNameN
						,min(vinn) vinn
						,min(vintage) vintage
						,min(sourceDate) dateLo
						,max(sourceDate) dateHi
						,count(*) tastingCount
					from erpSearchD..wine
						group by wineN, wineNameN
					) y
			on z.wineN = y.wineN and z.wineNameN = y.wineNameN
	where
		 isnull(z.vinn, 0) <> isnull(y.vinn, 0)
			or isnull(z.vintage, 0) <> isnull(y.vintage, 0)
			or isnull(z.dateLo, 0) <> isnull(y.dateLo, 0)
			or isnull(z.dateHi, 0) <> isnull(y.dateHi, 0)
			or isnull(z.tastingCount, 0) <> isnull(y.tastingCount, 0)

update z
		set z.encodedKeywords = z.vintage + ' ' + y.encodedKeywords
	from
		wineAlt z
			join wineName y
				on z.wineNameN = y.wineNameN
	where
		isNull(z.encodedKeywords, '') <> isNull(z.vintage + ' ' + y.encodedKeywords, '')
		
update x set isInactive = isInactive2
	from
		(select z.wineN, z.wineNameN, z.isInactive, case when y.wineN is null then 1 else 0 end isInactive2
			from wineAlt z
				left join (select wineN, wineNameN from erpSearchD..wine group by wineN, wineNameN) y
					on z.wineN = y.wineN and z.wineNameN = y.wineNameN
			) x
	where isInactive<> isInactive2

--set the active wine when there are clashes (use most recent)
update z 
		set z.isActiveWineNameForWineN = isActiveWineNameForWineN2
	from 
		(select 
				 *
				,case when row_number() over(partition by wineN order by dateHi desc)  = 1 then 1 else 0 end isActiveWineNameForWineN2 
			from wineAlt where isInactive = 0) z
	where 
		isActiveWineNameForWineN <> isActiveWineNameForWineN2
	


------------------------------------------------------------------------
-- Update vinnAlt
------------------------------------------------------------------------
delete from vinnAlt where vinn < 0

insert into vinnAlt(vinn, wineNameN)
	select vinn, wineNameN
		from
			(select vinn, wineNameN
				from wineAlt
				group by vinn, wineNameN
				) z
		where not exists
			(select * from vinnAlt
				where vinn = z.vinn and wineNameN = z.wineNameN)
				

update z
		set 
			 z.dateLo = y.dateLo
			,z.dateHi = y.dateHi
			,z.vintageLo = y.vintageLo
			,z.vintageHi = y.vintageHi
			,z.tastingCount = y.tastingCount
			,z.isInactive = y.isInactive
		from 
			vinnAlt z
				join 
						(select 
								 vinn
								,wineNameN 
								,min(dateLo) dateLo
								,max(dateHi) dateHi 
								,min(vintage) vintageLo
								,max(vintage) vintageHi
								,count(*) tastingCount
								,case when(max(cast(isInactive as int))) > 0 then 1 else 0 end 	isInactive
							from wineAlt
							group by vinn, wineNameN
							) y
					on z.vinn = y.vinn and z.wineNameN = y.wineNameN
		where
			isNull(z.dateLo, 0) <> isNull(y.dateLo, 0) 
				or isNull(z.dateHi, 0) <> isNull(y.dateHi, 0) 
				or isNull(z.vintageLo, 0) <> isNull(y.vintageLo, 0) 
				or isNull(z.vintageHi, 0) <> isNull(y.vintageHi, 0) 
				or isNull(z.tastingCount, 0) <> isNull(y.tastingCount, 0) 
				or isNull(z.isInactive, 0) <> isNull(y.isInactive, 0) ;

with
 a as (select *, row_number() over (partition by vinN order by dateHi desc, wineN) iRank 
	from wineAlt where isActiveWineNameForWineN = 1 and isInactive = 0)
,b as (select vinn, wineNameN from a where iRank = 1)
update z set isActiveNameForVinn = 1
	from vinnAlt z
	where exists (select * from b 
							where z.vinn = b.vinn 
								and z.wineNameN = b.wineNameN
							)
				and z.isActiveNameForVinn <> 1;

with
 a as (select *, row_number() over (partition by vinN order by dateHi desc, wineN) iRank 
	from wineAlt where isActiveWineNameForWineN = 1 and isInactive = 0)
,b as (select vinn, wineNameN from a where iRank = 1)
update z set isActiveNameForVinn = 0
	from vinnAlt z
	where not exists (select * from b 
							where z.vinn = b.vinn 
								and z.wineNameN = b.wineNameN
							)
				and z.isActiveNameForVinn <> 0;

with
 a as (select *, row_number() over (partition by wineNameN order by dateHi desc, wineN) iRank 
	from wineAlt where isActiveWineNameForWineN = 1 and isInactive = 0)
,b as (select vinn, wineNameN from a where iRank = 1)
update z set isActiveVinnForName = 1
	from vinnAlt z
	where exists (select * from b 
							where z.vinn = b.vinn 
								and z.wineNameN = b.wineNameN
							)
				and z.isActiveVinnForName <> 1;

with
 a as (select *, row_number() over (partition by wineNameN order by dateHi desc, wineN) iRank 
	from wineAlt where isActiveWineNameForWineN = 1 and isInactive = 0)
,b as (select vinn, wineNameN from a where iRank = 1)
update z set isActiveVinnForName = 0
	from vinnAlt z
	where exists (select * from b 
							where z.vinn = b.vinn 
								and z.wineNameN = b.wineNameN
							)
				and z.isActiveVinnForName <> 0;

end

