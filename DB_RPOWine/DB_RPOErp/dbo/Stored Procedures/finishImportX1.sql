/*
finishImport 20
*/
CREATE proc finishImportX1(@whN int) as
begin
/*
--declare @whN int = 20
set noCount on
declare	@Supplier varchar(max), @Quantity varchar(max), @BottleSize	varchar(max), @PurchaseDate datetime, @deliveryDate datetime, @Price varchar(max), @Location varchar(max), @wineN int
		, @supplierN int, @supplierUnknownN int, @BottleCount int, @BottleSizeML int, @BottleSizeN int, @bottleSize750N int, @pricePerBottle int
 
--declare @mp cursor; set @mp = cursor for select Supplier, Quantity, BottleSize, PurchaseDate, DeliveryDate, Price, Location, wineN from userwines20
declare 
	@mp cursor
	, @sql nvarchar(max) =  N'Set @mpOut = cursor for Select Supplier, Quantity, BottleSize, PurchaseDate, DeliveryDate, Price, Location, wineN from transfer..userWines' + convert(nvarchar, @whN) + N'; open @mpOut'
exec sp_executeSQL @sql
	, N'@mpOut cursor OUTPUT'
	, @mpOut = @mp OUTPUT
 
declare @minSmallDateTime smallDateTime = convert(smallDateTime,0)
 
select	@bottleSize750N = (select top 1 bottleSizeN from bottleSize where name like '%750%standard%')
		,@supplierUnknownN = (select top 1 supplierN from Supplier where whN = -1 and name like '%(%unknown%)%')
 
--exec ('set @mp = cursor for select Supplier, Quantity, BottleSize, PurchaseDate, DeliveryDate, Price, Location, wineN from transfer..userwines' + convert(varchar, @whN))
--open @mp
while 1=1
	begin
		fetch next from @mp into @Supplier, @Quantity, @BottleSize, @PurchaseDate, @DeliveryDate, @Price, @Location, @wineN
		if @@fetch_status <> 0 break
		
		select	@Supplier = dbo.normalizeName(@supplier)
				,@location = dbo.normalizeName(@location)
		begin try set @bottleCount = isNull(convert(int, @quantity),0) end try begin catch end catch
		begin try set @pricePerBottle = convert(int, @Price) end try begin catch end catch
		begin try set @BottleSizeML = convert(int, @BottleSize) end try begin catch end catch
		set @purchaseDate = case when @purchaseDate > @minSmallDateTime then @purchaseDate else @minSmallDateTime end
		set @deliveryDate = case when @deliveryDate > @minSmallDateTime then @deliveryDate else @minSmallDateTime end
 
		exec dbo.calcWhToWine @whN, @wineN, 0
		
		update whToWine set userComments = @location, bottleCount = -1 	where whN = @whN and wineN = @wineN
		
		--select wineN, bottleCount from whTowine where whN=20
		
		if  @BottleCount > 0
			begin
				if @supplier like '%[a-zA-Z0-9]%'
					select @supplierN = (select top 1 supplierN from Supplier where name = @supplier and whN in (@whN, -1)     )							
				else
					set @supplierN = @supplierUnknownN
 
				if @supplierN is null
					begin
						insert into Supplier(whN, name) select @whN, @supplier						
						set @supplierN = scope_identity()
					end				
			end
 
		if @bottleSize is not null and @bottleSize like '%[0-9]%'
			select @bottleSizeN = (select top 1 bottleSizeN from bottleSize where (litres * 1000) = @BottleSizeML)
		else
			set @bottleSizeN = @bottleSize750N
			
		if @bottleCount > 0 and @wineN is not null
			begin
				insert into purchase(whN, wineN, supplierN, bottleSizeN, pricePerBottle, purchaseDate, deliveryDate, bottleCount, bottleCountBought)
					select @whN, @wineN, @supplierN, @bottleSizeN, @pricePerBottle, @purchaseDate, @deliveryDate, @bottleCount, @bottleCount
			end
	end
close @mp
deallocate @mp
*/ 
exec dbo.calcWhToWine @whN, null, 1	
 
end
