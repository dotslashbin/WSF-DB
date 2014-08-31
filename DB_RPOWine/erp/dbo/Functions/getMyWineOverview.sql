-- get Overview SUmmary of MyWine Information     [=]
CREATE function getMyWineOverview (@whn int, @wineN int)
returns @T table(
	 whN int
	,wineN int
	,bottleCount int
	,hasMoreDetail bit
	,location varchar(max)
	,tastingCount int
	,wantToSellCount int
	,wantToBuyCount int
	,buyerCount int
	,sellerCount int
	,isOfInterest bit
	)
as begin
 
insert into @T(whN,wineN,bottleCount,hasMoreDetail,location,tastingCount,wantToSellCount,wantToBuyCount,buyerCount,sellerCount,isOfInterest)
	select a.whN,wineN,bottleCount,hasMoreDetail,location, tastingCount,wantToSellCount,wantToBuyCount,buyerCount,sellerCount,isOfInterest
		from whToWine a
		left join bottleLocation b
			on a.locationN = b.locationN
		where a.whN = @whN
			and a.wineN = isNull(@wineN, a.wineN)
return
end
/*
select * from getMyWineOverview(20, null)
 
 
*/
