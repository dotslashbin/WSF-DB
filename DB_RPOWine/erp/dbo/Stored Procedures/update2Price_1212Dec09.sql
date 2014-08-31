CREATE proc [dbo].update2Price_1212Dec09 as begin
set nocount on
 exec dbo.oolog 'update2Price begin'; 
 
insert into mapjtoe(jwinen,ewinen)
	select winen,winen from vjwine where winen>0 and not exists(select * from mapjtoe where jwinen=winen)			
 
truncate table mapetoj
 
insert into mapetoj(ewinen,jwinen)
	select ewinen,jwinen
		from (select row_number()over(partition by ewinen order by jwinen)ii,jwinen,ewinen from mapjtoe)a
		where ii=1
 
update a set
		 a.isCurrentlyForSale=c.isCurrentlyForSale
		,a.mostRecentPriceLoStd=c.mostRecentPrice
		,a.mostRecentPriceHiStd=c.mostRecentPriceHi
		,a.mostRecentPriceCnt=c.mostRecentPriceCnt
		,a.mostRecentAuctionPriceLoStd=c.mostRecentAuctionPrice
		,a.mostRecentAuctionPriceHiStd=c.mostRecentAuctionPriceHi
		,a.mostRecentAuctionPriceCnt=c.mostRecentAuctionPriceCnt
	from wine a
		join mapEToJ b
			on a.winen=b.ewinen
		join vjWine c
			on b.jwinen=c.winen
	where
		a.isCurrentlyForSale<>c.isCurrentlyForSale or ( a.isCurrentlyForSale is null and c.isCurrentlyForSale is not null) or (a.isCurrentlyForSale is not null and c.isCurrentlyForSale is null)
		or a.mostRecentPriceLoStd<>c.mostRecentPrice or ( a.mostRecentPriceLoStd is null and c.mostRecentPrice is not null) or (a.mostRecentPriceLoStd is not null and c.mostRecentPrice is null)
		or a.mostRecentPriceHiStd<>c.mostRecentPriceHi or ( a.mostRecentPriceHiStd is null and c.mostRecentPriceHi is not null) or (a.mostRecentPriceHiStd is not null and c.mostRecentPriceHi is null)
		or a.mostRecentPriceCnt<>c.mostRecentPriceCnt or ( a.mostRecentPriceCnt is null and c.mostRecentPriceCnt is not null) or (a.mostRecentPriceCnt is not null and c.mostRecentPriceCnt is null)
		or a.mostRecentAuctionPriceLoStd <>c.mostRecentAuctionPrice or ( a.mostRecentAuctionPriceLoStd is null and c.mostRecentAuctionPrice is not null) or (a.mostRecentAuctionPriceLoStd is not null and c.mostRecentAuctionPrice is null)
		or a.mostRecentAuctionPriceHiStd <>c.mostRecentAuctionPriceHi or ( a.mostRecentAuctionPriceHiStd is null and c.mostRecentAuctionPriceHi is not null) or (a.mostRecentAuctionPriceHiStd is not null and c.mostRecentAuctionPrice is null)
		or a.mostRecentAuctionPriceCnt<>c.mostRecentAuctionPriceCnt or ( a.mostRecentAuctionPriceCnt is null and c.mostRecentAuctionPriceCnt is not null) or (a.mostRecentAuctionPriceCnt is not null and c.mostRecentAuctionPriceCnt is null)
	
exec dbo.oolog 'update2Price end'; 
end
 
