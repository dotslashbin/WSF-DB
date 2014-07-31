--doug larisa todo [=]
CREATE procedure [dbo].[z_todoDevelopViewsForLarisa] as begin set nocount on


--remove extraneous views, keep big pubG one

/*
join 
	prices
	winename
	wine
	tasting
	pubGToPub
	retailerGtoWine

select
		 a.pubGN,a.tastingN,a.wineN,a.vinN,a.wineNameN,a.pubN,a.tasterN
		,b.activeVinn,b.namerWhN,b.producer,b.producerProfileFile,b.producerShow,b.producerURL,b.labelName,b.colorClass,b.variety,b.dryness,b.wineType,b.country,b.locale,b.location,b.region,b.site,b.places,b.encodedKeyWords,b.dateLo,b.dateHi,b.vintageLo,b.vintageHi,b.wineCount,b.joinX,b.createDate,b.createWh,b.updateWh,b.rowversion,b.isInactive
		,c.pubDate,c.issue,c.pages,c.articleId,c.articleIdNKey,c.articleOrder,c.articleURL,c.notes,c.tasteDate,c.isMostRecentTasting,c.isNoTasting,c.isActiveForThisPub,c._x_IsActiveWineN,c.isBorrowedDrinkDate,c.IsBarrelTasting,c.bottleSizeN,c.rating,c.ratingPlus,c.ratingHi,c.ratingShow,c.drinkDate,c.drinkDateHi,c.drinkWhenN,c.maturity,c.estimatedCost,c.estimatedCostHi,c.originalCurrencyN,c.provenanceN,c.whereTastedN,c.decantedHours,c.isAvailabeToTastersGroups,c.isPostedToBB,c.isAnnonymous,c.isPrivate,c.updateWhN,c._clumpName,c._fixedId,c._x_hasAGalloniTasting,c._x_HasCurrentPrice,c._x_hasDSchildknechtTasting,c._x_hasDThomasesTasting,c._x_hasErpTasting,c._x_hasJMillerTasting,c._x_hasMSquiresTasting,c._x_hasMultipleWATastings,c._x_hasNMartinTasting,c._x_hasProducerProfile,c._x_HasProducerWebSite,c._x_hasPRovaniTasting,c._x_hasRParkerTasting,c._x_hasWJtasting,c._x_reviewerIdN,c.ratingQ,d.whN,d.memberId,d.sortName,d.displayName,d.shortName,d.tag,d.address,d.city,d.state,d.postalCode,d.phone,d.fax,d.email,d.createWhN,d.comments,d.isGroup,d.isLocation,d.isPub,d.isProfessionalTaster,d.isErpMember,d.isRetailer,d.isImporter,d.isWinery,d.isWineMaker,d.isEditor
		,,e.priceGN,e.includesNotForSaleNow,e.includesAuction,e.mostRecentPriceLo,e.mostRecentPriceHi,e.mostRecentPriceCnt
	from vwFastPubGToTasting a
		join winename b
			on b.wineNameN = a.wineNameN
		join tasting c
			on c.tastingN = a.tastingN
		join wh d
			on d.whN = a.pubN
		...
		join price e
			...


oo nvt, towine 

select w.displayName , cnt
	from (select 
					a
					, count(1) cnt 
				from mapWhToWine 
				group by a) z
		join wh w
			on z.a = w.whN
		where w.displayName is not null

oo o, mapwhtowine

select count(*) from mapWhToWine 
		where a in (select whn from wh where isRetailer = 1 and isGroup = 0)

------------------------------------------------
--Update mapWhToWine
------------------------------------------------

--mapWhToWine Update
delete from mapWhToWine where a = dbo.getpubn('erpPub')
insert into mapWhToTasting (a, b) 
		select dbo.getpubn('erpPub'), tastingN
			from tasting t 
			join mapPubGToPub m
				on t.pubN = m.b


PROBLEM mapWhToTasting doesn''t include Neal(6)

insert into mapWhToWine(a, b)
	select a, b from vwMapPubToTastingToWine  z
		where a in (select distinct a from mapPubGToPub)
			and not exists (select * from mapWhToWine where a = z.a and b = z.b)

declare @pub int; select @pub = whn from wh where tag = 'erpPub'
delete from mapWhToWine
	where not exists (select * from vwWhToWineMap where a = mapWhToWine.a and b = mapWhToWine.b)
		and a = @pub




????
oooi ' price ', ''








*/

end
