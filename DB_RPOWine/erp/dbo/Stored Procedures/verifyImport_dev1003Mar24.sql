/*
use erp
verifyImport_dev1003Mar24 20
*/
CREATE proc verifyImport_dev1003Mar24(@whN int) as
begin
--declare @whN int = 20
set noCount on
declare  @importStatus int = 0
--begin try
	declare	@myWineName varchar(200), @Supplier varchar(max), @PurchaseQuantity varchar(max), @BottleSize	varchar(max), @PurchaseDate datetime, @deliveryDate datetime, @Price varchar(max), @Location varchar(max), @wineNFromMatch int, @myVintage varchar(max)
			, @supplierN int, @supplierUnknownN int, @BottleCount int, @BottleSizeML int, @BottleSizeN int, @bottleSize750N int, @pricePerBottle int, @wineN int, @errors nvarchar(max)
 
	--declare @mp cursor; set @mp = cursor for select Supplier, PurchaseQuantity, BottleSize, PurchaseDate, DeliveryDate, Price, Location, wineN from uux for update of supplier; open @mp
	declare 
		@mp cursor
		, @sql nvarchar(max) =  N'Set @mpOut = cursor for Select MyWineName,Supplier, PurchaseQuantity, BottleSize, PurchaseDate, DeliveryDate, Price, Location, wineN, myVintage from transfer..userWines' + convert(nvarchar, @whN) + N'; open @mpOut';
	exec sp_executeSQL @sql, N'@mpOut cursor OUTPUT',  @mpOut = @mp OUTPUT
 
	declare @minSmallDateTime smallDateTime = convert(smallDateTime,0), @today date = getDate()
 
	select	@bottleSize750N = (select top 1 bottleSizeN from bottleSize where name like '%750%standard%')
			,@supplierUnknownN = (select top 1 supplierN from Supplier where whN = -1 and name like '%(%unknown%)%')
 
	while 1=1
		begin
			fetch next from @mp into @myWineName, @Supplier, @PurchaseQuantity, @BottleSize, @PurchaseDate, @DeliveryDate, @Price, @Location, @wineNFromMatch, @myVintage
			if @@fetch_status <> 0 break
			
			set @errors = ''
			
			begin try set @bottleCount = isNull(convert(int, @PurchaseQuantity),0) end try begin catch end catch
			if @purchaseQuantity like '%[^ ]%'
				begin
					if @bottleCount <1 set @errors += '<br>PurchaseQuantity must be a number greater than 0'					
				end
 
			--@PurchaseQuantity, @BottleSize, @PurchaseDate, @DeliveryDate, @Price, @Location
			
			/*
			begin try set @pricePerBottle = round(isNull(convert(float, @Price), 0), 0) end try begin catch end catch
			begin try set @BottleSizeML = convert(int, @BottleSize) end try begin catch end catch
			set @purchaseDate = case when @purchaseDate > @minSmallDateTime then @purchaseDate else @minSmallDateTime end
			set @deliveryDate = case when @deliveryDate > @minSmallDateTime then @deliveryDate else @minSmallDateTime end

			if @myVintage like '[12][0-9][0-9][0-9]' or @myVintage like '%N%V%'
			*/

	
			
			--if @errors not like '%[^ ]%' set @errors = null
			if @errors like '<br>' set @errors = substring(@errors, 5, 99999) else set @errors = null
			set @sql = 'update transfer..userwines'+ convert(nvarchar, @whN) + N' set errors = @err where current of @mp'
			exec sp_executeSQL @sql, N'@mp cursor, @err nvarchar(max)',  @mp, 'foo4'

		end
	close @mp
	deallocate @mp
 
	set @importStatus = 2
--end try
--begin catch
--	set @importStatus = 1
--end catch 
 
update wh set importStatus = @importStatus where whN = @whN
 
end 
 
