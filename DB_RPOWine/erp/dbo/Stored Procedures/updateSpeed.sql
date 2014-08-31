------------------------------------------------------------------------------------------------------------------------------
-- PROC UpdateSpeed
------------------------------------------------------------------------------------------------------------------------------
CREATE proc updateSpeed
as begin
set nocount on;
 
------------------------------------------------------------------------------------------------------------------------------
-- Publication
------------------------------------------------------------------------------------------------------------------------------
with 
a as (select tastingN,isWA, isWAActive, row_number() over (partition by wineN order by wineN asc,hasRating2 desc,isWA desc,isErpPro desc,ParkerZralyLevel desc,tasteDate desc,tastingN asc) ii
		from tasting
		where isWA=1     )
,b as (select tastingN
			, case when ii=1 then 1 else 0 end isWAActive
		from a)
update c
		set c.isWAActive = b.isWAActive
	from tasting c
		join b
			on c.tastingN=b.tastingN
		where b.isWAActive<>c.isWAActive or c.isWAActive is null;
 
with 
a as (select tastingN,isErpPro, isErpProActive, row_number() over (partition by wineN order by wineN asc,hasRating2 desc,isWA desc,isErpPro desc,ParkerZralyLevel desc,tasteDate desc,tastingN asc) ii
		from tasting
		where isErpPro=1     )
,b as (select tastingN
			, case when ii=1 then 1 else 0 end isErpProActive
		from a)
update c
		set c.isErpProActive = b.isErpProActive
	from tasting c
		join b
			on c.tastingN=b.tastingN
		where b.isErpProActive<>c.isErpProActive or c.isErpProActive is null;
 
 
 
 
 
 
 
 
------------------------------------------------------------------------------------------------------------------------------
-- Also in trigger tasting_setActive
------------------------------------------------------------------------------------------------------------------------------ 
with 
a as (select tastingN,isActive, row_number() over (partition by wineN order by wineN asc,hasRating2 desc,isWA desc,isErpPro desc,ParkerZralyLevel desc,tasteDate desc,tastingN asc) ii
		from tasting
		where isPrivate<>1 and isAnnonymous<>1     )
,b as (select tastingN
			, case when ii=1 then 1 else 0 end isActive
		from a)
update c
		set c.isActive = isNull(b.isActive, 0)
	from tasting c
		join b
			on c.tastingN=b.tastingN
	where b.isActive<>c.isActive or c.isActive is null;
 
 
 
 
 
 
 
 
 
 
 
 
------------------------------------------------------------------------------------------------------------------------------
-- Price
------------------------------------------------------------------------------------------------------------------------------
declare @ErpRetailAll int
select @ErpRetailAll=whN from wh where tag='erpRetailAll';
with 
a as (
		select a.wineN
				, case when b.wineN is not null then b.mostRecentPriceLo when c.wineN is not null then c.mostRecentPriceLo else null end mostRecentPriceLo
				, case when b.wineN is not null then b.mostRecentPriceHi when c.wineN is not null then c.mostRecentPriceHi  else null end mostRecentPriceHi 
				, case when b.wineN is not null then 1 else 0 end isCurrentlyForSale
			from wine a
				left join price b
					on a.wineN=b.wineN
						and b.includesAuction=0
						and b.includesNotForSaleNow=0
						and b.priceGN=@ErpRetailAll
				left join price c
					on a.wineN=c.wineN
						and c.includesAuction=0
						and c.includesNotForSaleNow=1
						and c.priceGN=@ErpRetailAll     )
update b
	set 
		  b.mostRecentPriceLoStd=a.mostRecentPriceLo
		, b.mostRecentPriceHiStd=a.mostRecentPriceHi
		, b.isCurrentlyForSale=a.isCurrentlyForSale 
	from wine b
		join a
			on a.wineN=b.wineN
	where
		b.mostRecentPriceLoStd<>a.mostRecentPriceLo or (a.mostRecentPriceLo is null and b.mostRecentPriceLoStd is not null) or (a.mostRecentPriceLo is not null and b.mostRecentPriceLoStd is null)
		or b.mostRecentPriceHiStd<>a.mostRecentPriceHi or (a.mostRecentPriceHi is null and b.mostRecentPriceHiStd is not null) or (a.mostRecentPriceHi is not null and b.mostRecentPriceHiStd is null)
		or b.isCurrentlyForSale<>a.isCurrentlyForSale or (a.isCurrentlyForSale is null and b.isCurrentlyForSale is not null) or (a.isCurrentlyForSale is not null and b.isCurrentlyForSale is null)
 
end
 
 
 
 
 
 
 
