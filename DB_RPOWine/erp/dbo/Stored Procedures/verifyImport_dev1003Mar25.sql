/*
use erp
verifyImport_dev1003Mar24 20
*/
--alter proc verifyImport(@whN int) as
CREATE proc verifyImport_dev1003Mar25(@whN int) as
begin
--declare @whN int = 20
set noCount on
declare  @importStatus int = 0
begin try
	declare	@myWineName varchar(200), @Supplier varchar(max), @PurchaseQuantity varchar(max), @BottleSize	varchar(max), @PurchaseDate datetime, @deliveryDate datetime, @Price varchar(max), @Location varchar(max), @wineNFromMatch int, @myVintage varchar(max)
			, @supplierN int, @supplierUnknownN int, @BottleCount int, @BottleSizeL float, @BottleSizeN int, @bottleSize750N int, @pricePerBottle int, @wineN int, @errors nvarchar(max)

	declare @minSmallDateTime smallDateTime = convert(smallDateTime,0), @today date = getDate(), @original varchar(max), @sizeMultiplier int = 1000
 
	declare 
		@mp cursor
		, @sql nvarchar(max) =  N'Set @mpOut = cursor for Select MyWineName,Supplier, PurchaseQuantity, BottleSize, PurchaseDate, DeliveryDate, Price, Location, wineN, myVintage from transfer..userWines' + convert(nvarchar, @whN) + N'; open @mpOut';
	exec sp_executeSQL @sql, N'@mpOut cursor OUTPUT',  @mpOut = @mp OUTPUT
 
	select	@bottleSize750N = (select top 1 bottleSizeN from bottleSize where name like '%750%standard%')
			,@supplierUnknownN = (select top 1 supplierN from Supplier where whN = -1 and name like '%(%unknown%)%')
 
	while 1=1
		begin
			fetch next from @mp into @myWineName, @Supplier, @PurchaseQuantity, @BottleSize, @PurchaseDate, @DeliveryDate, @Price, @Location, @wineNFromMatch, @myVintage
			if @@fetch_status <> 0 break
			
			set @errors = ''
						
			if @purchaseQuantity like '%[^ ]%'
				begin
					set @original = @purchaseQuantity
					begin try set @bottleCount = isNull(convert(int, @PurchaseQuantity),0) end try begin catch set @bottleCount = null end catch
					if @bottleCount is null or @bottleCount <1 set @errors += '<br><br>PurchaseQuantity '+@original+ 'isn''t valid.  It should be an whole number greater than 0'					
				end
			else
				set @bottleCount = 0
 
			if @price like '%[^ ]%'
				begin
					set @original = @price
					if @price like '%$%' and @price not like '%$%$%' set @price = replace(@price, '$','')
					if @price like '%US$%' and @price not like '%US$%US$%' set @price = replace(@price, 'US$','')
					begin try set @pricePerBottle = round(isNull(convert(float, @Price), 0), 0) end try begin catch end catch
					if @bottleCount is null or @bottleCount <1 set @errors += '<br><br>Price '+@original+ ' isn''t valid.  It should be a number greater than 0.  It will be rounded to the nearest whole number.'	
				end
			else
				set @bottleCount = 0

			
			
			set @purchaseDate = case when @purchaseDate > @minSmallDateTime then @purchaseDate else @minSmallDateTime end
			set @deliveryDate = case when @deliveryDate > @minSmallDateTime then @deliveryDate else @minSmallDateTime end
			
			if @purchaseDate = @minSmallDateTime  and @deliveryDate > @minSmallDateTime set @purchaseDate = @deliveryDate
			if @deliveryDate = @minSmallDateTime  and @purchaseDate > @minSmallDateTime set @deliveryDate = @purchaseDate
			
			if @purchaseDate > @today set @errors += '<br><br>PruchaseDate '+convert(varchar,@purchaseDate)+ ' is in the future'
			if @deliveryDate < @purchaseDate set @errors += '<br><br>DeliveryDate '+convert(varchar,@purchaseDate)+ ' is earlier than PurchaseDate'
			
			if @BottleSize like '%[^ ]%' 
				begin
					set @original = @bottleSize
					set @sizeMultiplier = 1000
					if @bottleSize like '%ml%' and not @bottleSize like '%ml%%ml%' 
							set @bottleSize = replace(@bottleSize, 'ml', '')
					else if @bottleSize like'%l%' and @bottleSize not like '%L%%L'
						begin
							set @sizeMultiplier = 1
							set @bottleSize = replace(@bottleSize, 'L', '')
						end
				
					begin try
						set @bottleSizeL = convert(float, @bottleSize) / @sizeMultiplier
					
						--select @bottleSizeN = (select top 1 bottleSizeN from bottleSize where (litres * 1000) = @BottleSizeML)
						
						select @bottlesizeN = bottleSizeN from
							(select row_number() over(partition by litres order by bottleSizeN) ii, * from erp..bottleSize) a
							where litres = @bottleSizeL and ii = 1

					end try begin catch 
						set @bottleSizeN = null 
					end catch
				
					if @bottleSizeN is null set @errors += '<br><br>BottleSize '+@original+' isn''t valid.  Standard sizes (in ml) include 375, 750, 1500, 3000'
				end
			else set @bottleSizeN = @bottleSize750N
						
			--@PurchaseQuantity, @BottleSize, @PurchaseDate, @DeliveryDate, @Price
			/*
			begin try set @pricePerBottle = round(isNull(convert(float, @Price), 0), 0) end try begin catch end catch
			begin try set @BottleSizeML = convert(int, @BottleSize) end try begin catch end catch
			set @purchaseDate = case when @purchaseDate > @minSmallDateTime then @purchaseDate else @minSmallDateTime end
			set @deliveryDate = case when @deliveryDate > @minSmallDateTime then @deliveryDate else @minSmallDateTime end

			if @myVintage like '[12][0-9][0-9][0-9]' or @myVintage like '%N%V%'
			*/

	
			
			--if @errors not like '%[^ ]%' set @errors = null
			if @errors like '<br><br>%' select @errors = substring(@errors, 9, 99999), @importStatus=-1 else set @errors = null
			set @sql = 'update transfer..userwines'+ convert(nvarchar, @whN) + N' set errors = @err where current of @mp'
			exec sp_executeSQL @sql, N'@mp cursor, @err nvarchar(max)',  @mp, @errors

		end
	close @mp
	deallocate @mp
 
	if @importStatus = 0 set @importStatus = 2
end try
begin catch
	set @importStatus = 1
end catch 
 
update wh set importStatus = @importStatus where whN = @whN
 
end 