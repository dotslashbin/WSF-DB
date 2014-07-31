create proc [dbo].[setMyFields_old](
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
 
declare 
			 @whND integer
			,@isOfInterestLocalD bit
			,@wantToTryLocalD bit = null
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
			@isOfInterestLocalD  = isOfInterestLocal
			,@wantToTryLocalD = wantToTryLocal
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
 
	if @isOfInterest is not null set @isOfInterestLocalD = @isOfInterest;
	if @wantToTry is not null set @wantToTryLocalD = @wantToTry;
	if @bottleCount is not null set @bottleCountD = @bottleCount;
	if @tastingCount is not null set @tastingCountD = @tastingCount;
	if @wantToSellBottleCount is not null set @wantToSellBottleCountD = @wantToSellBottleCount;
	if @wantToBuyBottleCount is not null set @wantToBuyBottleCountD = @wantToBuyBottleCount;
	if @buyerCount is not null set @buyerCountD = @buyerCount;
	if @userComments is not null set @userCommentsD = @userComments;
	

	-----------------------------------------------------------------------
	-- Set the Non Remote Bits
	if @wantToTry is not null set @wantToTryLocalD = case when @wantToTry <> 0 then 1 else 0 end
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
	if @isOfInterest is null set @isOfInterestLocalD = 0 	else set @isOfInterestLocalD = @isOfInterest
	
	if	isNull(@wantToTryLocalD, 0) <> 0
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
			set @isOfInterestLocalD = 1
		end
 
 
	if @whND is null
		begin
			insert into whToWine(whN, wineN
			
					, isOfInterest, wantToTry
					, hasBottles, hasTastings, wantToSell, wantToBuy, hasComments
					
					, isOfInterestLocal, wantToTryLocal
					, bottleCount, tastingCount, wantToSellBottleCount, wantToBuyBottleCount, buyerCount, sellerCount, userComments) 
				select @whN, @wineN
					, case when ISNULL(@isOfInterestLocalD, 0) <> 0 OR ISNULL(@isOfInterestRemoteD, 0) <> 0 then 1 else 0 end
					, case when ISNULL(@wantToTryLocalD, 0) <> 0 OR ISNULL(@wantToTryRemoteD, 0) <> 0 then 1 else 0 end
					, case when isNull(@bottleCountD, 0)  <> 0 then 1 when isNull(@hasBottlesRemoteD, 0) <> 0 then 1 else 0 end
					, case when isNull(@tastingCountD, 0)  <> 0 then 1 when isNull(@hasTastingsRemoteD, 0) <> 0 then 1 else 0 end
					, case when isNull(@wantToSellBottleCountD, 0)  <> 0 then 1 when isNull(@wantToSellRemoteD, 0) <> 0 then 1 else 0 end
					, case when isNull(@wantToBuyBottleCountD, 0)  <> 0 then 1 when isNull(@wantToBuyRemoteD, 0) <> 0 then 1 else 0 end
					, case when isNull(@userCommentsD, 0)  <> 0 then 1 when isNull(@hasUserCommentsRemoteD, 0) <> 0 then 1 else 0 end
					, @isOfInterestLocalD, @wantToTryLocalD
					, @bottleCountD, @tastingCountD, @wantToSellBottleCountD, @wantToBuyBottleCountD, @buyerCountD, @sellerCountD, @userCommentsD
		end
	else
		begin
			update whToWine
					set 
						  isOfInterest = case when ISNULL(@isOfInterestLocalD, 0) <> 0 OR ISNULL(@isOfInterestRemoteD, 0) <> 0 then 1 else 0 end
						 ,wantToTry = case when ISNULL(@wantToTryLocalD, 0) <> 0 OR ISNULL(@wantToTryRemoteD, 0) <> 0 then 1 else 0 end 						  
						, hasBottles = case when isNull(@bottleCountD, 0)  <> 0 then 1 when isNull(@hasBottlesRemoteD, 0) <> 0 then 1 else 0 end
						, hasTastings = case when isNull(@tastingCountD, 0)  <> 0 then 1 when isNull(@hasTastingsRemoteD, 0) <> 0 then 1 else 0 end
						, wantToSell = case when isNull(@wantToSellBottleCountD, 0)  <> 0 then 1 when isNull(@wantToSellRemoteD, 0) <> 0 then 1 else 0 end
						, wantToBuy = case when isNull(@wantToBuyBottleCountD, 0)  <> 0 then 1 when isNull(@wantToBuyRemoteD, 0) <> 0 then 1 else 0 end
						, hasComments = case when isNull(@userCommentsD, 0)  <> 0 then 1 when isNull(@hasUserCommentsRemoteD, 0) <> 0 then 1 else 0 end
						  
						
						, isOfInterestLocal = @isOfInterestLocalD
						, wantToTryLocal = @wantToTryLocalD
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
 
 
 
 
 
 
