create view vNameYear as
with
a as (     select distinct(wineN) from nameYear except select distinct(wineN) from erp..wine     )
,b as (     select c.* from nameyear c join a on a.wineN=c.wineN     )
,c as (     select row_number() over (partition by wineN order by dateTasted desc)ii, * from b     )
select * from c where ii=1
