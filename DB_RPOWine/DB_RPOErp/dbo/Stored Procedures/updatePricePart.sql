--database update 		[=]
CREATE procedure [dbo].[updatePricePart] 
	@includesNotForSaleNow bit = 0
	, @includesAuction bit = 0
as begin

--declare @includesAuction bit, @includesNotForSaleNow bit
--select @includesNotForSaleNow = 1, @includesAuction = 1
exec snapRowVersion dwf

--delete from price where wineN < 0 and wineN not in (select wineN from wine union select wineN from wineAlt)

----insert new 
insert into price(priceGN, includesNotForSaleNow, includesAuction, wineN, mostRecentPriceLo, mostRecentPriceHi, mostRecentPriceCnt)
select z.* 
	from (select priceGN, @includesNotForSaleNow includesNotForSaleNow, @includesAuction includesAuction, wineN, cast(min(price) as money)  priceLo, cast(max(price) as money) priceHi, count(*) cnt
				from vPriceInput where (@includesAuction = 1 or isAuction = 0) --@priceG
				group by priceGN, wineN) z
	left join price y
		on z.priceGN = y.priceGN
			and z.includesNotForSaleNow = y.includesNotForSaleNow
			and z.includesAuction = y.includesAuction
			and z.wineN = y.wineN 
	where y.wineN is null
	order by z.wineN

--update existing
update z set
		z.mostRecentPriceLo = y.PriceLo
		,z.mostRecentPriceHi = y.PriceHi
		,z.mostRecentPriceCnt = y.Cnt
	from price z
		join (select priceGN, @includesAuction includesAuction, @includesNotForSaleNow includesNotForSaleNow, wineN, cast(min(price) as money)  priceLo, cast(max(price) as money) priceHi, count(*) cnt
		from vPriceInput where (@includesAuction = 1 or isAuction = 0) --@priceG
		group by priceGN, wineN) y
		on z.priceGN = y.priceGN
			and z.includesAuction = y.includesAuction
			and z.includesNotForSaleNow = y.includesNotForSaleNow
			and z.wineN = y.wineN 
		where	--the comparisons below fail unless priceLo and priceHi are cast above to be the same as the price table (money)
			isNull(z.mostRecentPriceLo, -1) <> isNull(y.priceLo, -1)
			or isNull(z.mostRecentPriceHi, -1) <> isNull(y.priceHi, -1)
			or isNull(z.mostRecentPriceCnt, -1) <> isNull(y.cnt, -1)


if @includesNotForSaleNow = 0 begin
	delete
		from price 
		where includesNotForSaleNow = @includesNotForSaleNow and includesAuction = @includesAuction
			and wineN not in (
				select wineN 
				from vPriceInput 
				where (@includesAuction = 1 or isAuction = 0))
	end

end
