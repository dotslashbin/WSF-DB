CREATE proc verifyFinishImport_before1004Apr06 (@whN int, @finish bit) as
--ALTER proc verifyFinishImport_dev1004Apr04 (@whN int, @finish bit) as
begin
--declare @whN int = 20, @finish bit = 1
set noCount on
declare  @importStatus int = 0
begin try
	declare	@id int, @vintage varchar(10), @myWineName varchar(200), @erpWineName varchar(200), @Supplier varchar(max), @PurchaseQuantity varchar(max), @BottleSize	varchar(max), @PurchaseDate datetime, @deliveryDate datetime, @Price varchar(max), @Location varchar(max), @wineNFromMatch int, @myVintage varchar(max), @noMatch bit
			, @supplierN int, @supplierUnknownN int, @BottleCount int, @BottleSizeL float, @BottleSizeN int, @bottleSize750N int, @pricePerBottle int, @wineN int, @errors nvarchar(max)
 
	declare @minSmallDateTime smallDateTime = convert(smallDateTime,0), @today date = getDate(), @original varchar(max), @sizeMultiplier int = 1000, @i int
			, @nameMatchedNotVintage int = 0, @nameAndVintageMatched int = 0, @priorMyWineName varchar(200) = null
			, @rowflag int = 0
			, @flag1 int = 7
			, @flag2 int = 4
			, @repCount int = 0
			, @totalBottleCount int = 0
			, @groupVinn int = null, @groupWineN int = null
			, @count int
			, @failedAutoVintage int = 0
			, @matchedCnt int = 0
			 
	if not exists (select whN from transfer..importStatus where whN = @whN)
		insert into transfer..importStatus(whN) select @whN
	
	declare 
		@mp cursor
		, @sql nvarchar(max) =  N'Set @mpOut = cursor for Select Id, Vintage, MyWineName,Supplier, PurchaseQuantity, BottleSize, PurchaseDate, DeliveryDate, Price, Location, wineN, myVintage, NoMatch from transfer..userWines' + convert(nvarchar, @whN) + N' order by id for update; open @mpOut';
	exec sp_executeSQL @sql, N'@mpOut cursor OUTPUT',  @mpOut = @mp OUTPUT
 
	select	@bottleSize750N = (select top 1 bottleSizeN from bottleSize where name like '%750%standard%')
			,@supplierUnknownN = (select top 1 supplierN from Supplier where whN = -1 and name like '%(%unknown%)%')
 
	if @finish = 0 
		begin
			set @sql = replace(N'update transfer..userwines@ set rowFlag = null', '@', @whN)
			exec sp_executeSQL @sql
		end
	
	while 1=1
		begin
			fetch next from @mp into @id, @vintage, @myWineName, @Supplier, @PurchaseQuantity, @BottleSize, @PurchaseDate, @DeliveryDate, @Price, @Location, @wineNFromMatch, @myVintage, @noMatch
			if @@fetch_status <> 0 break
			
			set @errors = ''
						
			select	@myWineName = dbo.normalizeName(@myWineName)
					, @Supplier = dbo.normalizeName(@supplier)
					, @location = dbo.normalizeName(@location)
					, @supplierN = null
					, @bottleSizeN = null
 
			if @myVintage  like '%[^ ]%' set @vintage = @myVintage
			set @vintage = ltrim(rtrim(isNull(@vintage,'')))
			set @original = isnull(@vintage,'')
			if @vintage = 'N.V.' set @vintage = 'NV'
			if  @vintage <> 'NV'
				begin
					if @vintage like '%[^ ]%'
						begin
							begin try set @i = convert(int, @vintage) end try begin catch set @i = null end catch
							if @i is null or @i not between 1501 and 2100
								set @errors += '<BR>('+@original+ ') isn''t a valid Vintage.  It should be either NV or a 4 digit number between 1501 and 2100'
						end
					else
						set @errors += '<BR>Vintage must be either NV or a 4 digit number between 1501 and 2100'
				end
			
			if @myWineName is null or @myWineName  not like '%[^ ]%'
				set @errors += '<BR>MyWineName must contain text idendifying your wine'
			
			if @purchaseQuantity like '%[^ ]%'
				begin
					set @purchaseQuantity = ltrim(rtrim(@purchaseQuantity))
					set @original = @purchaseQuantity
					begin try set @bottleCount = isNull(convert(int, @PurchaseQuantity),0) end try begin catch set @bottleCount = null end catch
					if @bottleCount is null or @bottleCount <1 set @errors += '<BR>('+@original+ ') isn''t a valid PurchaseQuantity.  It should be a whole number greater than 0'					
				end
			else
				set @bottleCount = 0
 
			if @price like '%[^ ]%'
				begin
					set @price = ltrim(rtrim(@price))
					set @original = @price
					if @price like '%$%' and @price not like '%$%$%' set @price = replace(@price, '$','')
					if @price like '%US$%' and @price not like '%US$%US$%' set @price = replace(@price, 'US$','')
					begin try set @pricePerBottle = round(isNull(convert(float, @Price), 0), 0) end try begin catch end catch
					if @pricePerBottle is null or @pricePerBottle <1 set @errors += '<BR>('+@original+ ') isn''t a valid Price.  It should be a number greater than 0.  It will be rounded to the nearest whole number.'	
				end
			else
				set @pricePerBottle = 0
			
			set @purchaseDate = case when @purchaseDate > @minSmallDateTime then @purchaseDate else @minSmallDateTime end
			set @deliveryDate = case when @deliveryDate > @minSmallDateTime then @deliveryDate else @minSmallDateTime end
			
			if @purchaseDate = @minSmallDateTime  and @deliveryDate > @minSmallDateTime set @purchaseDate = @deliveryDate
			if @deliveryDate = @minSmallDateTime  and @purchaseDate > @minSmallDateTime set @deliveryDate = @purchaseDate
			
			if @purchaseDate > @today set @errors += '<BR>('+convert(varchar,@purchaseDate)+ ') isn''t a valid PruchaseDate - it''s is in the future'
			if @deliveryDate < @purchaseDate set @errors += '<BR>('+convert(varchar,@purchaseDate)+ ') isn''t a valid DeliveryDate - it''s earlier than PurchaseDate'
			
			if @BottleSize like '%[^ ]%' 
				begin
					set @bottleSize = ltrim(rtrim(@bottleSize))
					set @original = @bottleSize
					set @sizeMultiplier = 1000
					if @bottleSize like '%ml%' and not @bottleSize like '%ml%%ml%' 
							set @bottleSize = replace(@bottleSize, 'ml', '')
					else if @bottleSize like'%L%' and @bottleSize not like '%L%%L'
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
				
					if @bottleSizeN is null set @errors += '<BR>('+@original+') isn''t a valid BottleSize.  Standard sizes (in ml) include 375, 750, 1500, 3000'
				end
			else set @bottleSizeN = @bottleSize750N
						
		if @errors like '<BR>%' select @errors = replace(substring(@errors, 5, 99999), '<BR>', '<HR style ="background-color:OldLace; height:1px;"/>'), @importStatus=1 else set @errors = null
		------------------------------------------------------------------------------------------
		-- Switch between Verify and Finish
		------------------------------------------------------------------------------------------
		if @finish=0
			begin			
				if @errors is null
					begin
						------------------------------------------------------------------------------------------
						-- Reuse Prior Name Matches
						------------------------------------------------------------------------------------------
						set @wineN = null
						if @myWineName = @priorMyWineName
							begin
								if @repCount = 0 set @rowFlag = case when @rowFlag = @flag1 then @flag2 else @flag1 end
								set @repCount += 1
 
								set @sql = 'update transfer..userwines'+ convert(nvarchar, @whN) + N' set rowFlag = @rowFlag where id = @id'
								exec sp_executeSQL @sql, N'@id int, @rowFlag int',  @id, @rowFlag								
							end
						else
							set @repCount = 0
					end
				else
					begin
						set @sql = 'update transfer..userwines'+ convert(nvarchar, @whN) + N' set errors = @err where id = @id'
						exec sp_executeSQL @sql, N'@id int, @err nvarchar(max)',  @id, @errors
					end
			end
		else
			------------------------------------------------------------------------------------------
			-- Finish
			------------------------------------------------------------------------------------------		
			select @wineN = null
			--if @myWineName <> @priorMyWineName or not (@myWineName is null and @priorMyWineName is null)
			--	select @groupWineN = null, @groupVinn = null
			if @myWineName  <> @priorMyWineName or (@myWineName is null and @priorMyWineName is not null) or (@priorMyWineName is null and @myWineName is not null) 
				select @groupWineN = null, @groupVinn = null
			if @errors is null and isnull(@noMatch, 0) = 0 and (1=isNumeric(@wineNFromMatch) or @groupWineN is not null)
				begin
					if 1 = isNumeric(@wineNFromMatch)
						begin
							if @myVintage like '%[^ ]%'
								exec dbo.wineForVintage @wineNFromMatch, @myVintage, @newWineN = @wineN output				
							else
								set @wineN = @wineNFromMatch
						end
					else
						begin
							if @groupWineN is not null
								begin
									select @wineN = min(wineN), @count = count(*) from wine where activeVinn = @groupVinn and vintage = @vintage
									if @count = 1
										begin
											set @erpWineName = @vintage + ' ' + dbo.getFullWineNamePlus(@wineN)
											set @sql = 'update transfer..userwines'+ convert(nvarchar, @whN) + N' set wineN = @wineN, erpWineName = @erpWineName where id = @id'
											exec sp_executeSQL @sql, N'@id int, @wineN int, @erpWineName varchar(200)',  @id, @wineN, @erpWineName
 
										end
									else
										select @wineN = null, @failedAutoVintage += 1
										
								end
						end
					 
					if 1= isNumeric(@wineN)
						begin
							exec dbo.calcWhToWine @whN, @wineN, 0
							update whToWine set 
								userComments = case when @location like '%[^ ]%' then @location else null end
							where whN = @whN and wineN = @wineN
													
							if @myWineName like '%[^ ]%'
								begin
									if not exists (select * from whNameToWine where whN=@whN and myWineName = @myWineName and vintage = @vintage and wineN = @wineN)
										begin
											insert into whNameToWine (whN, myWineName, vintage, wineN, isOld,dateLo, dateHi)
												(select @whN, @myWineName, @vintage, @wineN, 0, @today, @today);
																						
											update whNameToWine
												set isOld = 1
												where whN=@whN and myWineName = @myWineName and vintage = @vintage and wineN <> @wineN;
										end
									else
										begin
											with
											a as (select whN, myWineName, vintage, wineN
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
														on a.whN = b.whN and a.myWineName = b.myWineName and a.vintage = b.vintage and a.wineN = b.wineN
												where
													b.whN=@whN and b.myWineName = @myWineName and b.vintage = @vintage
													and
														(
															b.isOld <> 0 
															or b.dateLo <> a.dateLo or not(a.dateLo is null and b.dateLo is null)
															or b.dateHi <> a.dateHi or not(a.dateHi is null and b.dateHi is null)
														)
										end									 
								end
							
							if @bottleCount > 0
								begin
									set @totalBottleCount += @bottleCount
									if @supplier like '%[a-zA-Z0-9]%'
										select @supplierN = (select top 1 supplierN from Supplier where name = @supplier and whN in (@whN, -1)     )							
									else
										set @supplierN = @supplierUnknownN
		 
									if @supplierN is null
										begin
											insert into Supplier(whN, name) select @whN, @supplier						
											set @supplierN = scope_identity()
										end				
		 
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
				end
 
			------------------------------------------------------------------------------------------
			-- GroupVinn
			------------------------------------------------------------------------------------------
			if 0 = isNull(@noMatch, 0)
				begin
					if 1 = isNumeric(@wineN) and @wineN = @wineNFromMatch
						begin
							select @groupWineN = @wineN
							select @groupVinn = activeVinn from wine where wineN = @groupWineN
						end
					/*else
						begin
							if (@priorMyWineName is null or @priorMyWineName <> @myWineName)
								select @groupWineN = null, @groupVinn = null
						end
					*/
				end
 
			select @priorMyWineName = @myWineName
		end
	close @mp
	deallocate @mp
 
	if @finish = 0
		begin
			------------------------------------------------------------------------------------------
			-- Fixup the rowFlags and fill in alternate vintages
			------------------------------------------------------------------------------------------	
		set @sql = replace(
					'with a as (select row_number() over(order by id) ii, * from transfer..userwines@@) update a set a.rowFlag = b.rowFlag from a join a b on a.ii = b.ii-1 and a.myWineName = b.myWineName and a.rowFlag is null'
					, '@@', @whN     )
		exec sp_executeSQL @sql
		end
	else
		begin
			/*set @sql = N'select @cnt = (select count(*) from transfer..userwines@@ where 1 = isNumeric(wineN))'
			set @sql = replace(@sql, '@@', @whN)
			exec sp_executeSQL @sql, N'@cnt int OUTPUT', @cnt = @matchedCnt OUTPUT
			*/
			
			exec dbo.summarizeBottleLocations @whN, null
			
			set @sql = N'
			update transfer..importStatus 
				set
					  [matched] = (select count(*) from transfer..userwines@@ where 1 = isNumeric(wineN))
					, noMatchPossible = (select count(*) from transfer..userwines@@ where 1 = noMatch)
					, failedAutoVintage = @failedAutoVintage
					, waitingToBeMatched = (select count(*) from transfer..userwines@@ where 0 = isNumeric(wineN))
					, status = @importStatus
				where whN=@@;
				delete from transfer..userwines@@ where 1 = isNumeric(wineN)'
			set @sql = replace(@sql, '@@', @whN)
			exec sp_executeSQL @sql, N'@failedAutoVintage int, @importStatus int', @failedAutoVintage, @importStatus
			
			/*set @sql = N'delete from transfer..userwines@@ where 1 = isNumeric(wineN)'
			set @sql = replace(@sql, '@@', @whN)
			exec sp_executeSQL @sql
			*/
		end
 
	if @importStatus = 0 set @importStatus = 2
end try
begin catch
	set @importStatus = -1
end catch 
 
 
update wh set importStatus = @importStatus where whN = @whN
update transfer..importStatus set status = @importStatus where whN = @whN
 
end 
/*
zapUser 20
 
 
 use erp
verifyFinishImport_dev1004Apr04 20,1
verifyFinishImport 20,1
select id, errors, vintage, myWineName, erpWineName, wineN, rowFlag from transfer..userwines20 order by id
update transfer..userwines20 set vintage = 'NV' where id = 1
update transfer..userwines20 set vintage = '20022' where id = 2
select * from transfer..importStatus where whN=20
*/
 
 
 
 
