create proc [dbo].calcWhToWine_old0907Jul10(@whN int, @wineN int, @fullRecalculateFromMyWinesTables bit = 0
					)
as begin
 
set noCount on;
 
if not exists (select * from whToWine where whN = @whN and wineN = @wineN)
	insert into whToWine(whN, wineN) 
		select @whN, @wineN
  
 
update whToWine
	set
		  wantToTry = case when isNull(wantToTryMW, 0) <> 0 or isNull(wantToTryRemote, 0) <> 0 	then 1 else 0 end
		, hasBottles = case when isNull(bottleCount, 0) <> 0 or isNull(hasBottlesRemote, 0) <> 0 	then 1 else 0 end
		, hasTastings = case when isNull(tastingCount, 0) <> 0 or isNull(hasTastingsRemote, 0) <> 0 	then 1 else 0 end
		, wantToSell = case when isNull(wantToSellBottleCount, 0) <> 0 or isNull(wantToSellRemote, 0) <> 0 	then 1 else 0 end
		, wantToBuy = case when isNull(wantToBuyBottleCount, 0) <> 0 or isNull(wantToBuyRemote, 0) <> 0 	then 1 else 0 end
		, hasBuyers = case when isNull(buyerCount, 0) <> 0 or isNull(hasBuyersRemote, 0) <> 0 	then 1 else 0 end
		, hasSellers = case when isNull(sellerCount, 0) <> 0 or isNull(hasSellersRemote, 0) <> 0 	then 1 else 0 end
		, hasUserComments = case when isNull(LEN(userComments), 0) <> 0 or isNull(hasUserCommentsRemote, 0) <> 0 	then 1 else 0 end
		
		, wantToTryROnly = case when isNull(wantToTryMW, 0) <> 0 then isNull(wantToTryRemote, 0) else 0 end
		, hasBottlesROnly = case when isNull(bottleCount, 0) <> 0 then isNull(hasBottlesRemote, 0) else 0 end
		, hasTastingsROnly = case when isNull(tastingCount, 0) <> 0 then isNull(wantToTryRemote, 0) else 0 end
		, wantToBuyROnly = case when isNull(wantToSellBottleCount, 0) <> 0 then isNull(wantToTryRemote, 0) else 0 end
		, wantToSellROnly = case when isNull(wantToBuyBottleCount, 0) <> 0 then isNull(wantToTryRemote, 0) else 0 end
		, hasBuyersROnly = case when isNull(buyerCount, 0) <> 0 then isNull(wantToTryRemote, 0) else 0 end
		, hasSellersROnly = case when isNull(sellerCount, 0) <> 0 then isNull(wantToTryRemote, 0) else 0 end
		, hasUserCommentsROnly  = case when isNull(len(userComments), 0) <> 0 then isNull(wantToTryRemote, 0) else 0 end
	where whN = @whN and wineN = @wineN
	
	
	update whToWine
		set
				  isOfInterest = case when 
						isNull(isOfInterestMW, 0) <> 0
						or isNull(wantToTry, 0) <> 0
						or isNull(hasBottles, 0) <> 0
						or isNull(hasTastings, 0) <> 0
						or isNull(wantToSell, 0) <> 0
						or isNull(wantToBuy, 0) <> 0
						or isNull(hasBuyers, 0) <> 0
						or isNull(hasSellers, 0) <> 0
						
						or isNull(isOfInterestRemote, 0) <> 0
						or isNull(wantToTryRemote, 0) <> 0
						or isNull(hasBottlesRemote, 0) <> 0
						or isNull(hasTastingsRemote, 0) <> 0
						or isNull(wantToSellRemote, 0) <> 0
						or isNull(wantToBuyRemote, 0) <> 0
						or isNull(hasBuyersRemote, 0) <> 0
						or isNull(hasSellersRemote, 0) <> 0
					then 
							1
					 else 
							0 
					end
		
			, isOfInterestROnly = case when 
						isNull(isOfInterestMW, 0)= 0
						and isNull(wantToTry, 0)= 0
						and isNull(hasBottles, 0)= 0
						and isNull(hasTastings, 0)= 0
						and isNull(wantToSell, 0)= 0
						and isNull(wantToBuy, 0)= 0
						and isNull(hasBuyers, 0)= 0
						and isNull(hasSellers, 0)= 0
						
						and	(
										isNull(isOfInterestRemote, 0) <> 0
										or isNull(wantToTryRemote, 0) <> 0
										or isNull(hasBottlesRemote, 0) <> 0
										or isNull(hasTastingsRemote, 0) <> 0
										or isNull(wantToSellRemote, 0) <> 0
										or isNull(wantToBuyRemote, 0) <> 0
										or isNull(hasBuyersRemote, 0) <> 0
										or isNull(hasSellersRemote, 0) <> 0
								)
					then 
							1
					 else 
							0 
					end

		
		where whN = @whN and wineN = @wineN

 
update whToWine	
	set
			hasHadStuff = case when hasHadStuff <> 0 or isOfInterest <> 0 then 1 else 0 end
	where whN = @whN and wineN = @wineN

 
 
 
 
end
 
 