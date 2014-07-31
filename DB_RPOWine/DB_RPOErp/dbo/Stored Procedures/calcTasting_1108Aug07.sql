create proc calcTasting_1108Aug07(@tastingN int = null)
as begin
	update a 
		set
			  hasRating = case when rating is not null then 1 else 0 end
			, isErpTasting = dbo.isErpPub(pubN)
			, parkerZralyLevel = b.parkerZralyLevel
			, sourceIconN =	case when c.iconN in (1,2) 
						then c.iconN
						else case b.parkerZralyLevel when 1 then 10 when 2 then 11 when 3 then 12 else null end
						end
			, updateDate = getDate()
		from tasting a
			left join wh b
				on a.tasterN = b.whn
			left join wh c
				on a.pubN = c.whn
		where
			--@tastingN=tastingN
			@tastingN=tastingN or @tastingN is null
			
end
 
/*
calcTasting
 
select top 100 * from tasting where vintage like '17%'
ov tasting
 
select * from tasting where hasRating is null
 
calcTasting 5191295
 
select sourceIconN, count(*) cnt from tasting group by sourceIconN
*/
