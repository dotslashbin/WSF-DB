--database update [=]
CREATE procedure [dbo].[updatePriceAll] as begin 

-- make sure that all retailers are in the "All" group
declare @erpRetailAll int; set @erpRetailAll = (select top 1 whN from wh where isRetailer = 1 and tag = 'erpRetailAll')

insert into priceGToSeller (priceGN, sellerN, isDerived)
	select @erpRetailAll, whN, 1
		from wh z
		where 
			isRetailer = 1 and isGroup = 0
			and not exists
				(select * from priceGToSeller
					where priceGN = @erpRetailAll
						and sellerN = z.whN
					)


-- update each of the includesNotForSaleNow / includesAution variations
exec dbo.updatePricePart 0,0
exec dbo.updatePricePart 0,1
exec dbo.updatePricePart 1,0
exec dbo.updatePricePart 1,1

update z set wineNameN = y.wineNameN
	from price z
		join (
			select wineN, wineNameN
			from wine
			union
			select wineN, min(wineNameN) wineNameN
				from wineAlt
					where wineN not in (select wineN from wine)
					group by wineN
			) y
			on z.wineN = y.wineN
	where
		isNull(z.wineNameN, -999999999) <> isNull(y.wineNameN, -999999999);

--get most recent (sourcedate) estimatedprice from tasting where publisher in our list
with a as(
	select wineN, estimatedCostLo, estimatedCostHi, row_number() over (partition by wineN order by pubDate desc) i
		from tasting 
		where estimatedCostLo > 0 
			and pubDate is not null
			and pubN in (select whN from wh where isPub = 1)
	)
update z set z.estimatedCostLo = a.estimatedCostLo, z.estimatedCostHi = a.estimatedCostHi
	from wine z
		join a
			on z.wineN = a.wineN
	where isNull(z.estimatedCostLo, -1) <> isNull(a.estimatedCostLo, -1)
		and a.i = 1;

-------------------------------------------------------------
-- Construct a super/fake PriceGN=0 that includes estimatedCost from the wine table
-------------------------------------------------------------
/*
declare @erpSuper int; set @erpSuper = (select top 1 whN from wh where isRetailer = 1 and tag = 'erpRetailSuper')
insert into price (includesNotForSaleNow, includesAuction, priceGN, wineN, wineNameN, mostRecentPriceLo, mostRecentPriceHi, mostRecentPriceCnt)
	select includesNotForSaleNow, includesAuction, @erpSuper, wineN, wineNameN, mostRecentPriceLo, mostRecentPriceHi, mostRecentPriceCnt
		from vBestPriceGPerWine z
		where not exists
			(select * from price
				where includesNotForSaleNow = z.includesNotForSaleNow 
					and includesAuction = z.includesAuction
					and priceGN = @superPriceGN
					and wineN = z.wineN
				)

insert into price (includesNotForSaleNow, includesAuction, priceGN, wineN, wineNameN, mostRecentPriceLo, mostRecentPriceHi, mostRecentPriceCnt)
	select includesNotForSaleNow, includesAuction, @superPriceGN, wineN, wineNameN, mostRecentPriceLo, mostRecentPriceHi, mostRecentPriceCnt

update z 
	set z.mostRecentPriceLo = y.mostRecentPriceLo
		, z.mostRecentPriceHi = y.mostRecentPriceHi
		, z.mostRecentPriceCnt = y.mostRecentPriceCnt
	from price z
		join vBestPriceGPerWine y
			on z.

		from vBestPriceGPerWine z
		where not exists
			(select * from price
				where includesNotForSaleNow = z.includesNotForSaleNow 
					and includesAuction = z.includesAuction
					and priceGN = @superPriceGN
					and wineN = z.wineN
				)





*/

/*
drop view vBestPriceGPerWine
create view vBestPriceGPerWine as
	( select * from
		(select *, row_number() over (partition by includesAuction, wineN order by mostRecentPriceCnt desc) i
			from price
			where includesNotForSaleNow = 1
			) z
		where i = 1
		)
*/




end
