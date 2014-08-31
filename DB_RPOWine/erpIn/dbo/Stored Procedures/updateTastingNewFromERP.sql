CREATE proc updateTastingNewFromERP
as begin
/*
use erpin 

verify
	oodef	vWh
	oodef	vWineFromRpo
	oodef	vBottleSize 
 
ov1 tastingNew

select * from tastingNew where issue='190'
select pubN, count(*) from tastingNew group by pubN
select erp11.dbo.getName2(pubN), count(*) from tastingNew group by pubN
select erp11.dbo.getName2(pubN), count(*) from erp11..tasting group by pubN
ooi tastingNew, data
 
select top 1 * into T2 from erp11..tasting
select oFieldsIntersectConcat('t2','tastingNew')
select dbo.oFieldsIntersectConcat ('wine','wine')
select dbo.oFieldsIntersectConcat ('tastingNew','t2')
 
create view vv as
select top 8		articleMasterN,articleOrder,articleURL,bottleSizeN,canBeActiveTasting,createDate,createWh,dataIdN,dataIdNDeleted,dataSourceN,decantedN,drinkDate,drinkDateHi,drinkWhenN,estimatedCostHi,estimatedCostLo,hasHad,hasRating,hasUserComplaint,isActiveForThisPub,isAnnonymous,isApproved,isAvailabeToTastersGroups,IsBarrelTasting,isBorrowedDrinkDate,isErpTasting,isInactive,isMostRecentTasting,isNoTasting,isPostedToBB,isPrivate,isProTasting,issue,maturityN,notes,originalCurrencyN,pages,ParkerZralyLevel,provenanceN,pubDate,pubN,rating,ratingHi,ratingPlus,ratingQ,ratingShow,rowversion,sourceIconN,tasteDate,tasterN,tastingN,updateDate,updateWhN,userComplaintCount,vinN,whereTastedN,wineN,wineNameN,_clumpName,_fixedId,_fixedIdDeleted,_x_articleIdNKey,_x_hasAGalloniTasting,_x_HasCurrentPrice,_x_hasDSchildknechtTasting,_x_hasDThomasesTasting,_x_hasErpTasting,_x_hasJMillerTasting,_x_hasMSquiresTasting,_x_hasMultipleWATastings,_x_hasNMartinTasting,_x_hasProducerProfile,_x_HasProducerWebSite,_x_hasPRovaniTasting,_x_hasRParkerTasting,_x_hasWJtasting,_x_IsActiveWineN,_x_reviewerIdN,_x_showForERP,_x_showForWJ,articleId
	from tastingNew where issue='190'
union
select top 8		articleMasterN,articleOrder,articleURL,bottleSizeN,canBeActiveTasting,createDate,createWh,dataIdN,dataIdNDeleted,dataSourceN,decantedN,drinkDate,drinkDateHi,drinkWhenN,estimatedCostHi,estimatedCostLo,hasHad,hasRating,hasUserComplaint,isActiveForThisPub,isAnnonymous,isApproved,isAvailabeToTastersGroups,IsBarrelTasting,isBorrowedDrinkDate,isErpTasting,isInactive,isMostRecentTasting,isNoTasting,isPostedToBB,isPrivate,isProTasting,issue,maturityN,notes,originalCurrencyN,pages,ParkerZralyLevel,provenanceN,pubDate,pubN,rating,ratingHi,ratingPlus,ratingQ,ratingShow,rowversion,sourceIconN,tasteDate,tasterN,tastingN,updateDate,updateWhN,userComplaintCount,vinN,whereTastedN,wineN,wineNameN,_clumpName,_fixedId,_fixedIdDeleted,_x_articleIdNKey,_x_hasAGalloniTasting,_x_HasCurrentPrice,_x_hasDSchildknechtTasting,_x_hasDThomasesTasting,_x_hasErpTasting,_x_hasJMillerTasting,_x_hasMSquiresTasting,_x_hasMultipleWATastings,_x_hasNMartinTasting,_x_hasProducerProfile,_x_HasProducerWebSite,_x_hasPRovaniTasting,_x_hasRParkerTasting,_x_hasWJtasting,_x_IsActiveWineN,_x_reviewerIdN,_x_showForERP,_x_showForWJ,articleId
	from erp11..tasting where issue='180'
 
select wineNameN, count(*) cnt from tastingNew group by wineNameN order by cnt desc
 
select * from vv
select wineNameN, count(*) cnt from erp11..tasting where issue='180' group by wineNameN order by cnt desc
select distinct wineN from erp11..tasting
except
select distinct wineN from erp11..wine
 
oof ofield
oofr
 
*/
 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Make sure all publications and sources are in wh with tags
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*     not needed for now
declare @ok bit
exec dbo.checkForErpInWh  @ok = @ok output
if @ok <> 1 return
*/
 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Main Update
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
declare @dataSourceErp int
select @dataSourceErp = whN from vWh where tag = 'pubWa'
 
truncate table tastingNew;
 
insert into tastingNew     (
			------------------------------------------------------------------------------------------
			-- Target Fields
			------------------------------------------------------------------------------------------
			dataSourceN
			,dataIdN
			,dataIdNDeleted 
 
			,ArticleId
			,_x_articleIdNKey
			,articleMasterN
			,ArticleOrder
			--,bottleSizeN
			,canBeActiveTasting
			,_clumpName
			,updateDate
			--,updateWhN
			,drinkDate
			,drinkDateHi
			,estimatedCostLo
			,estimatedCostHi
			,_fixedId
			,_x_hasAGalloniTasting
			,_x_HasCurrentPrice
			,_x_hasDSchildknechtTasting
			,_x_hasDThomasesTasting
			,_x_hasErpTasting
			,_x_hasJMillerTasting
			,_x_hasMSquiresTasting
			,_x_hasMultipleWATastings
			,_x_hasNMartinTasting
			,_x_hasProducerProfile
			,_x_HasProducerWebSite
			,_x_hasPRovaniTasting
			,_x_hasRParkerTasting
			,_x_hasWJtasting
			,_x_IsActiveWineN
			,IsBarrelTasting
			,isBorrowedDrinkDate
			,isErpTasting
			,isMostRecentTasting
			,isNoTasting
			,Issue
			,maturityN	--same value, better name
			,Notes
			,Pages
			,Rating
			,RatingHi
			,RatingQ
			,RatingShow
			,_x_ReviewerIdN
			,_x_showForERP
			,_x_showForWJ
			--,tasterN	--Transform
			,pubDate
			,tasteDate
			,VinN
			,wineN   
			,isAnnonymous
			,isPrivate  
			)
Select
			------------------------------------------------------------------------------------------
			-- Source fields
			------------------------------------------------------------------------------------------
			@dataSourceErp	--dataSourceN
			,fixedId				--dataIdN
			,0						--dataIdNDeleted 
 
			,ArticleId
			,ArticleIdNKey
			,articleMasterN
			,ArticleOrder
			--,dbo.updateTranslateToBottleSizeN(BottleSize)
			,canBeActiveTasting
			,clumpName
			,DateUpdated
			--, @dataSourceErp
			,DrinkDate
			,DrinkDate_Hi
			,EstimatedCost
			,EstimatedCost_Hi
			,FixedId
			,hasAGalloniTasting
			,HasCurrentPrice
			,hasDSchildknechtTasting
			,hasDThomasesTasting
			,hasErpTasting
			,hasJMillerTasting
			,hasMSquiresTasting
			,hasMultipleWATastings
			,hasNMartinTasting
			,hasProducerProfile
			,HasProducerWebSite
			,hasPRovaniTasting
			,hasRParkerTasting
			,hasWJtasting
			,IsActiveWineN
			,IsBarrelTasting
			,isBorrowedDrinkDate
			,isErpTasting
			,isMostRecentTasting
			,isNoTasting
			,Issue
			,Maturity
			,Notes
			,Pages
			,Rating
			,Rating_Hi
			,RatingQ
			,RatingShow
			,ReviewerIdN
			,showForERP
			,showForWJ
			--,dbo.updateTranslateToTasterN([Source])
			,SourceDate
			,tasteDate
			,VinN
			,WineN
			,1
			,1
	from vWineFromRpo
 
------------------------------------------------------------------------------------------
-- Adjust fields In bulk
------------------------------------------------------------------------------------------ 
 
update a set updateWhN =
		case when c.whN is not null then
			c.whN
		else
			case 
				when b.whoUpdated = 'mark' then
					e.whN
				when b.whoUpdated in ('doug', 'doug2') then
					d.whn
				end
		end
	from tastingNew a
		join vWineFromRpo b
			on a._fixedId = b.fixedId     
		left join vWh c
			on b.whoUpdated = c.tag     
		left join vWh d
			on 	d.tag = 'dwf'
		left join vWh e
			on e.tag = 'mlb'	  
 
--select updateWhN, count(*) from tastingNew group by updateWhN
 
 
 
------------------------------------------------------------------------------------------
--PubN     Never put the following two together - the or condition in the join is staggeringly inefficient 
------------------------------------------------------------------------------------------												
--select distinct(publication) from vWineFromRpo
--select disu
 update a set pubN = whN
	from tastingNew a
		join vWineFromRpo b
			on a._fixedId = b.fixedId
		join vWh c
			on b.publication = c.fullName
	where a.pubN is null
 
update a set pubN = whN
	from tastingNew a
		join vWineFromRpo b
			on a._fixedId = b.fixedId
		join vWh c
			on b.publication= c.displayName
	where a.pubN is null
 
--select erp.dbo.getName(pubN), count(*) cnt from tastingNew group by pubN order by cnt desc
--select erp.dbo.getName(tasterN), count(*) cnt from tastingNew group by tasterN order by cnt desc
 
 
------------------------------------------------------------------------------------------
--TasterN     Never put the following two together - the or condition in the join is staggeringly inefficient 
------------------------------------------------------------------------------------------												
update a set tasterN = whN
	from tastingNew a
		join vWineFromRpo b
			on a._fixedId = b.fixedId
		join vWh c
			on b.[source] = c.fullName
	where tasterN is null
 
update a set tasterN = whN
	from tastingNew a
		join vWineFromRpo b
			on a._fixedId = b.fixedId
		join vWh c
			on b.[source]= c.displayName
	where tasterN is null
 
--select erp.dbo.getName(tasterN), count(*) cnt from tastingNew group by tasterN order by cnt desc
 
 
------------------------------------------------------------------------------------------
-- BottleSize
------------------------------------------------------------------------------------------
update a
	set a.bottleSizeN= 
		case
			when c.bottleSizeN is null then
				d.bottleSizeN	--Standard Bottle Size from BottleSize table
			else
				c.bottleSizeN
		end
	from tastingNew a
		join vWineFromRpo b
			on a._fixedId = b.fixedId
		left join bottleSizeAlias c
			on c.alias = dbo.superTrim(b.bottleSize)
		join vBottleSize d
			on d.litres = 0.75
 
------------------------------------------------------------------------------------------------------------------------------
-- proTasting flag
------------------------------------------------------------------------------------------------------------------------------
update a 
	set a.isProTasting = isNull(b.isProfessionalTaster, 0)
	from tastingNew a
		left join vWh b
			on a.pubN = b.whN
			
	
 
------------------------------------------------------------------------------------------------------------------------------
-- Update WineNameN
------------------------------------------------------------------------------------------------------------------------------
update a set a.wineNameN=b.wineNameN
	from tastingNew a
		join erp..wine b
			on a.wineN=b.wineN

 
 
------------------------------------------------------------------------------------------
-- Fields not transfered
------------------------------------------------------------------------------------------
/*
--ArticleOrder
--EntryN
--erpTastingCount
--isActiveT
--IsActiveTasting
--isActiveWineN_old
--isActiveWineN2
--isActiveWineNRpwacm
--IsCurrentlyForSale
--isCurrentlyOnAuction
--IsERPName
--isWjTasting
--joinA
--joinX
--LabelName
--mostRecentAuctionPrice
--mostRecentAuctionPriceCnt
--mostRecentAuctionPriceHi
--MostRecentPrice
--MostRecentPriceCnt
--MostRecentPriceHi
--notesLen
--originalEstimatedCost
--originalEstimatedCost_hi
--Producer
--ProducerProfileFileName
--ProducerShow
--ProducerURL
--ShortLabelName
--Site
--SomeYearHasPrices
--TastingCount
--ThisYearHasPrices
--Vin
--WineNameIdN
--wineNameN
--WineType
*/
end
 
 
