CREATE view [dbo].[jc] as

with
	b as
	(
		select country,region,Location,locale,[site] 
		from dbo.SYN_t_Wine where Rating >85
		group by country,region,Location,locale,[site]
	)
	,a as
	(
		select country loc, b.*from b 
		union
		select Region loc,  b.*from b 
		union
		select location loc,  b.*from b
		union
		select locale loc,  b.*from b 
		union
		select site loc,  b.*from b 
	)
	,c as
	(
		select * from a where loc is not null group by loc,country,region,Location,locale,[site]
	)
select Loc,count(*)cntLoc,count(distinct region)cntRegion,count(distinct country)cntCountry from c group by loc
