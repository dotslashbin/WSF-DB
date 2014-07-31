CREATE view [vTastingE] as
select a.pubGN,a.tastingN,a.wineN,a.vinN,a.wineNameN,a.pubN,a.tasterN,b.activeVinn,b.namerWhN,b.producer,b.producerProfileFile,b.producerShow,b.producerURL,b.labelName,b.colorClass,b.variety,b.dryness,b.wineType,b.country,b.locale,b.location,b.region,b.site,b.places,b.encodedKeyWords,b.dateLo,b.dateHi,b.vintageLo,b.vintageHi,b.wineCount,b.joinX,b.createDate,b.createWh,b.updateWh,b.rowversion,b.isInactive,c.pubDate,c.issue,c.pages,c.articleId,c.articleIdNKey,c.articleOrder,c.articleURL,c.notes,c.tasteDate,c.isMostRecentTasting,c.isNoTasting,c.isActiveForThisPub,c._x_IsActiveWineN,c.isBorrowedDrinkDate,c.IsBarrelTasting,c.bottleSizeN,c.rating,c.ratingPlus,c.ratingHi,c.ratingShow,c.drinkDate,c.drinkDateHi,c.drinkWhenN,c.maturity,c.estimatedCost,c.estimatedCostHi,c.originalCurrencyN,c.provenanceN,c.whereTastedN,c.decantedHours,c.isAvailabeToTastersGroups,c.isPostedToBB,c.isAnnonymous,c.isPrivate,c.updateWhN,c._clumpName,c._fixedId,c._x_hasAGalloniTasting,c._x_HasCurrentPrice,c._x_hasDSchildknechtTasting,c._x_hasDThomasesTasting,c._x_hasErpTasting,c._x_hasJMillerTasting,c._x_hasMSquiresTasting,c._x_hasMultipleWATastings,c._x_hasNMartinTasting,c._x_hasProducerProfile,c._x_HasProducerWebSite,c._x_hasPRovaniTasting,c._x_hasRParkerTasting,c._x_hasWJtasting,c._x_reviewerIdN,c.ratingQ,d.whN,d.memberId,d.sortName,d.displayName,d.shortName,d.tag,d.address,d.city,d.state,d.postalCode,d.phone,d.fax,d.email,d.createWhN,d.comments,d.isGroup,d.isLocation,d.isPub,d.isProfessionalTaster,d.isErpMember,d.isRetailer,d.isImporter,d.isWinery,d.isWineMaker,d.isEditor
	from vwFastPubGToTasting a
		join winename b
			on b.wineNameN = a.wineNameN
		join tasting c
			on c.tastingN = a.tastingN
		join wh d
			on d.whN = a.pubN
