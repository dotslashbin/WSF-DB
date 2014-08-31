CREATE proc [dbo].[unifyImport] as begin
 
--alter view vUserWines as select * from transfer..userwines20
if exists (select * from vUserWines where errors is not null) 
	return
 
update vUserWines set rowflag=-2;

with

a as	(	select min(id) id,sum(isnull(convert(float,purchaseQuantity),0)) purchaseQuantity
			from vUserWines 
			where isDetail=1
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

end
 
