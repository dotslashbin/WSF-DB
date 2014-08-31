create proc [dbo].[setMyFields_old0907Jul09](
					 @whN integer
					,@wineN integer
					,@isOfInterest bit = null
					,@wantToTry bit = null
					,@bottleCount integer = null
					,@tastingCount integer = null
					,@wantToSellBottleCount integer = null
					,@wantToBuyBottleCount integer = null
					,@buyerCount integer = null
					,@sellerCount integer = null
					,@userComments nvarChar(100) = null
					,@fullRecalculateFromMyWinesTables bit = 0
					)
as begin
 
set noCount on;
 
if not exists (select * from whToWine where whN = @whN and wineN = @wineN)
	insert into whToWine(whN, wineN) 
		select @whN, @wineN
 
update whToWine
/*	set 
		  wantToTry =   case when ISNULL(wantToTryRemote, 0)  <> 0 or ISNULL(@wantToTry, 0) <> 0 then 1 else 0 end
		, hasBottles = case when ISNULL(hasBottlesRemote, 0)  <> 0 or ISNULL(@bottleCount, 0) <> 0 then 1 else 0 end
		, hasTastings = case when ISNULL(hasTastingsRemote, 0)  <> 0 or ISNULL(@tastingCount, 0) <> 0 then 1 else 0 end
		, wantToSell = case when ISNULL(wantToSellRemote, 0)  <> 0 or ISNULL(@wantToSellBottleCount, 0) <> 0 then 1 else 0 end
		, wantToBuy = case when ISNULL(wantToBuyRemote, 0)  <> 0 or ISNULL(@wantToBuyBottleCount, 0) <> 0 then 1 else 0 end
		, hasBuyers = case when ISNULL(hasBuyersRemote, 0)  <> 0 or ISNULL(@buyerCount, 0) <> 0 then 1 else 0 end
		, hasSellers = case when ISNULL(hasSellersRemote, 0)  <> 0 or ISNULL(@sellerCount, 0) <> 0 then 1 else 0 end
		, hasComments = case when ISNULL(hasUserCommentsRemote, 0)  <> 0 or ISNULL(len(@userComments), 0) <> 0 then 1 else 0 end
		
		, isOfInterestMW = case when @isOfInterest is null then isOfInterestMW else @isOfInterest end
		, wantToTryMW = case when @wantToTry is null then wantToTryMW else @wantToTry end
 
		, bottleCount = case when @bottleCount is null then bottleCount else @bottleCount end
		, tastingCount = case when @tastingCount is null then tastingCount else @tastingCount end		
		, wantToSellBottleCount = case when @wantToSellBottleCount is null then wantToSellBottleCount else @wantToSellBottleCount end		
		, wantToBuyBottleCount = case when @wantToBuyBottleCount is null then wantToBuyBottleCount else @wantToBuyBottleCount end		
		, buyerCount = case when @buyerCount is null then buyerCount else @buyerCount end		
		, sellerCount = case when @sellerCount is null then sellerCount else @sellerCount end		
		, userComments = case when @userComments is null then userComments else @userComments end		
	where whN = @whN and wineN = @wineN */
	
	set
		    wantToTryMW = case when isNull(@wantToTry, isNull(wantToTry, 0)) <> 0 then 1 else 0 end
		  , isOfInterestMW = case when isNull(@isOfInterest, isNull(isOfInterestMW, 0)) <> 0 then 1 else 0 end
 
		  , bottleCount = ISNULL(@bottleCount, bottleCount)
		  , tastingCount = ISNULL(@tastingCount, tastingCount)
		  , wantToSellBottleCount = ISNULL(@wantToSellBottleCount, wantToSellBottleCount)
		  , wantToBuyBottleCount = ISNULL(@wantToBuyBottleCount, wantToBuyBottleCount)
		  , buyerCount = ISNULL(@buyerCount, buyerCount)
		  , sellerCount = ISNULL(@sellerCount, sellerCount)
		  , userComments = ISNULL(@userComments, userComments)
				
		--XXX = case when ISNULL(@YYY, ISNULL(XXXCount, 0)) <> 0 then 1 else 0 end
 
		--XXX = case when ISNULL(@YYY, ISNULL(XXXRemote, 0)) <> 0 then 1 else 0 end
		where whN = @whN and wineN = @wineN
 
 
update whToWine
	set
		isOfInterest = case when 
								isNull(isOfInterestMW, 0) <> 0
								or isNull(isOfInterestRemote, 0) <> 0
								or isNull(wantToTry, 0) <> 0
								or isNull(hasBottles, 0) <> 0
								or isNull(hasTastings, 0) <> 0
								or isNull(wantToSell, 0) <> 0
								or isNull(wantToBuy, 0) <> 0
								or isNull(hasBuyers, 0) <> 0
								or isNull(hasSellers, 0) <> 0
							then 1 else 0 end
		, wantToTry = case when isNull(wantToTryMW, 0) <> 0 or isNull(wantToTryRemote, 0) <> 0 	then 1 else 0 end
		, hasBottles = case when isNull(bottleCount, 0) <> 0 or isNull(hasBottlesRemote, 0) <> 0 	then 1 else 0 end
		, hasTastings = case when isNull(tastingCount, 0) <> 0 or isNull(hasTastingsRemote, 0) <> 0 	then 1 else 0 end
		, wantToSell = case when isNull(wantToSellBottleCount, 0) <> 0 or isNull(wantToSellRemote, 0) <> 0 	then 1 else 0 end
		, wantToBuy = case when isNull(wantToBuyBottleCount, 0) <> 0 or isNull(wantToBuyRemote, 0) <> 0 	then 1 else 0 end
		, hasBuyers = case when isNull(buyerCount, 0) <> 0 or isNull(hasBuyersRemote, 0) <> 0 	then 1 else 0 end
		, hasSellers = case when isNull(sellerCount, 0) <> 0 or isNull(hasSellersRemote, 0) <> 0 	then 1 else 0 end
		, hasUserComments = case when isNull(LEN(userComments), 0) <> 0 or isNull(hasUserCommentsRemote, 0) <> 0 	then 1 else 0 end
 
	where whN = @whN and wineN = @wineN
 
update whToWine	
	set
		hasHadStuff = case when hasHadStuff <> 0 or isOfInterest <> 0 then 1 else 0 end
	where whN = @whN and wineN = @wineN
 
 
 
 
 
 
 
 
 
end
 
 
/* 
declare 
			 @whND integer
			,@isOfInterestMWD bit
			,@wantToTryMWD bit = null
			,@bottleCountD integer = null
			
			,@tastingCountD integer = null
			,@wantToSellBottleCountD integer = null
			,@wantToBuyBottleCountD integer = null
			,@buyerCountD integer = null
			,@sellerCountD integer = null
			
			,@userCommentsD nvarChar(100) = null
			,@isOfInterestRemoteD bit = null
			,@wantToTryRemoteD bit = null
			,@hasBottlesRemoteD bit = null
			,@hasTastingsRemoteD bit = null
			
			,@wantToSellRemoteD bit = null
			,@wantToBuyRemoteD bit  = null
			,@hasBuyersRemoteD bit = null
			,@hasSellersRemoteD bit = null
			,@hasUserCommentsRemoteD bit = null
 
select 
			@isOfInterestMWD  = isOfInterestMW
			,@wantToTryMWD = wantToTryMW
			,@bottleCountD = bottleCount
			,@tastingCountD = tastingCount
			,@wantToSellBottleCountD = wantToSellBottleCount
			,@wantToBuyBottleCountD = wantToBuyBottleCount
			,@buyerCountD = buyerCount
			,@sellerCountD = sellerCount
			,@userCommentsD = userComments	
						
			,@isOfInterestRemoteD = isOfInterestRemote
			,@wantToTryRemoteD = wantToTryRemote
			,@hasBottlesRemoteD = hasBottlesRemote
			,@hasTastingsRemoteD = hasTastingsRemote
			,@wantToBuyRemoteD = wantToBuyRemote
			,@wantToSellRemoteD = wantToSellRemote
			,@hasBuyersRemoteD = hasBuyersRemote
			,@hasSellersRemoteD = hasSellersRemote
			,@hasUserCommentsRemoteD = hasUserCommentsRemote
	from whToWine
		where whN = @whN and wineN = @wineN
 
	if @isOfInterest is not null set @isOfInterestMWD = @isOfInterest;
	if @wantToTry is not null set @wantToTryMWD = @wantToTry;
	if @bottleCount is not null set @bottleCountD = @bottleCount;
	if @tastingCount is not null set @tastingCountD = @tastingCount;
	if @wantToSellBottleCount is not null set @wantToSellBottleCountD = @wantToSellBottleCount;
	if @wantToBuyBottleCount is not null set @wantToBuyBottleCountD = @wantToBuyBottleCount;
	if @buyerCount is not null set @buyerCountD = @buyerCount;
	if @userComments is not null set @userCommentsD = @userComments;
	
 
	-----------------------------------------------------------------------
	-- Set the Non Remote Bits
	if @wantToTry is not null set @wantToTryMWD = case when @wantToTry <> 0 then 1 else 0 end
	if @tastingCount is not null 	set @tastingCountD = case when @tastingCount <> 0 then 1 else 0 end
	--if @wantToSellBottleCount is not null set @wantToSellBottleCountD = case when @wantToSell <> 0 then 1 else 0 end
	if @wantToBuyBottleCount is not null set @wantToBuyBottleCountD = case when @wantToBuyBottleCount <> 0 then 1 else 0 end
	if @buyerCount is not null set @buyerCountD = case when @buyerCount <> 0 then 1 else 0 end
	
/*
	if @xxx is not null set @xxxD = case when @xxx <> 0 then 1 else 0 end
*/	
	-----------------------------------------------------------------------
	
	--isOfInterest - set later on after we've done everything else
	
	-----------------------------------------------------------------------
	-- Update the database
	-----------------------------------------------------------------------
 
	
	
/*
		isOfInterest
		wantToTry
		hasBottles
		hasTastings
		wantToBuy		
		wantToSell
		hasBuyers
		hasSellers
		hasComments
 
		isOfInterestRemote
		wantToTryRemote
		hasBottlesRemote
		hasTastingsRemote
		wantToBuyRemote
		wantToSellRemote
		hasBuyersRemote
		hasSellersRemote
		hasUserCommentsRemote
 
		hasHadStuff
		isDerived
		warnings
*/ 
 
 
	
	
	--isOfInterest -  Set isOfInterest last	
	if @isOfInterest is null set @isOfInterestMWD = 0 	else set @isOfInterestMWD = @isOfInterest
	
	if	isNull(@wantToTryMWD, 0) <> 0
		or isNull(@bottleCountD, 0) <> 0
		or isNull(@tastingCountD, 0) <> 0
		or isNull(@wantToSellBottleCountD, 0) <> 0
		or isNull(@wantToBuyBottleCountD, 0) <> 0
		or len(isNull(@userCommentsD, '')) <> 0
		
		or isNull(@hasBottlesRemoteD, 0) <> 0
		or isNull(@hasTastingsRemoteD, 0) <> 0
		or isNull(@wantToSellRemoteD, 0) <> 0
		or isNull(@wantToBuyRemoteD, 0) <> 0
		or ISNULL(@hasUserCommentsRemoteD, 0) <> 0
		begin
			set @isOfInterestMWD = 1
		end
 
 
	if @whND is null
		begin
			insert into whToWine(whN, wineN
			
					, isOfInterest, wantToTry
					, hasBottles, hasTastings, wantToSell, wantToBuy, hasComments
					
					, isOfInterestMW, wantToTryMW
					, bottleCount, tastingCount, wantToSellBottleCount, wantToBuyBottleCount, buyerCount, sellerCount, userComments) 
				select @whN, @wineN
					, case when ISNULL(@isOfInterestMWD, 0) <> 0 OR ISNULL(@isOfInterestRemoteD, 0) <> 0 then 1 else 0 end
					, case when ISNULL(@wantToTryMWD, 0) <> 0 OR ISNULL(@wantToTryRemoteD, 0) <> 0 then 1 else 0 end
					, case when isNull(@bottleCountD, 0)  <> 0 then 1 when isNull(@hasBottlesRemoteD, 0) <> 0 then 1 else 0 end
					, case when isNull(@tastingCountD, 0)  <> 0 then 1 when isNull(@hasTastingsRemoteD, 0) <> 0 then 1 else 0 end
					, case when isNull(@wantToSellBottleCountD, 0)  <> 0 then 1 when isNull(@wantToSellRemoteD, 0) <> 0 then 1 else 0 end
					, case when isNull(@wantToBuyBottleCountD, 0)  <> 0 then 1 when isNull(@wantToBuyRemoteD, 0) <> 0 then 1 else 0 end
					, case when isNull(@userCommentsD, 0)  <> 0 then 1 when isNull(@hasUserCommentsRemoteD, 0) <> 0 then 1 else 0 end
					, @isOfInterestMWD, @wantToTryMWD
					, @bottleCountD, @tastingCountD, @wantToSellBottleCountD, @wantToBuyBottleCountD, @buyerCountD, @sellerCountD, @userCommentsD
		end
	else
		begin
			update whToWine
					set 
						  isOfInterest = case when ISNULL(@isOfInterestMWD, 0) <> 0 OR ISNULL(@isOfInterestRemoteD, 0) <> 0 then 1 else 0 end
						 ,wantToTry = case when ISNULL(@wantToTryMWD, 0) <> 0 OR ISNULL(@wantToTryRemoteD, 0) <> 0 then 1 else 0 end 						  
						, hasBottles = case when isNull(@bottleCountD, 0)  <> 0 then 1 when isNull(@hasBottlesRemoteD, 0) <> 0 then 1 else 0 end
						, hasTastings = case when isNull(@tastingCountD, 0)  <> 0 then 1 when isNull(@hasTastingsRemoteD, 0) <> 0 then 1 else 0 end
						, wantToSell = case when isNull(@wantToSellBottleCountD, 0)  <> 0 then 1 when isNull(@wantToSellRemoteD, 0) <> 0 then 1 else 0 end
						, wantToBuy = case when isNull(@wantToBuyBottleCountD, 0)  <> 0 then 1 when isNull(@wantToBuyRemoteD, 0) <> 0 then 1 else 0 end
						, hasComments = case when isNull(@userCommentsD, 0)  <> 0 then 1 when isNull(@hasUserCommentsRemoteD, 0) <> 0 then 1 else 0 end
						  
						
						, isOfInterestMW = @isOfInterestMWD
						, wantToTryMW = @wantToTryMWD
						, bottleCount = @bottleCountD
						, tastingCount = @tastingCountD
						, wantToSellBottleCount = @wantToSellBottleCountD
						, wantToBuyBottleCount = @wantToBuyBottleCountD
						, buyerCount = @buyerCountD
						, sellerCount = @sellerCountD
						, userComments = @userCommentsD
				where
					whN = @whN and wineN = @wineN
		end 
/*
check for setting
			,@wantToTryD = wantToTry
			,@bottleCountD = bottleCount
			,@tastingCountD = tastingCount
			,@wantToSellBottleCountD = wantToSellBottleCount
			,@wantToBuyBottleCountD = wantToBuyBottleCount
			,@buyerCountD = buyerCount
			,@sellerCountD = sellerCount
			,@userCommentsD = userComments
 
 
 
 
		whN
		wineN
		isOfInterest
		wantToTry
		bottleCount
		hasMoreDetail
		tastingCount
		wantToSellBottleCount
		wantToBuyBottleCount
		buyerCount
		sellerCount
		userComments
 
 
declare @xNonSpecificIsOfInterest bit, @xWantToTry bit, @xHasBottles bit , @xHasNotes bit, @xBuyThisWine bit, @xSellThisWine bit, @xUser1 bit
 
select 
	@xNonSpecificIsOfInterest = isOfInterest
	, @xWantToTry = wantToTry
	, @xHasBottles = hasBottles
	-- , @xIHaveNotes bit, @xBuyThisWine bit, @xSellThisWine bit, @xUser1 bit
	from whToWine
	where whN = @whN and wineN = @wineN
 
*/
if @whND is null
	print 'Record not there'
else
	print 'Record found' 
 
end
 
/*
 
ooi whToWine_
		whN
		wineN
		isOfInterest
		wantToTry
		bottleCount
		hasMoreDetail
		tastingCount
		wantToSellBottleCount
		wantToBuyBottleCount
		buyerCount
		sellerCount
		userComments
		bottleCountRemote
		tastingCountRemote
		wantToSellBottleCountRemote
		wantToBuyBottleCountRemote
		buyerCountRemote
		sellerCountRemote
		userCommentsRemote
 
oodef setMyWineFields
 
setMyWineFields -123, 22
setMyWineFields 6	,187
select top 1 whN, wineN from whToWine
*/
 */
 
