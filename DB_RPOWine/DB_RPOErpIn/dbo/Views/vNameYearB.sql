
create view vNameYearB as
with
a as (     select distinct joinx from nameYear except select distinct joinx from erp..wineName     )
,b as (    select row_number() over (partition by joinX order by idN)ii, *     from nameYear     )
,c as (     select b.* from b join a on a.joinX=b.joinX where ii=1     )
select * from c
