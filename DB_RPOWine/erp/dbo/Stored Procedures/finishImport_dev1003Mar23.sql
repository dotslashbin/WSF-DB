/*
use erp
finishImport_dev1003Mar22 20
finishImport 20
*/
CREATE proc finishImport_dev1003Mar23(@whN int) as
begin
--declare @whN int = 20
set noCount on
declare  @importStatus int = 0
begin try
	declare	@myWineName varchar(200), @Supplier varchar(max), @PurchaseQuantity varchar(max), @BottleSize	varchar(max), @PurchaseDate datetime, @deliveryDate datetime, @Price varchar(max), @Location varchar(max), @wineNFromMatch int, @myVintage varchar(max)
			, @supplierN int, @supplierUnknownN int, @BottleCount int, @BottleSizeML int, @BottleSizeN int, @bottleSize750N int, @pricePerBottle int, @wineN int
 
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
			
			begin try set @bottleCount = isNull(convert(int, @PurchaseQuantity),0) end try begin catch end catch
 
			--if @bottleCount > 0 and 1=isNumeric(@wineNFromMatch)
			if 1=isNumeric(@wineNFromMatch)
				begin
					select	@myWineName = dbo.normalizeName(@myWineName)
							, @Supplier = dbo.normalizeName(@supplier)
							, @location = dbo.normalizeName(@location)
					begin try set @pricePerBottle = isNull(convert(int, @Price), 0) end try begin catch end catch
					begin try set @BottleSizeML = convert(int, @BottleSize) end try begin catch end catch
					set @purchaseDate = case when @purchaseDate > @minSmallDateTime then @purchaseDate else @minSmallDateTime end
					set @deliveryDate = case when @deliveryDate > @minSmallDateTime then @deliveryDate else @minSmallDateTime end
 
					if @myVintage like '[12][0-9][0-9][0-9]' or @myVintage like '%N%V%'
						exec dbo.wineForVintage @wineNFromMatch, @myVintage, @newWineN = @wineN output				
					else
						set @wineN = @wineNFromMatch
 
					if 1= isNumeric(@wineN)
						begin
							exec dbo.calcWhToWine @whN, @wineN, 0
							--update whToWine set userComments = @location, bottleCount = -1 where whN = @whN and wineN = @wineN
							update whToWine set 
								userComments = @location
								, bottleCount = case when bottleCount = 0 then -1 else bottleCount end
								, isOfInterest = case when bottleCount = 0 then 1 else isOfInterest end
							where whN = @whN and wineN = @wineN
													
							if @myWineName like '%[^ ]%'
								begin
									if not exists (select * from whNameToWine where whN=@whN and myWineName = @myWineName and wineN = @wineN)
										begin
											insert into whNameToWine (whN, myWineName, wineN, isOld,dateLo, dateHi)
												(select @whN, @myWineName, @wineN, 0, @today, @today);
																						
											update whNameToWine
												set isOld = 1
												where whN=@whN and myWineName = @myWineName and wineN <> @wineN;
										end
									else
										begin
											with
											a as (select whN, myWineName, wineN
														, case when dateLo < @today then dateLo else  @today end dateLo
														, case when dateHi > @today then dateHi else @today end dateHi
													from whNameToWine 
													where whN=@whN and myWineName = @myWineName and wineN=@wineN     )											
											update b set 
													isOld = 0
													, dateLo = a.dateLo
													, dateHi = a.dateHi
												from a join 
													whNameToWine b
														on a.whN = b.whN and a.myWineName = b.myWineName and a.wineN = b.wineN
												where
													b.whN=@whN and b.myWineName = @myWineName
													and
														(
															b.isOld <> 0 
															or b.dateLo <> a.dateLo or not(a.dateLo is null and b.dateLo is null)
															or b.dateHi <> a.dateHi or not(a.dateHi is null and b.dateHi is null)
														)
										end									
 
									/*merge whNameToWine as aa
										using	(select @whN whN, @myWineName myWineName, @wineN wineN, @today dateLo, @today dateHi) as bb
										on aa.whN = bb.whN and aa.myWineName = bb.myWineName
									when matched then
										update set 
											  aa.wineN=bb.wineN
											, aa.dateLo = case when aa.dateLo < @today then aa.dateLo else @today end
											, aa.dateHi = case when aa.dateHi > @today then aa.dateHi else @today end
									when not matched by target then
										insert (whN, myWineName, wineN, dateLo, dateHi)
											values(bb.whN, bb.myWineName, bb.wineN, bb.dateLo, bb.dateHi);
									*/
									
								end
							    
							
							
							
							
							
							if @bottleCount > 0
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
 
 
 
