﻿CREATE proc [dbo].[update2TastingStep2] as begin
set noCount on
 exec dbo.oolog 'update2TastingStep2 begin'; 
 
------------------------------------------------------------------------------------------------------------------------------
-- Fixup isPrivate and isAnnoynomous
------------------------------------------------------------------------------------------------------------------------------
update vTastingNew set isPrivate=0 where isPrivate is null
update vTastingNew set isAnnonymous=0 where isAnnonymous is null
 
 
------------------------------------------------------------------------------------------
-- Make sure that fixedId is converted to dataIdN
------------------------------------------------------------------------------------------ 
update a
	set 
		  dataSourceN = whN
		, dataIdN = _fixedId
	from vTasting a
		join wh b
			on b.tag  = 'pubWa'
	where
		a.dataSourceN is null
		and _fixedId is not null;
print 'DataSourceN fixed: '+convert(char, @@rowCount)
 
------------------------------------------------------------------------------------------
-- Main transfer
------------------------------------------------------------------------------------------
declare @TSources table(dataSourceN int);
 
insert into @TSources(dataSourceN)
	select distinct(dataSourceN) from vTastingNew;
 
merge vTasting a
--using  vTastingNew  b
--			on a.dataSourceN = b.dataSourceN and a.dataIdN = b.dataIdN
using (
	select *,
		rn = row_number() over (partition by dataSourceN, dataIdN order by dataSourceN, dataIdN)
	from vTastingNew
) as b on b.rn = 1 and a.dataSourceN = b.dataSourceN and a.dataIdN = b.dataIdN
when matched 
		and	(     
					     a._clumpName <> b._clumpName or (a._clumpName is null and b._clumpName is not null) or (a._clumpName is not null and b._clumpName is null)
					or a._fixedId <> b._fixedId or (a._fixedId is null and b._fixedId is not null) or (a._fixedId is not null and b._fixedId is null)
					or a._fixedIdDeleted <> b._fixedIdDeleted or (a._fixedIdDeleted is null and b._fixedIdDeleted is not null) or (a._fixedIdDeleted is not null and b._fixedIdDeleted is null)
					or a._x_articleIdNKey <> b._x_articleIdNKey or (a._x_articleIdNKey is null and b._x_articleIdNKey is not null) or (a._x_articleIdNKey is not null and b._x_articleIdNKey is null)
					or a._x_hasAGalloniTasting <> b._x_hasAGalloniTasting or (a._x_hasAGalloniTasting is null and b._x_hasAGalloniTasting is not null) or (a._x_hasAGalloniTasting is not null and b._x_hasAGalloniTasting is null)
					or a._x_HasCurrentPrice <> b._x_HasCurrentPrice or (a._x_HasCurrentPrice is null and b._x_HasCurrentPrice is not null) or (a._x_HasCurrentPrice is not null and b._x_HasCurrentPrice is null)
					or a._x_hasDSchildknechtTasting <> b._x_hasDSchildknechtTasting or (a._x_hasDSchildknechtTasting is null and b._x_hasDSchildknechtTasting is not null) or (a._x_hasDSchildknechtTasting is not null and b._x_hasDSchildknechtTasting is null)
					or a._x_hasDThomasesTasting <> b._x_hasDThomasesTasting or (a._x_hasDThomasesTasting is null and b._x_hasDThomasesTasting is not null) or (a._x_hasDThomasesTasting is not null and b._x_hasDThomasesTasting is null)
					or a._x_hasErpTasting <> b._x_hasErpTasting or (a._x_hasErpTasting is null and b._x_hasErpTasting is not null) or (a._x_hasErpTasting is not null and b._x_hasErpTasting is null)
					or a._x_hasJMillerTasting <> b._x_hasJMillerTasting or (a._x_hasJMillerTasting is null and b._x_hasJMillerTasting is not null) or (a._x_hasJMillerTasting is not null and b._x_hasJMillerTasting is null)
					or a._x_hasMSquiresTasting <> b._x_hasMSquiresTasting or (a._x_hasMSquiresTasting is null and b._x_hasMSquiresTasting is not null) or (a._x_hasMSquiresTasting is not null and b._x_hasMSquiresTasting is null)
					or a._x_hasMultipleWATastings <> b._x_hasMultipleWATastings or (a._x_hasMultipleWATastings is null and b._x_hasMultipleWATastings is not null) or (a._x_hasMultipleWATastings is not null and b._x_hasMultipleWATastings is null)
					or a._x_hasNMartinTasting <> b._x_hasNMartinTasting or (a._x_hasNMartinTasting is null and b._x_hasNMartinTasting is not null) or (a._x_hasNMartinTasting is not null and b._x_hasNMartinTasting is null)
					or a._x_hasProducerProfile <> b._x_hasProducerProfile or (a._x_hasProducerProfile is null and b._x_hasProducerProfile is not null) or (a._x_hasProducerProfile is not null and b._x_hasProducerProfile is null)
					or a._x_HasProducerWebSite <> b._x_HasProducerWebSite or (a._x_HasProducerWebSite is null and b._x_HasProducerWebSite is not null) or (a._x_HasProducerWebSite is not null and b._x_HasProducerWebSite is null)
					or a._x_hasPRovaniTasting <> b._x_hasPRovaniTasting or (a._x_hasPRovaniTasting is null and b._x_hasPRovaniTasting is not null) or (a._x_hasPRovaniTasting is not null and b._x_hasPRovaniTasting is null)
					or a._x_hasRParkerTasting <> b._x_hasRParkerTasting or (a._x_hasRParkerTasting is null and b._x_hasRParkerTasting is not null) or (a._x_hasRParkerTasting is not null and b._x_hasRParkerTasting is null)
					or a._x_hasWJtasting <> b._x_hasWJtasting or (a._x_hasWJtasting is null and b._x_hasWJtasting is not null) or (a._x_hasWJtasting is not null and b._x_hasWJtasting is null)
					or a._x_IsActiveWineN <> b._x_IsActiveWineN or (a._x_IsActiveWineN is null and b._x_IsActiveWineN is not null) or (a._x_IsActiveWineN is not null and b._x_IsActiveWineN is null)
					or a._x_reviewerIdN <> b._x_reviewerIdN or (a._x_reviewerIdN is null and b._x_reviewerIdN is not null) or (a._x_reviewerIdN is not null and b._x_reviewerIdN is null)
					or a._x_showForERP <> b._x_showForERP or (a._x_showForERP is null and b._x_showForERP is not null) or (a._x_showForERP is not null and b._x_showForERP is null)
					or a._x_showForWJ <> b._x_showForWJ or (a._x_showForWJ is null and b._x_showForWJ is not null) or (a._x_showForWJ is not null and b._x_showForWJ is null)
					or a.articleId <> b.articleId or (a.articleId is null and b.articleId is not null) or (a.articleId is not null and b.articleId is null)
					or a.articleMasterN <> b.articleMasterN or (a.articleMasterN is null and b.articleMasterN is not null) or (a.articleMasterN is not null and b.articleMasterN is null)
					or a.articleOrder <> b.articleOrder or (a.articleOrder is null and b.articleOrder is not null) or (a.articleOrder is not null and b.articleOrder is null)
					or a.articleURL <> b.articleURL or (a.articleURL is null and b.articleURL is not null) or (a.articleURL is not null and b.articleURL is null)
					or a.bottleSizeN <> b.bottleSizeN or (a.bottleSizeN is null and b.bottleSizeN is not null) or (a.bottleSizeN is not null and b.bottleSizeN is null)
					or a.canBeActiveTasting <> b.canBeActiveTasting or (a.canBeActiveTasting is null and b.canBeActiveTasting is not null) or (a.canBeActiveTasting is not null and b.canBeActiveTasting is null)
					or a.createDate <> b.createDate or (a.createDate is null and b.createDate is not null) or (a.createDate is not null and b.createDate is null)
					or a.createWh <> b.createWh or (a.createWh is null and b.createWh is not null) or (a.createWh is not null and b.createWh is null)
					--or a.dataIdN <> b.dataIdN or (a.dataIdN is null and b.dataIdN is not null) or (a.dataIdN is not null and b.dataIdN is null)
					or a.dataIdNDeleted <> b.dataIdNDeleted or (a.dataIdNDeleted is null and b.dataIdNDeleted is not null) or (a.dataIdNDeleted is not null and b.dataIdNDeleted is null)
					--or a.dataSourceN <> b.dataSourceN or (a.dataSourceN is null and b.dataSourceN is not null) or (a.dataSourceN is not null and b.dataSourceN is null)
					or a.decantedN <> b.decantedN or (a.decantedN is null and b.decantedN is not null) or (a.decantedN is not null and b.decantedN is null)
					or a.drinkDate <> b.drinkDate or (a.drinkDate is null and b.drinkDate is not null) or (a.drinkDate is not null and b.drinkDate is null)
					or a.drinkDateHi <> b.drinkDateHi or (a.drinkDateHi is null and b.drinkDateHi is not null) or (a.drinkDateHi is not null and b.drinkDateHi is null)
					or a.drinkWhenN <> b.drinkWhenN or (a.drinkWhenN is null and b.drinkWhenN is not null) or (a.drinkWhenN is not null and b.drinkWhenN is null)
					or a.estimatedCostHi <> b.estimatedCostHi or (a.estimatedCostHi is null and b.estimatedCostHi is not null) or (a.estimatedCostHi is not null and b.estimatedCostHi is null)
					or a.estimatedCostLo <> b.estimatedCostLo or (a.estimatedCostLo is null and b.estimatedCostLo is not null) or (a.estimatedCostLo is not null and b.estimatedCostLo is null)
					or a.hasHad <> b.hasHad or (a.hasHad is null and b.hasHad is not null) or (a.hasHad is not null and b.hasHad is null)
					or a.hasUserComplaint <> b.hasUserComplaint or (a.hasUserComplaint is null and b.hasUserComplaint is not null) or (a.hasUserComplaint is not null and b.hasUserComplaint is null)
					or a.isActiveForThisPub <> b.isActiveForThisPub or (a.isActiveForThisPub is null and b.isActiveForThisPub is not null) or (a.isActiveForThisPub is not null and b.isActiveForThisPub is null)
					or a.isAnnonymous <> b.isAnnonymous or (a.isAnnonymous is null and b.isAnnonymous is not null) or (a.isAnnonymous is not null and b.isAnnonymous is null)
					or a.isApproved <> b.isApproved or (a.isApproved is null and b.isApproved is not null) or (a.isApproved is not null and b.isApproved is null)
					or a.isAvailabeToTastersGroups <> b.isAvailabeToTastersGroups or (a.isAvailabeToTastersGroups is null and b.isAvailabeToTastersGroups is not null) or (a.isAvailabeToTastersGroups is not null and b.isAvailabeToTastersGroups is null)
					or a.IsBarrelTasting <> b.IsBarrelTasting or (a.IsBarrelTasting is null and b.IsBarrelTasting is not null) or (a.IsBarrelTasting is not null and b.IsBarrelTasting is null)
					or a.isBorrowedDrinkDate <> b.isBorrowedDrinkDate or (a.isBorrowedDrinkDate is null and b.isBorrowedDrinkDate is not null) or (a.isBorrowedDrinkDate is not null and b.isBorrowedDrinkDate is null)
					or a.isInactive <> b.isInactive or (a.isInactive is null and b.isInactive is not null) or (a.isInactive is not null and b.isInactive is null)
					or a.isMostRecentTasting <> b.isMostRecentTasting or (a.isMostRecentTasting is null and b.isMostRecentTasting is not null) or (a.isMostRecentTasting is not null and b.isMostRecentTasting is null)
					or a.isNoTasting <> b.isNoTasting or (a.isNoTasting is null and b.isNoTasting is not null) or (a.isNoTasting is not null and b.isNoTasting is null)
					or a.isPostedToBB <> b.isPostedToBB or (a.isPostedToBB is null and b.isPostedToBB is not null) or (a.isPostedToBB is not null and b.isPostedToBB is null)
					or a.isPrivate <> b.isPrivate or (a.isPrivate is null and b.isPrivate is not null) or (a.isPrivate is not null and b.isPrivate is null)
					or a.issue <> b.issue or (a.issue is null and b.issue is not null) or (a.issue is not null and b.issue is null)
					or a.maturityN <> b.maturityN or (a.maturityN is null and b.maturityN is not null) or (a.maturityN is not null and b.maturityN is null)
					or a.notes <> b.notes or (a.notes is null and b.notes is not null) or (a.notes is not null and b.notes is null)
					or a.originalCurrencyN <> b.originalCurrencyN or (a.originalCurrencyN is null and b.originalCurrencyN is not null) or (a.originalCurrencyN is not null and b.originalCurrencyN is null)
					or a.pages <> b.pages or (a.pages is null and b.pages is not null) or (a.pages is not null and b.pages is null)
					or a.provenanceN <> b.provenanceN or (a.provenanceN is null and b.provenanceN is not null) or (a.provenanceN is not null and b.provenanceN is null)
					or a.pubDate <> b.pubDate or (a.pubDate is null and b.pubDate is not null) or (a.pubDate is not null and b.pubDate is null)
					or a.pubN <> b.pubN or (a.pubN is null and b.pubN is not null) or (a.pubN is not null and b.pubN is null)
					or a.rating <> b.rating or (a.rating is null and b.rating is not null) or (a.rating is not null and b.rating is null)
					or a.ratingHi <> b.ratingHi or (a.ratingHi is null and b.ratingHi is not null) or (a.ratingHi is not null and b.ratingHi is null)
					or a.ratingPlus <> b.ratingPlus or (a.ratingPlus is null and b.ratingPlus is not null) or (a.ratingPlus is not null and b.ratingPlus is null)
					or a.ratingQ <> b.ratingQ or (a.ratingQ is null and b.ratingQ is not null) or (a.ratingQ is not null and b.ratingQ is null)
					or a.tasteDate <> b.tasteDate or (a.tasteDate is null and b.tasteDate is not null) or (a.tasteDate is not null and b.tasteDate is null)
					or a.tasterN <> b.tasterN or (a.tasterN is null and b.tasterN is not null) or (a.tasterN is not null and b.tasterN is null)
					or a.updateWhN <> b.updateWhN or (a.updateWhN is null and b.updateWhN is not null) or (a.updateWhN is not null and b.updateWhN is null)
					or a.userComplaintCount <> b.userComplaintCount or (a.userComplaintCount is null and b.userComplaintCount is not null) or (a.userComplaintCount is not null and b.userComplaintCount is null)
					or a.whereTastedN <> b.whereTastedN or (a.whereTastedN is null and b.whereTastedN is not null) or (a.whereTastedN is not null and b.whereTastedN is null)
					or a.wineN <> b.wineN or (a.wineN is null and b.wineN is not null) or (a.wineN is not null and b.wineN is null)
				)		  then
	update set 
			   _clumpName=b._clumpName
			, _fixedId=b._fixedId
			, _fixedIdDeleted=b._fixedIdDeleted
			, _x_articleIdNKey=b._x_articleIdNKey
			, _x_hasAGalloniTasting=b._x_hasAGalloniTasting
			, _x_HasCurrentPrice=b._x_HasCurrentPrice
			, _x_hasDSchildknechtTasting=b._x_hasDSchildknechtTasting
			, _x_hasDThomasesTasting=b._x_hasDThomasesTasting
			, _x_hasErpTasting=b._x_hasErpTasting
			, _x_hasJMillerTasting=b._x_hasJMillerTasting
			, _x_hasMSquiresTasting=b._x_hasMSquiresTasting
			, _x_hasMultipleWATastings=b._x_hasMultipleWATastings
			, _x_hasNMartinTasting=b._x_hasNMartinTasting
			, _x_hasProducerProfile=b._x_hasProducerProfile
			, _x_HasProducerWebSite=b._x_HasProducerWebSite
			, _x_hasPRovaniTasting=b._x_hasPRovaniTasting
			, _x_hasRParkerTasting=b._x_hasRParkerTasting
			, _x_hasWJtasting=b._x_hasWJtasting
			, _x_IsActiveWineN=b._x_IsActiveWineN
			, _x_reviewerIdN=b._x_reviewerIdN
			, _x_showForERP=b._x_showForERP
			, _x_showForWJ=b._x_showForWJ
			, articleId=b.articleId
			, articleMasterN=b.articleMasterN
			, articleOrder=b.articleOrder
			, articleURL=b.articleURL
			, bottleSizeN=b.bottleSizeN
			, canBeActiveTasting=b.canBeActiveTasting
			, createDate=b.createDate
			, createWh=b.createWh
			, dataIdN=b.dataIdN
			, dataIdNDeleted=b.dataIdNDeleted
			, dataSourceN=b.dataSourceN
			, decantedN=b.decantedN
			, drinkDate=b.drinkDate
			, drinkDateHi=b.drinkDateHi
			, drinkWhenN=b.drinkWhenN
			, estimatedCostHi=b.estimatedCostHi
			, estimatedCostLo=b.estimatedCostLo
			, hasHad=b.hasHad
			, hasUserComplaint=b.hasUserComplaint
			, isActiveForThisPub=b.isActiveForThisPub
			, isAnnonymous=b.isAnnonymous
			, isApproved=b.isApproved
			, isAvailabeToTastersGroups=b.isAvailabeToTastersGroups
			, IsBarrelTasting=b.IsBarrelTasting
			, isBorrowedDrinkDate=b.isBorrowedDrinkDate
			, isInactive=b.isInactive
			, isMostRecentTasting=b.isMostRecentTasting
			, isNoTasting=b.isNoTasting
			, isPostedToBB=b.isPostedToBB
			, isPrivate=b.isPrivate
			, issue=b.issue
			, maturityN=b.maturityN
			, notes=b.notes
			, originalCurrencyN=b.originalCurrencyN
			, pages=b.pages
			, provenanceN=b.provenanceN
			, pubDate=b.pubDate
			, pubN=b.pubN
			, rating=b.rating
			, ratingHi=b.ratingHi
			, ratingPlus=b.ratingPlus
			, ratingQ=b.ratingQ
			, tasteDate=b.tasteDate
			, tasterN=b.tasterN
			, updateWhN=b.updateWhN
			, userComplaintCount=b.userComplaintCount
			, whereTastedN=b.whereTastedN
			, wineN=b.wineN
when not matched by target then
	insert	(
				  _clumpName
				, _fixedId
				, _fixedIdDeleted
				, _x_articleIdNKey
				, _x_hasAGalloniTasting
				, _x_HasCurrentPrice
				, _x_hasDSchildknechtTasting
				, _x_hasDThomasesTasting
				, _x_hasErpTasting
				, _x_hasJMillerTasting
				, _x_hasMSquiresTasting
				, _x_hasMultipleWATastings
				, _x_hasNMartinTasting
				, _x_hasProducerProfile
				, _x_HasProducerWebSite
				, _x_hasPRovaniTasting
				, _x_hasRParkerTasting
				, _x_hasWJtasting
				, _x_IsActiveWineN
				, _x_reviewerIdN
				, _x_showForERP
				, _x_showForWJ
				, articleId
				, articleMasterN
				, articleOrder
				, articleURL
				, bottleSizeN
				, canBeActiveTasting
				, createDate
				, createWh
				, dataIdN
				, dataIdNDeleted
				, dataSourceN
				, decantedN
				, drinkDate
				, drinkDateHi
				, drinkWhenN
				, estimatedCostHi
				, estimatedCostLo
				, hasHad
				, hasUserComplaint
				, isActiveForThisPub
				, isAnnonymous
				, isApproved
				, isAvailabeToTastersGroups
				, IsBarrelTasting
				, isBorrowedDrinkDate
				, isInactive
				, isMostRecentTasting
				, isNoTasting
				, isPostedToBB
				, isPrivate
				, issue
				, maturityN
				, notes
				, originalCurrencyN
				, pages
				, provenanceN
				, pubDate
				, pubN
				, rating
				, ratingHi
				, ratingPlus
				, ratingQ
				, tasteDate
				, tasterN
				, updateWhN
				, userComplaintCount
				, whereTastedN
				, wineN			)
		values		
			(
				  _clumpName
				, _fixedId
				, _fixedIdDeleted
				, _x_articleIdNKey
				, _x_hasAGalloniTasting
				, _x_HasCurrentPrice
				, _x_hasDSchildknechtTasting
				, _x_hasDThomasesTasting
				, _x_hasErpTasting
				, _x_hasJMillerTasting
				, _x_hasMSquiresTasting
				, _x_hasMultipleWATastings
				, _x_hasNMartinTasting
				, _x_hasProducerProfile
				, _x_HasProducerWebSite
				, _x_hasPRovaniTasting
				, _x_hasRParkerTasting
				, _x_hasWJtasting
				, _x_IsActiveWineN
				, _x_reviewerIdN
				, _x_showForERP
				, _x_showForWJ
				, articleId
				, articleMasterN
				, articleOrder
				, articleURL
				, bottleSizeN
				, canBeActiveTasting
				, createDate
				, createWh
				, dataIdN
				, dataIdNDeleted
				, dataSourceN
				, decantedN
				, drinkDate
				, drinkDateHi
				, drinkWhenN
				, estimatedCostHi
				, estimatedCostLo
				, hasHad
				, hasUserComplaint
				, isActiveForThisPub
				, isAnnonymous
				, isApproved
				, isAvailabeToTastersGroups
				, IsBarrelTasting
				, isBorrowedDrinkDate
				, isInactive
				, isMostRecentTasting
				, isNoTasting
				, isPostedToBB
				, isPrivate
				, issue
				, maturityN
				, notes
				, originalCurrencyN
				, pages
				, provenanceN
				, pubDate
				, pubN
				, rating
				, ratingHi
				, ratingPlus
				, ratingQ
				, tasteDate
				, tasterN
				, updateWhN
				, userComplaintCount
				, whereTastedN
				, wineN			
			)				
when not matched by source 
		and dataSourceN is not null 
			and dataSourceN in (select dataSourceN from @TSources)
			and dataIdN is not null 
			and (dataIdnDeleted is null or dataIdnDeleted <> 1) then
		update set 
			a.dataIdnDeleted = 1;			    
 
exec dbo.ooLog '     @1 Tastings updated',@@rowCount
 
/*
--CalcTasting code in trigger.  Not needed herse
exec calcTasting
exec dbo.ooLog '     calcTasting updated (@1 rows)', @@ROWCOUNT
*/
 
exec updateSpeed
exec dbo.ooLog '     Speed updated (@1 rows)',@@rowCount
 
exec dbo.oolog 'update2TastingStep2 end'; 
end
 
 
