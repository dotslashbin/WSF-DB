--use erp
--ALTER proc verifyFinishImportX(@whN int, @finish bit) as
CREATE  proc verifyFinishImport_dev1003Mar30B(@whN int, @finish bit) as
begin
--declare @whN int = 20, @finish bit = 0
set noCount on
declare  @importStatus int = 0
--begin try
	declare	@id int, @vintage varchar(10), @myWineName varchar(200), @erpWineName varchar(200), @Supplier varchar(max), @PurchaseQuantity varchar(max), @BottleSize	varchar(max), @PurchaseDate datetime, @deliveryDate datetime, @Price varchar(max), @Location varchar(max), @wineNFromMatch int, @myVintage varchar(max)
			, @supplierN int, @supplierUnknownN int, @BottleCount int, @BottleSizeL float, @BottleSizeN int, @bottleSize750N int, @pricePerBottle int, @wineN int, @errors nvarchar(max)
 
	declare @minSmallDateTime smallDateTime = convert(smallDateTime,0), @today date = getDate(), @original varchar(max), @sizeMultiplier int = 1000, @i int
			, @nameMatchedNotVintage int = 0, @nameAndVintageMatched int = 0, @priorMyWineName varchar(200) = null
			, @rowflag int = 0
			, @flag1 int = 1
			, @flag2 int = 2
			, @repCount int = 0
			, @totalBottleCount int = 0
			 
	if not exists (select whN from transfer..importStatus where whN = @whN)
		insert into transfer..importStatus(whN) select @whN
	
	declare 
		@mp cursor
		, @sql nvarchar(max) =  N'Set @mpOut = cursor for Select Id, Vintage, MyWineName,Supplier, PurchaseQuantity, BottleSize, PurchaseDate, DeliveryDate, Price, Location, wineN, myVintage from transfer..userWines' + convert(nvarchar, @whN) + N' order by id for update; open @mpOut';
	exec sp_executeSQL @sql, N'@mpOut cursor OUTPUT',  @mpOut = @mp OUTPUT
 
	select	@bottleSize750N = (select top 1 bottleSizeN from bottleSize where name like '%750%standard%')
			,@supplierUnknownN = (select top 1 supplierN from Supplier where whN = -1 and name like '%(%unknown%)%')
 
	update transfer..userwines20 set rowFlag = null
	
	while 1=1
		begin
			fetch next from @mp into @id, @vintage, @myWineName, @Supplier, @PurchaseQuantity, @BottleSize, @PurchaseDate, @DeliveryDate, @Price, @Location, @wineNFromMatch, @myVintage
			if @@fetch_status <> 0 break
			
			set @errors = ''
						
			select	@myWineName = dbo.normalizeName(@myWineName)
					, @Supplier = dbo.normalizeName(@supplier)
					, @location = dbo.normalizeName(@location)
					, @supplierN = null
					, @bottleSizeN = null
 
			if @vintage like '%[^ ]%' or @myVintage  like '%[^ ]%'
				begin
					if @myVintage  like '%[^ ]%' set @vintage = @myVintage
					set @vintage = ltrim(rtrim(@vintage))
					set @original = isnull(@vintage,'')
					if @vintage = 'N.V.' set @vintage = 'NV'
					if  @vintage <> 'NV'
						begin
							begin try set @i = convert(int, @vintage) end try begin catch set @i = null end catch
							if @i is null or @i not between 1501 and 2100
								set @errors += '<BR>('+@original+ ') isn''t a valid Vintage.  It should be either NV or a 4 digit number between 1501 and 2100'
						end
				end
			
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

								--set @sql = 'update transfer..userwines'+ convert(nvarchar, @whN) + N' set rowFlag = @rowFlag where current of @mp'
								--exec sp_executeSQL @sql, N'@mp cursor for update, @rowFlag int',  @mp, @rowFlag
								
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
			if @errors is null and 1=isNumeric(@wineNFromMatch)				
				begin
					if @myVintage like '%[^ ]%'
						exec dbo.wineForVintage @wineNFromMatch, @myVintage, @newWineN = @wineN output				
					else
						set @wineN = @wineNFromMatch
 
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
				
					set @sql = 'delete from transfer..userwines'+ convert(nvarchar, @whN) + N' where wineN is not null'
					exec sp_executeSQL @sql

				end						
			------------------------------------------------------------------------------------------
			-- 
			------------------------------------------------------------------------------------------

			set @priorMyWineName = @myWineName
		end
	close @mp
	deallocate @mp

if @finish = 0
	begin
		------------------------------------------------------------------------------------------
		-- Fixup the rowFlags and fill in alternate vintages
		------------------------------------------------------------------------------------------	
		with a as (select row_number() over(order by id) ii, * from transfer..userwines20) update a set a.rowFlag = b.rowFlag from a 	join a b on a.ii = b.ii-1 and a.myWineName = b.myWineName and a.rowFlag is null
	end
	

 	
	if @importStatus = 0 set @importStatus = 2
/*end try
begin catch
	set @importStatus = -1
end catch 
*/
update wh set importStatus = @importStatus where whN = @whN

update transfer..importStatus 
	set
		  status = @importStatus
		,nameMatchedNotVintage = @nameMatchedNotVintage
		, nameAndVintageMatched = @nameAndVintageMatched
		, noMatch = (select count(*)cnt from transfer..userWines20 where noMatch = 1)
		, stillPending = (select count(*)cnt from transfer..userWines20 where wineN is null)
		, bottlesImported = @totalBottleCount
	where whN=@whN



end 
/*
use transfer
ooi importStatus

use erp
zapUser 20
 
update transfer..userwines20 set errors=null
verifyFinishImportX 20, 0
verifyFinishImportX 20, 1     
select count(*) from transfer..userwines20

select importStatus from wh where whN=20
select errors,* from transfer..userwines20
select importStatus from erp..wh where whN=20
select * from purchase where whN=20
select * from whToWine where whN=20
select * from whNameToWine where whN=20
 
drop table transfer..userwines20
select * into transfer..userWines20 from transfer..userWines20_errors
select * into transfer..userWines20 from transfer..userWines20_saved
 
use transfer 
oon userwines
select errors, * from transfer..userwines20

*/
