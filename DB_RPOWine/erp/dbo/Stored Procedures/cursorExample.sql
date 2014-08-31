CREATE proc [dbo].[cursorExample]
as begin
 
declare @country varchar(max)
declare i cursor for select country from winename
open i
while 1=1
	begin
		fetch next from i into @country
		if @@fetch_status <> 0 break
		--xxxx
	end
close i
deallocate i
 
 
/*
	declare @sql nvarchar(max) ,@where nvarchar(max)='', @mp cursor
	if @finish=1 set @where=' where isDetail=1 '
	set @sql =  N'Set @mpOut = cursor for Select Id, Vintage, MyWineName,Supplier, PurchaseQuantity, BottleSize, PurchaseDate, DeliveryDate, Price, Location, wineN, myVintage, NoMatch from transfer..userWines' + convert(nvarchar, @whN) +@where+ N' order by id for update;
			 open @mpOut';
	exec sp_executeSQL @sql, N'@mpOut cursor OUTPUT',  @mpOut = @mp OUTPUT
*/
 end
 
 
 
 
 
 
 
 
 
 
 
