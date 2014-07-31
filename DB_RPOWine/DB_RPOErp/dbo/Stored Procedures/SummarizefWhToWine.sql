-- testing [=]
create proc SummarizefWhToWine as begin


select taste, bot, isPub, pub, isDerived, count(*) cnt
	from (
		select 
				  c.wineN
				, case when tastingCount > 0 then 'has tastings' else '-' end taste
				, case when bottleCount  > 0 then 'has bottles' else '-' end bot
				, isPub
				, case when e.pubN is null then '-' else 'publishes tasting' end pub
				, isDerived
			from whToWine c
				join wh d
					on c.whN = d.whN
				left join (
					select pubN, wineN, count(*) pubCount
						from tasting
						group by pubN, wineN
						) e
					on e.pubN = c.whN
						and e.wineN = c.wineN
			) a
	group by taste, bot, isPub, pub, isDerived


end
