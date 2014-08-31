CREATE proc [dbo].verifyFinishImportTryDev(@whN int, @finish bit) as
begin
--declare @whN int=-20, @finish bit=1
set noCount on
declare  @importStatus int = 0,     @sql nvarchar(max),     @sq nvarchar(max)
 
--if @whN=20 return
set @whN=abs(@whN)
 
--declare @whN int = 20, @finish bit = 1
-- vUserWines has to exist before the overall tryCatch below, but doesn't have to be for thisTable since we redefilne and lock it where needed
set @whN=abs(@whN)
 
/* old - wasn't interlocked
if OBJECT_ID('vUserwines') is null
	begin
		begin try
			set @sq = 'create view vuserwines as select * from userwines_keep'
			exec (@sq)
		end try
		begin catch end catch
	end
else
	begin
		begin try
			set @sq = 'alter view vuserwines as select * from userwines_keep'
			exec (@sq)
		end try
		begin catch end catch
	end
*/ 
 
 
	declare	@id int, @vintage varchar(10), @myWineName varchar(200), @erpWineName varchar(200), @Supplier varchar(max), @PurchaseQuantity varchar(max), @BottleSize	varchar(max)
			,@purchaseDateRaw varchar(100), @deliveryDateRaw varChar(100),  @PurchaseDate datetime, @deliveryDate datetime, @Price varchar(max), @Location varchar(max), @wineNFromMatch int, @myVintage varchar(max), @noMatch bit
			, @supplierN int, @supplierUnknownN int, @BottleCount int, @BottleSizeL float, @BottleSizeN int, @bottleSize750N int, @pricePerBottle int, @wineN int
			, @errors nvarchar(max), @errorCnt int=0;
 
	declare @minSmallDateTime smallDateTime = convert(smallDateTime,0), @today date = getDate(), @original varchar(max), @sizeMultiplier int = 1000, @i int
			, @kludgeFlagForOnOrder dateTime=convert(datetime,'Dec 31 9999')
			, @nameMatchedNotVintage int = 0, @nameAndVintageMatched int = 0
			, @rowflag int = 0
			, @flag0 int = 1
			, @flag1 int = 7
			, @flag2 int = 4
			, @flagRed int = 5
			, @totalBottleCount int = 0
			, @count int
			, @autoMatched int = 0
			, @failedAutoVintage int = 0
			, @matchedCnt int = 0
			 
	--if @whN in (@wh1) set @rowFlag=1
 
	if not exists (select whN from transfer..importStatus where whN = @whN)
		insert into transfer..importStatus(whN) select @whN
	
 
 
 
 
 
-----------------------------------------------------------------------------------
-- Delete non-data rows
----------------------------------------------------------------------------------
if 0=@Finish
	begin
		set @sql='delete from transfer..userwines@whN@
			where
				((vintage is null or vintage not like ''%[^ ]%'') and (myWineName is null or myWineName not like ''%[^ ]%''))
				or vintage like ''%year%''
				or bottlesize like ''%optional%''
				or price like ''%dollar%''
				or purchaseDate like ''%mm%''
				or deliveryDate like ''%mm%''
				;
 
update transfer..userwines@whN@ set isDetail=1 where isDetail is null'
		set @sql=replace(@sql,'@whN@',@whN)
		begin try
		exec (@sql)
		end try
		begin catch end catch
	end
 
 
 
 
 
-----------------------------------------------------------------------------------
-- Normalize all fields
---------------------------------------------------------------------------------- 
 
 
 
 
 
 
 
 
	declare @where nvarchar(max)='', @mp cursor
	--declare @where nvarchar(max)=''
	--if @finish=1 set @where=' where isDetail=1 '
	if @finish=1 set @where=' where isDetail=0 '
	--set @sql =  N'Set @mp = cursor for Select Id, Vintage, MyWineName,Supplier, PurchaseQuantity, BottleSize, PurchaseDate, DeliveryDate, Price, Location, wineN, myVintage, NoMatch from transfer..userWines' + convert(nvarchar, @whN) +@where+ N' order by id for update; open @mp';
	set @sql =  N'Set @mp = cursor for Select Id, Vintage, MyWineName,Supplier, PurchaseQuantity, BottleSize, PurchaseDate, DeliveryDate, Price, Location, wineN, myVintage, NoMatch from transfer..userWines' + convert(nvarchar, @whN) +@where+ N' order by id; open @mp';
	exec sp_executeSQL @sql, N'@mp cursor OUTPUT',  @mp = @mp OUTPUT
	--declare mp cursor  for 		Select Id, Vintage, MyWineName,Supplier, PurchaseQuantity, BottleSize, PurchaseDate, DeliveryDate, Price, Location, wineN, myVintage, NoMatch 		from transfer..userWines20 order by id			for update;			 open mp;
	--set @sql =  N'Set @mpOut = cursor for Select Id, Vintage, MyWineName,Supplier, PurchaseQuantity, BottleSize, PurchaseDate, DeliveryDate, Price, Location, wineN, myVintage, NoMatch from transfer..userWines' + convert(nvarchar, @whN) +@where+ N' order by id for update; open @mpOut';
	--exec sp_executeSQL @sql, N'@mpOut cursor OUTPUT',  @mpOut = @mp OUTPUT
 
	select	@bottleSize750N = (select top 1 bottleSizeN from bottleSize where name like '%750%standard%')
			,@supplierUnknownN = (select top 1 supplierN from Supplier where whN = -1 and name like '%(%unknown%)%')
 
	if @finish = 0 
		begin
			--set @sql = replace(N'update transfer..userwines@ set rowFlag = null', '@', @whN)
			--exec sp_executeSQL @sql
 
			set @sql= replace(
				'update transfer..userWines@@ set 
					   rowFlag=null
					,  Vintage = dbo.nullNormalizeName(Vintage)
					,  myWineName = dbo.nullNormalizeName(myWineName)
					,  Supplier = dbo.nullNormalizeName(supplier)
					,  PurchaseQuantity = dbo.nullNormalizeName(PurchaseQuantity)
					,  BottleSize = dbo.nullNormalizeName(BottleSize)
					,  PurchaseDate = dbo.nullNormalizeName(PurchaseDate)
					,  DeliveryDate = dbo.nullNormalizeName(DeliveryDate)
					,  Price = dbo.nullNormalizeName(Price)
					, Location = dbo.nullNormalizeName(Location)'
				, '@@'
				, @whN     )
			exec sp_executeSQL @sql
		end
	
	while 1=1
		begin
			fetch next from @mp into @id, @vintage, @myWineName, @Supplier, @PurchaseQuantity, @BottleSize, @PurchaseDateRaw, @DeliveryDateRaw, @Price, @Location, @wineNFromMatch, @myVintage, @noMatch
			if @@fetch_status <> 0 break
			
			if (@vintage is null or @vintage not like '%[^ ]%') and (@myWineName is null or @myWineName not like '%[^ ]%')
				break
 
			set @errors = ''
			-----------------------------------------------------------------------------------
			-- Debug
			----------------------------------------------------------------------------------
			--if (@id%500)=0
				--set @errors='<BR>'+convert(nvarchar,@id)
			
						
			select	@myWineName = dbo.nullNormalizeName(@myWineName)
					, @Supplier = dbo.nullNormalizeName(@supplier)
					, @location = dbo.nullNormalizeName(@location)
					, @supplierN = null
					, @bottleSizeN = null
 
			if @myVintage  like '%[^ ]%' set @vintage = @myVintage
			set @vintage = ltrim(rtrim(isNull(@vintage,'')))
			set @original = isnull(@vintage,'')
			if @vintage = 'N.V.' set @vintage = 'NV'
			if @vintage like '%[nN][~a-zA-Z0-9][vV]%'  set @vintage = 'NV'
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
			
			if @purchaseQuantity like '%[123456789]%'
				begin
					set @purchaseQuantity = ltrim(rtrim(@purchaseQuantity))
					set @original = @purchaseQuantity
					if @purchaseQuantity like '%[()%' set @purchaseQuantity =replace(replace(@purchaseQuantity ,'(',''),')','')
					begin try set @bottleCount = isNull(convert(int, @PurchaseQuantity),0) end try begin catch set @bottleCount = null end catch
					--if @bottleCount is null or @bottleCount <1 set @errors += '<BR>('+@original+ ') isn''t a valid PurchaseQuantity.  It should be a whole number greater than 0'					
					if @bottleCount is null or @bottleCount <0 set @errors += '<BR>('+@original+ ') isn''t a valid PurchaseQuantity.  It should be a whole number greater than 0'					
				end
			else
				set @bottleCount = 0
 
			if @price like '%[123456789]%'
				begin
					set @pricePerBottle=dbo.priceToFloat(@price)
					if @pricePerBottle is null or @pricePerBottle <1 set @errors += '<BR>('+@price+ ') isn''t a valid Price.  It should be a number greater than 0.  It will be rounded to the nearest whole number.'	
				end
			else
				set @pricePerBottle = 0
			
			begin try
				set @purchaseDate = convert(dateTime, @purchaseDateRaw)
			end try
			begin catch
				set @purchaseDate = @minSmallDateTime
				set @errors += '<BR>('+ltrim(rtrim(@purchaseDateRaw))+ ') isn''t a valid PurchaseDate. '
			end catch
			
 
 
			if @deliveryDateRaw is null or @deliveryDateRaw  not like '%#%'
				begin
					-----------------------------------------------------------------------------------
					-- "on order", "future", "in the future", "not yet delivered", etc all go to "On Order" otherwise purchaseDate
					----------------------------------------------------------------------------------
					if @deliveryDateRaw like '%[0-z]%'
						set @deliveryDate=@kludgeFlagForOnOrder
					else
						set @deliveryDate=@minSmallDateTime
				end
			else
				begin
					begin try
						set @deliveryDate = convert(dateTime, @deliveryDateRaw)
					end try
					begin catch
						set @deliveryDate = @minSmallDateTime
						set @errors += '<BR>('+ltrim(rtrim(@deliveryDateRaw))+ ') isn''t a valid DeliveryDate.'
					end catch
				end
			
			set @purchaseDate = case when @purchaseDate > @minSmallDateTime then @purchaseDate else @minSmallDateTime end
			set @deliveryDate = case when @deliveryDate > @minSmallDateTime then @deliveryDate else @minSmallDateTime end
			
			if @purchaseDate = @minSmallDateTime  and @deliveryDate > @minSmallDateTime and @deliveryDate <> @kludgeFlagForOnOrder set @purchaseDate = @deliveryDate
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
						
		if len(@errors)>0 set @errorCnt +=1
		if @errors like '<BR>%' select @errors = replace(substring(@errors, 5, 99999), '<BR>', '<HR style ="background-color:OldLace; height:1px;"/>'), @importStatus=1 else set @errors = null
		------------------------------------------------------------------------------------------
		-- Switch between Verify and Finish
		------------------------------------------------------------------------------------------
		if @finish=0
			begin			
				--if @errors is null
					--begin
						-------------------------------------------------------------------------------------
						---- nullNormalize
						------------------------------------------------------------------------------------
						--set @sql= replace(
							--'update transfer..userWines@@ set myWineName = dbo.nullNormalizeName(myWineName), Supplier = dbo.nullNormalizeName(supplier), location = dbo.nullNormalizeName(location)'
							--, '@@'
							--, @whN     )
						--exec sp_executeSQL @sql
						-----------------------------------------------------------------------------------
						-- Merge identical entries
						----------------------------------------------------------------------------------
						--@@@
					--end
				--else
				if @errors is not null
					begin
						-----------------------------------------------------------------------------------
						-- Errors
						----------------------------------------------------------------------------------
						set @sql = 'update transfer..userwines'+ convert(nvarchar, @whN) + N' set errors = @err where id = @id'
						exec sp_executeSQL @sql, N'@id int, @err nvarchar(max)',  @id, @errors
					
						--update transfer..userwines20 set errors=@errors where current of mp					
						--set @sql = 'update transfer..userwines'+ convert(nvarchar, @whN) + N' set errors = @err where current of @mp'
						--exec sp_executeSQL @sql, N'@mp cursor, @err nvarchar(max)',  @mp, @errors
					
					
					
					
					
					
					
					
					
--					
--					
					
					end
			end
		else
			------------------------------------------------------------------------------------------
			-- Finish
			------------------------------------------------------------------------------------------		
			select @wineN = null
			if @errors is null and isnull(@noMatch, 0) = 0 and (1=isNumeric(@wineNFromMatch))
				begin
					if 1 = isNumeric(@wineNFromMatch)
						exec dbo.wineForVintage @wineNFromMatch, @Vintage, @newWineN = @wineN output				
/*						begin
							if @myVintage like '%[^ ]%'
								exec dbo.wineForVintage @wineNFromMatch, @myVintage, @newWineN = @wineN output				
							else
								set @wineN = @wineNFromMatch
						end
*/					 
					if 1= isNumeric(@wineN)
						begin
							exec dbo.calcWhToWine @whN, @wineN, 0
							update whToWine set 
								  --userComments = case when @location like '%[^ ]%' then @location else null end
								  userComments =	case when @location like '%[^ ]%' 
													 then	case when userComments like '%[^ ]'
																then userComments+'; '+@location 
																else @location
															end
													 else userComments 
												end
								, isOfInterest = case when isOfInterestX = 1 then isOfInterest else 1 end
								, isOfInterestX = 1
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
 
		end
	close @mp
	deallocate @mp
 
	if @errorCnt=0
		begin
			if @finish = 0
				begin
					------------------------------------------------------------------------------------------
					-- Fixup the rowFlags and fill in alternate vintages
					------------------------------------------------------------------------------------------	
					declare @j int
					exec dbo.gatherImport @whN
					exec dbo.applyImportMap @whN,null
				end
			else
				begin
					exec dbo.summarizeBottleLocations @whN, null
					
					set @sql = N'
					update transfer..importStatus 
						set
							  [matched] = (select count(*) from transfer..userwines@@ where 1 = isNumeric(wineN) and 0=isNull(isdetail,0))
							  , autoMatched =0	-- @autoMatched
							, noMatchPossible = (select count(*) from transfer..userwines@@ where 1 = noMatch and 0=isNull(isdetail,0))
							, failedAutoVintage = 0	--@failedAutoVintage
							, waitingToBeMatched = (select count(*) from transfer..userwines@@ where 0 = isNumeric(wineN) and 0=isNull(isdetail,0))
							, status = @importStatus
						where whN=@@;
						delete from transfer..userwines@@ where 1 = isNumeric(wineN)'
					set @sql = replace(@sql, '@@', @whN)
					exec sp_executeSQL @sql, N'@importStatus int', @importStatus
					
					/*set @sql = N'delete from transfer..userwines@@ where 1 = isNumeric(wineN)'
					set @sql = replace(@sql, '@@', @whN)
					exec sp_executeSQL @sql
					*/
				end
		end
 
	if @importStatus = 0 set @importStatus = 2
 
Done: 
if @errorCnt>0 or @importStatus=1
	begin try
		set @importStatus=1
		set @sql=replace('update transfer..userwines@whN@ set isDetail=0 where isNull(len(errors),0)>0','@whN@',@whN)
		exec (@sql)
	end try 
	begin catch end catch
 
update wh set importStatus = @importStatus where whN = @whN
update transfer..importStatus set status = @importStatus where whN = @whN
 
end 
