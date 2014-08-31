 
CREATE view vDollarsWithNoAuction as 
	with
	a as      (select priceGN, wineNN
				, row_number() over(partition by wineNN order by dollarsPerLiter) ii, dollarsPerLiter
		from vForSalePriceOK aa
			--join erp..priceGToSeller bb
			join vPriceGToSeller bb
				on aa.retailerN = bb.sellerN     
		where wineNN is not null and isNull(auction, '') not like '%[^ ]%'     )
	, b as     (select priceGN, wineNN
				, convert(int,max(ii) *.5) m1raw
				, count(*) cnt
		from a
		group by priceGN, wineNN     )
	, c as     (select a.*
				,  case when 0 = cnt % 2 then m1raw else m1raw+1 end m1
				,  (m1raw + 1) m2
				, b.cnt
			from a
				join b
					on a.priceGN = b.priceGN and a.wineNN = b.wineNN     )
	, d as     (select priceGN, wineNN
			, avg(dollarsPerLiter) dollarsPerLiterMedian
			, min(dollarsPerLiter) dollarsPerLiterLo
			, max(dollarsPerLiter) dollarsPerLiterHi
			, count(*) cnt
		from c
			group by priceGN, wineNN     )
select d.*, e.wineNameN
	from d
		join wine e
			on d.wineNN = e.wineN		
 
 
 
 
