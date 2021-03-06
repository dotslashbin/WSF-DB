﻿ 
CREATE view vDollars2 as 
	with
	a as      (select priceGN, wineNN
		 		, case when auction like '%a%' then 1 else 0 end isAuction
				, row_number() over(partition by wineNN order by dollarsPerLiter) ii, dollarsPerLiter
		from vForSalePriceOK aa
			--join erp..priceGToSeller bb
			join vPriceGToSeller bb
				on aa.retailerN = bb.sellerN     
		where wineNN is not null     )
	, b as     (select priceGN, wineNN, isAuction
				, convert(int,max(ii) *.5) m1raw
				, count(*) cnt
		from a
		group by priceGN, wineNN, isAuction     )
	, c as     (select a.*
				,  case when 0 = cnt % 2 then m1raw else m1raw+1 end m1
				,  (m1raw + 1) m2
				, b.cnt
			from a
				join b
					on a.priceGN = b.priceGN and a.wineNN = b.wineNN     )
select priceGN, wineNN, isAuction
		, avg(dollarsPerLiter) dollarsPerLiterMedian
		, min(dollarsPerLiter) dollarsPerLiterLo
		, max(dollarsPerLiter) dollarsPerLiterHi
		, count(*) cnt
	from c
		group by priceGN, wineNN, isAuction
		
 
 
 
