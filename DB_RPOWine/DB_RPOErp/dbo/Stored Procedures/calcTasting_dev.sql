CREATE proc calcTasting_dev(@tastingN int = null)
as begin
with
a as		(	select
					  tastingN
					, case when rating is not null then 1 else 0 end hasRating
					, dbo.isErpPub(pubN) isErpTasting
					, b.parkerZralyLevel parkerZralyLevel
					, case when c.iconN in (1,2) 
								then c.iconN
								else case b.parkerZralyLevel when 1 then 10 when 2 then 11 when 3 then 12 else null end
								end sourceIconN
				from tasting a
					left join wh b
						on a.tasterN = b.whn
					left join wh c
						on a.pubN = c.whn
				where @tastingN=tastingN or @tastingN is null
			)
update b
		set
			  hasRating = a.hasRating
			, isErpTasting = a.isErpTasting
			, parkerZralyLevel = a.parkerZralyLevel
			, sourceIconN =a.sourceIconN
			, updateDate = getDate()
		from tasting b
			join a on b.tastingN=a.tastingN
		where
				b.parkerZralyLevel <>a.parkerZralyLevel  or (a.parkerZralyLevel  is null and b.parkerZralyLevel  is not null) or (a.parkerZralyLevel  is not null and b.parkerZralyLevel  is null)
/*					b.hasRating<>a.hasRating or (a.hasRating is null and b.hasRating is not null) or (a.hasRating is not null and b.hasRating is null)
				or b.isErpTasting<>a.isErpTasting or (a.isErpTasting is null and b.isErpTasting is not null) or (a.isErpTasting is not null and b.isErpTasting is null)
				--or b.parkerZralyLevel <>a.parkerZralyLevel  or (a.parkerZralyLevel  is null and b.parkerZralyLevel  is not null) or (a.parkerZralyLevel  is not null and b.parkerZralyLevel  is null)
				or b.sourceIconN <>a.sourceIconN  or (a.sourceIconN  is null and b.sourceIconN  is not null) or (a.sourceIconN  is not null and b.sourceIconN  is null)
*/
end
