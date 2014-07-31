CREATE proc [dbo].updateWineAlertVinn2 as begin 
 

update waWineAlertDatabase set errors = null, warnings = null, vinn2 = null
update waWineAlertDatabase set errors = isNull(errors + ';  ', '') + '[E01]  Vinn not numeric' where vinn1 is not null and isNumeric(vinn1) = 0;
update waWineAlertDatabase set vinn2 = convert(int, vinn1) where errors is null;


----------------------------------------------------------------------
--fill in vinn2 when there is a unique mapping through wineN from forSale
----------------------------------------------------------------------
update waWineAlertDatabase set vinn2 = null, producer2 = null;

with
 a as (select [wineAlert id] wid, vinn2 from waWineAlertDatabase where vinn2 is null) 
,b as (select [wineAlert id]wid, wineN from waForSale where wineN is not null group by [wineAlert id], wineN) 
,c as	(select wid, d.vinn
		from b
			join erpWine d
				on b.wineN = d.wineN
	)
,e as (select wid from c group by wid having count(*) = 1)
update a set vinn2 = vinn
	from a
		join c on a.wid = c.wid
		join b on a.wid = b.wid



 ----------------------------------------------------------------------
--translate to erp producer when there is a vinn
----------------------------------------------------------------------

update a set a.producer2 = b.producer
	from waWineAlertDatabase a
		join (select vinn, max(producer)producer from erpWine group by vinn) b
			on a.vinn2 = b.vinn 
			
-- translate other wines with same producer
update a set a.producer2 = b.producer2
	from waWineAlertDatabase a
		join (select prod1, max(producer2) producer2 from waWineAlertDatabase where vinn2 is not null group by prod1) b
			on a.prod1 = b.prod1
	where
		a.producer2 is null; 

update waWineAlertDatabase set producer2 = replace(prod1, '"', '') where producer2 is null



----------------------------------------------------------------------
--update vinn2 from allocateVinn
----------------------------------------------------------------------
--create table allocateWidVinn(wid varchar(30), vinn int, isAuto bit) 

update a set vinn2 = b.vinn
	from waWineAlertDatabase a
		join allocateWidVinn b
			on a.[wineAlert Id] = b.wid

 
----------------------------------------------------------------------
--allocate new vinn directly to unmatched wid
----------------------------------------------------------------------
 --select count(distinct [winealert id]) from waWineAlertDatabase where vinn2 is null

merge allocateWidVinn as aa
	using	(select vinn from erpWine group by vinn)bb
on aa.vinn = bb.vinn
when matched then
	update set aa.isAuto = 0
when not matched by target then
	insert  (wid, vinn, isAuto)
		values(null, bb.vinn, 0);
 
merge allocateWidVinn as aa
	using	(select max(wid)wid, vinn1 from waDB where vinn1 is not null and errors is null group by vinn1) as bb
on aa.vinn = bb.vinn1
when matched then
	update set aa.wid = bb.wid, aa.isAuto = 0
when not matched by target then
	insert  (wid, vinn, isAuto)
		values(bb.wid, bb.vinn1, 0);

declare @maxRealVinn int = (select max(vinn) from allocateWidVinn where isAuto = 0);
declare @minAutoVinn int = (select min(vinn) from  allocateWidVinn where vinn > @maxRealVinn and isAuto <> 0);
set @minAutoVinn = isNull(@minAutoVinn, 1000000);
with
a as (select a.wid, row_number() over(order by a.wid)ii
	from wadb a 
		left join allocateWidVinn b
			on a.wid = b.wid
	where a.wid like '%[!a-b0-9]%'and b.wid is null
	)
insert into allocateWidVinn(wid, vinn, isAuto) 
	select wid,@minAutoVinn-ii,1 from a	


 
 
----------------------------------------------------------------------
--create fake nameYearRaw entries
----------------------------------------------------------------------

end


/*
update waWineAlertDatabase set producer2=null

select * from waWineAlertDatabase where vinn2 is null

select * from waWineAlertDatabase where vinn2 is null and producer2 <> prod1

*/

