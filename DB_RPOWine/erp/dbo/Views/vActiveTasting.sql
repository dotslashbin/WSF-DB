create view vActiveTasting as
select * 
	from
		(	select *, row_number() over (partition by wineN order by wineN, hasRating desc, isErpTasting desc, isProTasting desc, parkerZralyLevel desc, tasteDate desc, tastingN) ii
			from tasting
		) a
	where ii = 1
