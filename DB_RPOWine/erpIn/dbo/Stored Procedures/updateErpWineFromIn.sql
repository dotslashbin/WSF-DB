CREATE proc updateErpWineFromIn  (@error varchar(max) = '' output) as begin
/*
use erpin
buildMergeWine 'wine', 'wineN rowversion isInactive hasErpTasting hasProTasting mostRecentPriceLoStd mostRecentPriceHiStd isCurrentlyForSaleu'
select count(*) from vWine
*/
 
 
------------------------------------------------------------------------------------------------------------------------------
-- Update matched records
------------------------------------------------------------------------------------------------------------------------------
set noCount on
declare @lock int=-999999
 
begin transaction
exec @lock = sp_getapplock @resource='addNewWine', @lockmode='Exclusive'
if @lock<0
	begin
			rollback transaction
			set @error = 'updateErpWineFromIn :  Matched failed to get a lock'
			print @error
			return
	end
else
	begin
			merge vWine a
				using wine b
					on a.wineN = b.wineN
			when matched 
					and	(     
								a._x_hasErpTasting <> b._x_hasErpTasting or (a._x_hasErpTasting is null and b._x_hasErpTasting is not null) or (a._x_hasErpTasting is not null and b._x_hasErpTasting is null)
								or a._x_IsNowForSale <> b._x_IsNowForSale or (a._x_IsNowForSale is null and b._x_IsNowForSale is not null) or (a._x_IsNowForSale is not null and b._x_IsNowForSale is null)
								or a._x_isNowOnlyOnAuction <> b._x_isNowOnlyOnAuction or (a._x_isNowOnlyOnAuction is null and b._x_isNowOnlyOnAuction is not null) or (a._x_isNowOnlyOnAuction is not null and b._x_isNowOnlyOnAuction is null)
								or a._x_mostRecentNonAuctionPriceCnt <> b._x_mostRecentNonAuctionPriceCnt or (a._x_mostRecentNonAuctionPriceCnt is null and b._x_mostRecentNonAuctionPriceCnt is not null) or (a._x_mostRecentNonAuctionPriceCnt is not null and b._x_mostRecentNonAuctionPriceCnt is null)
								or a._x_mostRecentNonAuctionPriceHi <> b._x_mostRecentNonAuctionPriceHi or (a._x_mostRecentNonAuctionPriceHi is null and b._x_mostRecentNonAuctionPriceHi is not null) or (a._x_mostRecentNonAuctionPriceHi is not null and b._x_mostRecentNonAuctionPriceHi is null)
								or a._x_mostRecentNonAuctionPriceLo <> b._x_mostRecentNonAuctionPriceLo or (a._x_mostRecentNonAuctionPriceLo is null and b._x_mostRecentNonAuctionPriceLo is not null) or (a._x_mostRecentNonAuctionPriceLo is not null and b._x_mostRecentNonAuctionPriceLo is null)
								or a._x_mostRecentPriceCnt <> b._x_mostRecentPriceCnt or (a._x_mostRecentPriceCnt is null and b._x_mostRecentPriceCnt is not null) or (a._x_mostRecentPriceCnt is not null and b._x_mostRecentPriceCnt is null)
								or a._x_mostRecentPriceHi <> b._x_mostRecentPriceHi or (a._x_mostRecentPriceHi is null and b._x_mostRecentPriceHi is not null) or (a._x_mostRecentPriceHi is not null and b._x_mostRecentPriceHi is null)
								or a._x_mostRecentPriceLo <> b._x_mostRecentPriceLo or (a._x_mostRecentPriceLo is null and b._x_mostRecentPriceLo is not null) or (a._x_mostRecentPriceLo is not null and b._x_mostRecentPriceLo is null)
								or a._x_tastingCount <> b._x_tastingCount or (a._x_tastingCount is null and b._x_tastingCount is not null) or (a._x_tastingCount is not null and b._x_tastingCount is null)
								or a.activeVinn <> b.activeVinn or (a.activeVinn is null and b.activeVinn is not null) or (a.activeVinn is not null and b.activeVinn is null)
								or a.createDate <> b.createDate or (a.createDate is null and b.createDate is not null) or (a.createDate is not null and b.createDate is null)
								or a.encodedKeywords <> b.encodedKeywords or (a.encodedKeywords is null and b.encodedKeywords is not null) or (a.encodedKeywords is not null and b.encodedKeywords is null)
								or a.estimatedCostHi <> b.estimatedCostHi or (a.estimatedCostHi is null and b.estimatedCostHi is not null) or (a.estimatedCostHi is not null and b.estimatedCostHi is null)
								or a.estimatedCostLo <> b.estimatedCostLo or (a.estimatedCostLo is null and b.estimatedCostLo is not null) or (a.estimatedCostLo is not null and b.estimatedCostLo is null)
								or a.isCurrentlyForSale <> b.isCurrentlyForSale or (a.isCurrentlyForSale is null and b.isCurrentlyForSale is not null) or (a.isCurrentlyForSale is not null and b.isCurrentlyForSale is null)
								or a.vintage <> b.vintage or (a.vintage is null and b.vintage is not null) or (a.vintage is not null and b.vintage is null)
								or a.wineNameN <> b.wineNameN or (a.wineNameN is null and b.wineNameN is not null) or (a.wineNameN is not null and b.wineNameN is null)
							)
						  then
				update set 
					_x_hasErpTasting=b._x_hasErpTasting
					, _x_IsNowForSale=b._x_IsNowForSale
					, _x_isNowOnlyOnAuction=b._x_isNowOnlyOnAuction
					, _x_mostRecentNonAuctionPriceCnt=b._x_mostRecentNonAuctionPriceCnt
					, _x_mostRecentNonAuctionPriceHi=b._x_mostRecentNonAuctionPriceHi
					, _x_mostRecentNonAuctionPriceLo=b._x_mostRecentNonAuctionPriceLo
					, _x_mostRecentPriceCnt=b._x_mostRecentPriceCnt
					, _x_mostRecentPriceHi=b._x_mostRecentPriceHi
					, _x_mostRecentPriceLo=b._x_mostRecentPriceLo
					, _x_tastingCount=b._x_tastingCount
					, activeVinn=b.activeVinn
					, createDate=b.createDate
					, encodedKeywords=b.encodedKeywords
					, estimatedCostHi=b.estimatedCostHi
					, estimatedCostLo=b.estimatedCostLo
					, isCurrentlyForSale=b.isCurrentlyForSale
					, vintage=b.vintage
					, wineNameN=b.wineNameN;
 
			print 'updateErpWineFromIn - Matched: ' + convert(nvarchar, @@rowCount)
			exec sp_releaseAppLock @resource='addNewWine'
			commit transaction
	end
 
 
 
 
 
 
------------------------------------------------------------------------------------------------------------------------------
-- Update not matched records
------------------------------------------------------------------------------------------------------------------------------
begin transaction
exec @lock = sp_getapplock @resource='addNewWine', @lockmode='Exclusive'
if @lock<0
	begin
			rollback transaction
			set @error = 'updateErpWineFromIn :  Matched failed to get a lock'
			print @error
			return
	end
else
	begin
			set identity_insert erp.dbo.wine on;
 
			merge vWine a
				using wine b
					on a.wineN = b.wineN
			when not matched by target then
				insert	(
								   wineN
								 , _x_hasErpTasting
								, _x_IsNowForSale
								, _x_isNowOnlyOnAuction
								, _x_mostRecentNonAuctionPriceCnt
								, _x_mostRecentNonAuctionPriceHi
								, _x_mostRecentNonAuctionPriceLo
								, _x_mostRecentPriceCnt
								, _x_mostRecentPriceHi
								, _x_mostRecentPriceLo
								, _x_tastingCount
								, activeVinn
								, createDate
								, encodedKeywords
								, estimatedCostHi
								, estimatedCostLo
								, isCurrentlyForSale
								, vintage
								, wineNameN
						)
					values		
						(
								   wineN
								 , _x_hasErpTasting
								, _x_IsNowForSale
								, _x_isNowOnlyOnAuction
								, _x_mostRecentNonAuctionPriceCnt
								, _x_mostRecentNonAuctionPriceHi
								, _x_mostRecentNonAuctionPriceLo
								, _x_mostRecentPriceCnt
								, _x_mostRecentPriceHi
								, _x_mostRecentPriceLo
								, _x_tastingCount
								, activeVinn
								, createDate
								, encodedKeywords
								, estimatedCostHi
								, estimatedCostLo
								, isCurrentlyForSale
								, vintage
								, wineNameN
						);
			print 'updateErpWineFromIn - Not Matched: ' + convert(nvarchar, @@rowCount)
			exec sp_releaseAppLock @resource='addNewWine'
			set identity_insert erp.dbo.wine off;
			commit transaction
	end
 
 
 
------------------------------------------------------------------------------------------------------------------------------
-- Fixup EncodedKeywords
------------------------------------------------------------------------------------------------------------------------------ 
update a
		set
				a.encodedKeywords = vintage + ' ' + b.encodedKeywords
		from vWine a
				join vWineName b
					on a.wineNameN=b.wineNameN
		where 
				a.encodedKeywords is null
				or 0=charindex(b.encodedKeywords, a.encodedKeywords)
 
print 'updateErpWineFromIn - Keywords fixed: ' + convert(nvarchar, @@rowCount)
 
 
 
 
 
 
 
 
 
 
 
 end
 
 
 
