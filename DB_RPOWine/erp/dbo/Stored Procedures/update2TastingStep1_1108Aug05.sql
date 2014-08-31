CREATE proc [dbo].update2TastingStep1_1108Aug05 as begin
 
------------------------------------------------------------------------------------------------------------------------------
-- Init
------------------------------------------------------------------------------------------------------------------------------ 
exec dbo.ooLog '     before update2TastingStep1]'
 
truncate table erpIn..tastingNew		--vTastingNew
 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Main Update
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
declare @dataSourceErp int
select @dataSourceErp = whN from wh where tag = 'pubWa'
 
insert into vTastingNew     (
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
			,joinX
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
			,0
			,0
			,joinX
	from veWine
  
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
	from vTastingNew a
		join veWine b
			on a._fixedId = b.fixedId     
		left join wh c
			on b.whoUpdated = c.tag     
		left join wh d
			on 	d.tag = 'dwf'
		left join wh e
			on e.tag = 'mlb'	  
 
--select updateWhN, count(*) from vTastingNew group by updateWhN
 
 
 
------------------------------------------------------------------------------------------
--PubN     Never put the following two together - the or condition in the join is staggeringly inefficient 
------------------------------------------------------------------------------------------												
--select distinct(publication) from veWine
--select disu
 update a set pubN = isNull(aliasOfWhn, whN)
	from vTastingNew a
		join veWine b
			on a._fixedId = b.fixedId
		join wh c
			on b.publication = c.fullName
	where a.pubN is null
 
 update a set pubN = isNull(aliasOfWhn, whN)
	from vTastingNew a
		join veWine b
			on a._fixedId = b.fixedId
		join wh c
			on b.publication= c.displayName
	where a.pubN is null
 
--select erp.dbo.getName(pubN), count(*) cnt from vTastingNew group by pubN order by cnt desc
--select erp.dbo.getName(tasterN), count(*) cnt from vTastingNew group by tasterN order by cnt desc
 
 
------------------------------------------------------------------------------------------
--TasterN     Never put the following two together - the or condition in the join is staggeringly inefficient 
------------------------------------------------------------------------------------------												
update a set tasterN = whN
	from vTastingNew a
		join veWine b
			on a._fixedId = b.fixedId
		join wh c
			on b.[source] = c.fullName
	where tasterN is null
 
update a set tasterN = whN
	from vTastingNew a
		join veWine b
			on a._fixedId = b.fixedId
		join wh c
			on b.[source]= c.displayName
	where tasterN is null
 
--select erp.dbo.getName(tasterN), count(*) cnt from vTastingNew group by tasterN order by cnt desc
 
 
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
	from vTastingNew a
		join veWine b
			on a._fixedId = b.fixedId
		left join bottleSizeAlias c
			on c.alias = dbo.superTrim(b.bottleSize)
		join bottleSize d
			on d.litres = 0.75
 
------------------------------------------------------------------------------------------------------------------------------
-- proTasting flag
------------------------------------------------------------------------------------------------------------------------------
update a 
	set a.isProTasting = isNull(b.isProfessionalTaster, 0)
	from vTastingNew a
		left join wh b
			on a.pubN = b.whN
			
	
 
------------------------------------------------------------------------------------------------------------------------------
-- Update WineNameN
------------------------------------------------------------------------------------------------------------------------------
update a set a.wineNameN=b.wineNameN
	from vTastingNew a
		join erp..wine b
			on a.wineN=b.wineN
	where a.wineNameN <> b.wineNameN or (a.wineNameN is null and b.wineNameN is not null) or (a.wineNameN is not null and b.wineNameN is null)
 
exec dbo.ooLog '     after update2TastingStep1]'
 
end
 
 
 
 
 
 
 
 
 
 
