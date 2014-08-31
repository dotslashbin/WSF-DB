/*
use erp
finishImport_dev1003Mar18 20
*/
CREATE proc finishImport_dev1003Mar19 (@whN int) as
begin
--declare @whN int = 20
set noCount on
declare  @importStatus int = 0
begin try
	declare	@Supplier varchar(max), @Quantity varchar(max), @BottleSize	varchar(max), @PurchaseDate datetime, @deliveryDate datetime, @Price varchar(max), @Location varchar(max), @wineNFromMatch int, @myVintage varchar(max)
			, @supplierN int, @supplierUnknownN int, @BottleCount int, @BottleSizeML int, @BottleSizeN int, @bottleSize750N int, @pricePerBottle int, @wineN int

	--declare @mp cursor; set @mp = cursor for select Supplier, Quantity, BottleSize, PurchaseDate, DeliveryDate, Price, Location, wineN from uux for update of supplier; open @mp
	declare 
		@mp cursor
		, @sql nvarchar(max) =  N'Set @mpOut = cursor for Select Supplier, Quantity, BottleSize, PurchaseDate, DeliveryDate, Price, Location, wineN, myVintage from transfer..userWines' + convert(nvarchar, @whN) + N'; open @mpOut';
	exec sp_executeSQL @sql, N'@mpOut cursor OUTPUT',  @mpOut = @mp OUTPUT

	declare @minSmallDateTime smallDateTime = convert(smallDateTime,0)

	select	@bottleSize750N = (select top 1 bottleSizeN from bottleSize where name like '%750%standard%')
			,@supplierUnknownN = (select top 1 supplierN from Supplier where whN = -1 and name like '%(%unknown%)%')

	while 1=1
		begin
			fetch next from @mp into @Supplier, @Quantity, @BottleSize, @PurchaseDate, @DeliveryDate, @Price, @Location, @wineNFromMatch, @myVintage
			if @@fetch_status <> 0 break
			
			begin try set @bottleCount = isNull(convert(int, @quantity),0) end try begin catch end catch

			if @bottleCount > 0 and 1=isNumeric(@wineNFromMatch)
				begin
					select	@Supplier = dbo.normalizeName(@supplier)
							,@location = dbo.normalizeName(@location)
					begin try set @pricePerBottle = isNull(convert(int, @Price), 0) end try begin catch end catch
					begin try set @BottleSizeML = convert(int, @BottleSize) end try begin catch end catch
					set @purchaseDate = case when @purchaseDate > @minSmallDateTime then @purchaseDate else @minSmallDateTime end
					set @deliveryDate = case when @deliveryDate > @minSmallDateTime then @deliveryDate else @minSmallDateTime end

					if @myVintage is not null
						exec dbo.wineForVintage @wineNFromMatch, @myVintage, @newWineN = @wineN output				
					else
						set @wineN = @wineNFromMatch

					if 1= isNumeric(@wineN)
						begin
							exec dbo.calcWhToWine @whN, @wineN, 0
							update whToWine set userComments = @location, bottleCount = -1 where whN = @whN and wineN = @wineN
							
							if @supplier like '%[a-zA-Z0-9]%'
								select @supplierN = (select top 1 supplierN from Supplier where name = @supplier and whN in (@whN, -1)     )							
							else
								set @supplierN = @supplierUnknownN

							if @supplierN is null
								begin
									insert into Supplier(whN, name) select @whN, @supplier						
									set @supplierN = scope_identity()
								end				

							if @bottleSize is not null and @bottleSize like '%[0-9]%'
								select @bottleSizeN = (select top 1 bottleSizeN from bottleSize where (litres * 1000) = @BottleSizeML)
							else
								set @bottleSizeN = @bottleSize750N
								
							if not exists(select * from purchase where 
								whN = @whn
								and wineN = @wineN
								and supplierN = @supplierN
								and bottleSizeN = @bottleSizeN
								and (pricePerBottle = @pricePerBottle or (pricePerBottle is null and @pricePerBottle is null))
								and purchaseDate = @purchaseDate
								and deliveryDate = @deliveryDate
								and bottleCount = @bottleCount
								and bottleCountBought = @bottleCount     )
								begin
									insert into purchase(whN, wineN, supplierN, bottleSizeN, pricePerBottle, purchaseDate, deliveryDate, bottleCount, bottleCountBought)
										select @whN, @wineN, @supplierN, @bottleSizeN, @pricePerBottle, @purchaseDate, @deliveryDate, @bottleCount, @bottleCount
								end

							exec dbo.calcWhToWine @whN, @wineN, 1	
						end
					set @importStatus = 1				
				end						
		end
	close @mp
	deallocate @mp

	set @importStatus = 2
end try
begin catch
	set @importStatus = 1
end catch


update wh set importStatus = @importStatus where whN = @whN

end