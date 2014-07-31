

CREATE view [dbo].[jb] as
with a as
	(
		select country loc, COUNT(*)cnt from dbo.SYN_t_Wine group by country	-- rpowinedataD..wine
		union
		select Region loc, COUNT(*)cnt from dbo.SYN_t_Wine group by region
		union
		select location loc, COUNT(*)cnt from dbo.SYN_t_Wine group by location
		union
		select locale loc, COUNT(*)cnt from dbo.SYN_t_Wine group by locale
		union
		select site loc, COUNT(*)cnt from dbo.SYN_t_Wine group by site
	)
select loc, sum(cnt)cnt from a group by loc

