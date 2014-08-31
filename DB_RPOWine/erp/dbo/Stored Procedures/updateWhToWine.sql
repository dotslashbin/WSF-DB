

--bottles database myWines Tastings update [=]
CREATE procedure [dbo].[updateWhToWine] as begin 
 
insert into whToWine(whN,wineN,isDerived,isOfInterest)
	select a.tasterN, a.wineN, 1,1
		from (select tasterN, wineN	
					from tasting
					group by tasterN, wineN
				) a
			left join	
				(select whN, wineN
					from whToWine
					group by whN, wineN
					) b
			on a.tasterN = b.whN and a.wineN = b.wineN
		where
			a.tasterN is not null 
			and a.wineN is not null 
			and 
				(b.whN is null 
				or b.wineN is null
				)
 
update a
		set tastingCount = isnull(b.tastingCount, 0)
		, bottleCount = isnull(c.bottleCount, 0)
	from
		whToWine a
			left join 
				(select tasterN, wineN, count(*) tastingCount
					from tasting
					group by tasterN, wineN
					) b
				on b.tasterN = a.whN
					and b.wineN = a.wineN
 
			left join 
				(select whN, wineN, count(*) bottleCount
					from bottle4..bottles
					group by whN, wineN
					) c
				on c.whN = a.whN
					and c.wineN = a.wineN
		where
			a.tastingCount is null or (a.tastingCount <> isnull(b.tastingCount, 0))
			or a.bottleCount is null or (a.bottleCount <> isnull(c.bottleCount,0))
 
end

 
