CREATE proc checkForErpInWh (@ok bit output)
/*
use erpin
declare @ok bit
exec dbo.checkForErpInWh @ok=@ok output
*/
as begin
set noCount on
set @ok=0
/*
pubN
tasterN
bottleSizeN
 
updateWhN
sourceIconN
dataSourceN
*/
 
declare @TT table(error varchar(max));
--declare @ok bit
 
/*insert into @TT(error)
	select 'Publication "' + publication + '" - ' + error
		from
			(
				select publication, 
						(
							case when whN is null then 'not in wh.  ' else '' end
							+ case when isNull(isPub, 0) <> 1 then 'isPub<>1.  ' else '' end
							+ case when isNull(tag, '') not like '%[^  ]%' then 'tag not set.   ' else '' end
						) error				
					from (select distinct publication from vErpWine) a
						left join erp..wh b
							on a.publication = b.displayName      --on a.publication = b.fullName or a.publication = b.displayName
			) a				
		where error  like '%[^ ]%'     */
 
with 
  a as (select distinct publication from rpowinedata..wine)
, b as (select *
			from a
				join erp..wh bb
					on a.publication = bb.fullName or a.publication = bb.displayName     )
, c as (select publication, count(*) cnt					
			from b
			group by publication     )
, d as (select b.*, c.cnt
	from b
		join c
			on b.publication = c.publication     )
, e as (select a.publication
		, whN
		, (
			case when whN is null then 'not in wh.  ' else '' end
			+ case when cnt > 1 then ' multiple matches in wh.  ' else '' end
			+ case when isNull(isPub, 0) <> 1 then 'isPub<>1.  ' else '' end
			+ case when isNull(tag, '') not like '%[^  ]%' then 'tag not set.   ' else '' end
		) error
	from a
		left join d
			on a.publication = d.publication     )
insert into @TT(error)
	select 'Publication "' + publication + '" - [' + convert(varchar, whN) + ']  '  + error
		from e where error  like '%[^ ]%' ;
 
 
 
 
 
 
 
------------------------------------------------------------------------------------------
-- Taster
------------------------------------------------------------------------------------------
/*insert into @TT(error)
	select 'Taster "' + [source] + '" - ' + error
		from
			(
				select [source], 
						(
							case when whN is null then 'not in wh.  ' else '' end
							+ case when isNull(isProfessionalTaster, 0) <> 1 then 'isProfessionalTaster<>1.  ' else '' end
							+ case when isNull(tag, '') not like '%[^  ]%' then 'tag not set.   ' else '' end
						) error				
					from (select distinct [source] from vErpWine) a
						left join erp..wh b
							on a.[source] = b.fullName or a.[source] = b.displayName
			) a				
		where error  like '%[^ ]%'     */
 
 
 
with 
  a as (select distinct [source] taster  from vErpWine)
, b as (select *
			from a
				join erp..wh bb
					on a.taster = bb.fullName or a.taster = bb.displayName     )
, c as (select taster, count(*) cnt					
			from b
			group by taster     )
, d as (select b.*, c.cnt
	from b
		join c
			on b.taster = c.taster     )
, e as (select a.taster
		, whN
		, (
			case when whN is null then 'not in wh.  ' else '' end
			+ case when cnt > 1 then ' multiple matches in wh.  ' else '' end
			+ case when isNull(isProfessionalTaster, 0) <> 1 then 'isProfessionalTaster<>1.  ' else '' end
			+ case when isNull(tag, '') not like '%[^  ]%' then 'tag not set.   ' else '' end
		) error
	from a
		left join d
			on a.taster = d.taster     )
insert into @TT(error)
	select 'Source "' + taster + '" - [' + convert(varchar, whN) + ']  '  + error
		from e where error  like '%[^ ]%' ;
 
 
 
 
 
------------------------------------------------------------------------------------------
-- who updated
------------------------------------------------------------------------------------------
insert into @TT(error)
	select 'Whoupdated "' + whoupdated + '" - ' + error
		from
			(
				select whoupdated, 
						(
							case when whN is null then 'not in wh.  ' else '' end
							+ case when isNull(isEditor, 0) <> 1 then 'isEditor<>1.  ' else '' end
							+ case when isNull(tag, '') not like '%[^  ]%' then 'tag not set.   ' else '' end
						) error				
					from (select distinct whoupdated from vErpWine where dateUpdated > '2006' and whoupdated not in ('mark','doug')) a
						left join erp..wh b
							on a.whoupdated = b.tag
			) a				
		where error  like '%[^ ]%'
	
 
 
 
 
------------------------------------------------------------------------------------------
-- Bottle Size
------------------------------------------------------------------------------------------
insert into @TT(error)
	select 'BottleSize "' + BottleSize + '" - ' + error
		from
			(
				select BottleSize, 
						(
							case when bottleSizeN is null then 'not in BottleSizeAlias.  ' else '' end
						) error				
					from (select distinct BottleSize from vErpWine where bottleSize is not null) a
						left join erpin..bottleSizeAlias b
							on a.BottleSize = b.alias
			) a				
		where error  like '%[^ ]%'
 
select @ok = case when count(*) > 0 then 0 else 1 end from @TT
if @ok <> 1
		select * from @TT
 
 /*
insert into erp..wh(fullName) select 'In the Cellar'
 
select a.fullName, a.tag, b.fullName, b.tag
	from wh a
		join whmay b
			on a.whn = b.whn
	where a.isPub = 1 and a.tag is null and b.tag is not null
	
update a set a.tag = b.tag
	from wh a
		join whmay b
			on a.whn = b.whn
	where a.isPub = 1 and a.tag is null and b.tag is not null
*/
 
end  
