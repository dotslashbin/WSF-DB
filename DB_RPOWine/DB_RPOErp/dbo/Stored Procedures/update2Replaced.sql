
CREATE proc [dbo].[update2Replaced]
as begin
set nocount on
end
 
/*
update user creations
remap julian from history
make sure all winen<999999 are from erpPrint
 
select 
	sum(case when winen>0 then 1 end) plus
	,sum(case when winen<0 then 1 end) minus
	from vjwine
 
select distinct winen from vjwine where winen>0 except select distinct winen from rpowinedatad..wine
 
 
with
a as	(	
			select count(distinct winen)cnt,vintage, activevinn from wine
				group by activevinn,vintage
				--order by cnt desc
		)
select b.winen,b.activevinn,b.vintage
	from wine b
		join a on a.vintage=b.vintage and a.activevinn=b.activevinn
	where cnt=3
	order by winen desc
	
select * from wine order by winen desc
 
select winen from rpowinedatad..wine where winen>999999
select winen from erpcsc..wine where wineN between 0 and 999999 except select winen from rpowinedatad..wine 
*/
 












