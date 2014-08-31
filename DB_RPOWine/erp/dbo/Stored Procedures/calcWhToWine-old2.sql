CREATE proc [dbo].[calcWhToWine-old2](@whN int, @wineN int, @fullRecalculateFromMyWinesTables bit = 0

                                                            )

as begin

 

set noCount on;

 

if not exists (select * from whToWine where whN = @whN and wineN = @wineN)

            insert into whToWine(whN, wineN) 

                        select @whN, @wineN

  

 

update whToWine

            set

                          wantToTryShow = case when isNull(wantToTry, 0) <> 0 then 1 else 0 end

                        , hasBottlesShow = case when isNull(bottleCount, 0) <> 0 then 1 else 0 end

                        , hasTastingsShow = case when isNull(tastingCount, 0) <> 0 then 1 else 0 end

                        , wantToSellShow = case when isNull(wantToSellBottleCount, 0) <> 0 then 1 else 0 end

                        , wantToBuyShow = case when isNull(wantToBuyBottleCount, 0) <> 0 then 1 else 0 end

                        , hasBuyersShow = case when isNull(buyerCount, 0) <> 0 then 1 else 0 end

                        , hasSellersShow = case when isNull(sellerCount, 0) <> 0 then 1 else 0 end

                        , hasUserCommentsShow = case when isNull(LEN(userComments), 0) <> 0 then 1 else 0 end

            

                        , wantToTryX = case when isNull(wantToTry, 0) <> 0 or isNull(wantToTryR, 0) <> 0          then 1 else 0 end

                        , hasBottlesX = case when isNull(bottleCount, 0) <> 0 or isNull(hasBottlesR, 0) <> 0          then 1 else 0 end

                        , hasTastingsX = case when isNull(tastingCount, 0) <> 0 or isNull(hasTastingsR, 0) <> 0             then 1 else 0 end

                        , wantToSellX = case when isNull(wantToSellBottleCount, 0) <> 0 or isNull(wantToSellR, 0) <> 0       then 1 else 0 end

                        , wantToBuyX = case when isNull(wantToBuyBottleCount, 0) <> 0 or isNull(wantToBuyR, 0) <> 0      then 1 else 0 end

                        , hasBuyersX = case when isNull(buyerCount, 0) <> 0 or isNull(hasBuyersR, 0) <> 0          then 1 else 0 end

                        , hasSellersX = case when isNull(sellerCount, 0) <> 0 or isNull(hasSellersR, 0) <> 0          then 1 else 0 end

                        , hasUserCommentsX = case when isNull(LEN(userComments), 0) <> 0 or isNull(hasUserCommentsR, 0) <> 0      then 1 else 0 end

                        

            where whN = @whN and wineN = @wineN

            

            

            update whToWine

                        set

                                                  isOfInterestShow = case when 

                                                                        isNull(isOfInterest, 0) <> 0

                                                                        or isNull(wantToTryShow, 0) <> 0

                                                                        or isNull(hasBottlesShow, 0) <> 0

                                                                        or isNull(hasTastingsShow, 0) <> 0

                                                                        or isNull(wantToSellShow, 0) <> 0

                                                                        or isNull(wantToBuyShow, 0) <> 0

                                                                        or isNull(hasBuyersShow, 0) <> 0

                                                                        or isNull(hasSellersShow, 0) <> 0

                                                                        or ISNULL(len(userComments), 0) <> 0

                                                                        

                                                                        or isNull(isOfInterestR, 0) <> 0

                                                                        or isNull(wantToTryR, 0) <> 0

                                                                        or isNull(hasBottlesR, 0) <> 0

                                                                        or isNull(hasTastingsR, 0) <> 0

                                                                        or isNull(wantToSellR, 0) <> 0

                                                                        or isNull(wantToBuyR, 0) <> 0

                                                                        or isNull(hasBuyersR, 0) <> 0

                                                                        or isNull(hasSellersR, 0) <> 0

                                                                        or ISNULL(hasUserCommentsR, 0) <> 0

                                                            then 

                                                                                    1

                                                             else 

                                                                                    0 

                                                            end

                        

                                    , isOfInterestIndirect = case when 

                                                                        isNull(isOfInterest, 0)= 0

                                                                        and not 

                                                                                    (

                                                                                                isNull(wantToTryShow, 0) <> 0

                                                                                                or isNull(hasBottlesShow, 0) <> 0

                                                                                                or isNull(hasTastingsShow, 0) <> 0

                                                                                                or isNull(wantToSellShow, 0) <> 0

                                                                                                or isNull(wantToBuyShow, 0) <> 0

                                                                                                or isNull(hasBuyersShow, 0) <> 0

                                                                                                or isNull(hasSellersShow, 0) <> 0

 

                                                                                                or isNull(isOfInterestR, 0) <> 0

                                                                                                or isNull(wantToTryR, 0) <> 0

                                                                                                or isNull(hasBottlesR, 0) <> 0

                                                                                                or isNull(hasTastingsR, 0) <> 0

                                                                                                or isNull(wantToSellR, 0) <> 0

                                                                                                or isNull(wantToBuyR, 0) <> 0

                                                                                                or isNull(hasBuyersR, 0) <> 0

                                                                                                or isNull(hasSellersR, 0) <> 0

                                                                                    )                                                                       

                                                            then 

                                                                                    1

                                                             else 

                                                                                    0 

                                                            end

 

                        

                        where whN = @whN and wineN = @wineN

 

 

update whToWine         

            set

                                    hasHadStuff = case when hasHadStuff <> 0 or isOfInterestShow <> 0 then 1 else 0 end

            where whN = @whN and wineN = @wineN

 

 

 

 

 

end

