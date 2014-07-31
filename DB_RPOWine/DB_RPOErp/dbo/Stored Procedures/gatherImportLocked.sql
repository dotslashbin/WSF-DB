CREATE proc [dbo].[gatherImportLocked] @whN int
as begin
--declare @whN int = 20 
 
exec dbo.alterViewUserWines @whN
 
if exists (select * from vUserWines where errors is not null) 
	return
 
-----------------------------------------------------------------------------------
-- Unify
---------------------------------------------------------------------------------- 
update vUserWines set rowflag=-2;
 
with
a as	(	select min(id) id,sum(isnull(convert(float,purchaseQuantity),0)) purchaseQuantity
			from vUserWines where isDetail=1
			group by MyWineName,Vintage,BottleSize,Supplier,PurchaseDate,DeliveryDate,Price,Location 
		)
update b
		set
			  b.rowflag=-null
			, b.purchaseQuantity=a.purchaseQuantity
	from vUserwines b
		join a
			on a.id=b.id;
 
delete from vuserwines where rowflag=-2
 
 
-----------------------------------------------------------------------------------
-- Gather
----------------------------------------------------------------------------------
update vUserWines set isDetail=1;
declare @D1 nvarchar(max) ; select top 1 @D1=myWineName from vUserWines;
 
with
ya as		(	select top 99999 MyWineName, Vintage,BottleSize, location from vUserWines where isDetail=1 group by MyWineName, Vintage,BottleSize, location      )
,yb as	(	select MyWineName, Vintage,BottleSize
				, replace(dbo.concatFF(location), char(12), '; ') location
				from ya
				group by MyWineName, Vintage,BottleSize
		)
,a as	(	select top 999999 * from vUserWines where isDetail=1 order by MyWineName, Vintage,BottleSize, supplier, purchaseDate     )
,ab as	(	select  MyWineName, Vintage,BottleSize, supplier, purchaseDate, price
					, sum(convert(float,case when 1=dbo.isNumericOnly(PurchaseQuantity) then PurchaseQuantity else 0 end))PurchaseQuantity
				from a
				group by MyWineName, Vintage,BottleSize, supplier, purchaseDate, price
		)
,b as	(	select	 Vintage, MyWineName, BottleSize
					, sum(convert(float,case when 1=dbo.isNumericOnly(PurchaseQuantity) then PurchaseQuantity else 0 end))PurchaseQuantity
					, min(year(purchaseDate))yearLo
					, max(year(purchaseDate))yearHi
					, min(convert(float,case when 1=dbo.isNumericOnly(price) then round(price,0) else 0 end))priceLo
					, max(convert(float,case when 1=dbo.isNumericOnly(price) then round(price,0)else 0 end))priceHi
				from ab
				group by MyWineName, Vintage,BottleSize
		)
,bc as	(	select	 ab.Vintage, ab.MyWineName, ab.BottleSize, ab.PurchaseQuantity
					, dbo.purchaseShow1(supplier, purchaseDate, price, yearLo, yearHi, priceLo, priceHi) purchases
				from ab
					join b
						on b.Vintage=ab.Vintage and b.MyWineName=ab.MyWineName and isNull(b.BottleSize,750)=isNull(ab.BottleSize,750)
		)
,bd as	(	select	Vintage, MyWineName, BottleSize,  purchases
					, sum(PurchaseQuantity) PurchaseQuantity
				from bc
				group by Vintage, MyWineName, BottleSize, purchases
		)
,be as	(	select	Vintage, MyWineName, BottleSize
					, sum(PurchaseQuantity) PurchaseQuantity
					,  dbo.concatFF(purchases) purchases
				from bd
				group by Vintage, MyWineName, BottleSize
		)
,bf as	(	select	Vintage, MyWineName, BottleSize, PurchaseQuantity
					,  replace(purchases, char(12), '<br>') purchases
				from be
		)
,bg as		(select bf.*, location
			--from c
			from bf
				join yb
					on yb.Vintage=bf.Vintage and yb.MyWineName=bf.MyWineName and isNull(yb.BottleSize,750)=isNull(bf.BottleSize,750)
 
		)
insert into vUserWines(isDetail,vintage,MyWineName, BottleSize,PurchaseQuantity,Alert,Location)
	select 
		  0
		, Vintage
		, MyWineName
		, BottleSize
		, case when PurchaseQuantity > 0 then PurchaseQuantity else null end
		, case 
			when purchases like '%[0-z]%' 
			then 
				case when location like '%[0-z]%' then purchases+'<br><br>'
					+case when location like '%[^ ]%' then ('<i>['+location+']</i>') else null end 
						 else purchases end 
					else location 
			end
		, location
		from bg
		order by MyWineName, Vintage,BottleSize
end
