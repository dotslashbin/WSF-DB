-- database doug interface userInterface xx [=]
CREATE function fWine ( 
		 @keywords varchar(500)
		,@MustBeCurrentlyForSale bit
		,@IncludeAuctions bit
		,@MustHaveReviewInThisPubG bit
		,@MyWinesN int
		,@PriceGN int
		,@PubGN int
		,@Where varchar(max) 
		,@OrderBy varchar(max)
		,@GroupBy varchar(max)
		,@MaxResultCount int
        )

returns @TT table(wineN int, vintage varChar(4),producer varChar(150), producerShow varChar(150), producerURL varChar(500),producerProfileFile varChar(150), labelName varChar(150),country varChar(150), region varChar(150), location varChar(150), locale varChar(150), site varChar(150), places varChar(150),variety varChar(100), colorClass varChar(20), dryness varChar(30), wineType varChar(30),priceLo money,priceHi money,priceCnt int,tastingN int ,pubIconN int,rating int, ratingShow varChar(30), maturity int)
 as begin
--------------------------------------------------------------
-- Switch between the alternatives
--------------------------------------------------------------

if @MustHaveReviewInThisPubG = 1
	if @MyWinesN > 0
		if len(@Where) > 0  
			goto Review1_MyWines1_Where1
		else 
			goto Review1_MyWines1_Where0
	else
		if len(@Where) > 0  
			goto Review1_MyWines0_Where1
		else 
			goto Review1_MyWines0_Where0
else
	if @MyWinesN > 0
		if len(@Where) > 0  
			goto Review0_MyWines1_Where1
		else 
			goto Review0_MyWines1_Where0
	else
		if len(@Where) > 0  
			goto Review0_MyWines0_Where1
		else 
			goto Review0_MyWines0_Where0

--------------------------------------------------------------
Review1_MyWines1_Where1: 
--------------------------------------------------------------
	goto SortBeforeReturn


--------------------------------------------------------------
Review1_MyWines1_Where0: 
--------------------------------------------------------------
	goto SortBeforeReturn


--------------------------------------------------------------
Review1_MyWines0_Where1: 
--------------------------------------------------------------
	goto SortBeforeReturn


--------------------------------------------------------------
Review1_MyWines0_Where0: 
--------------------------------------------------------------
	goto SortBeforeReturn


--------------------------------------------------------------
Review0_MyWines1_Where1: 
--------------------------------------------------------------
	goto SortBeforeReturn


--------------------------------------------------------------
Review0_MyWines1_Where0: 
--------------------------------------------------------------
	goto SortBeforeReturn


--------------------------------------------------------------
Review0_MyWines0_Where1: 
--------------------------------------------------------------
	goto SortBeforeReturn


--------------------------------------------------------------
Review0_MyWines0_Where0: 
--------------------------------------------------------------
insert into @TT(wineN, vintage,producer, producerShow, producerURL,producerProfileFile, labelName,country, region, location, locale, site, places,variety, colorClass, dryness, wineType,priceLo,priceHi,priceCnt,tastingN ,pubIconN,rating, ratingShow, maturity)
	select
		a.wineN, a.vintage
		,b.producer, b.producerShow, b.producerURL,b.producerProfileFile
		,b.labelName
		,b.country, b.region, b.location, b.locale, b.site, b.places
		,b.variety, b.colorClass, b.dryness, b.wineType
		,isNull (d.mostRecentPriceLo, a.estimatedCostLo) priceLo
		,isNull (d.mostRecentPriceHi, a.estimatedCostHi) priceHi
		,isNull(d.mostRecentPriceCnt, 0) priceCnt
		,a.tastingN 
		,c.pubIconN
		,c.rating, c.ratingShow, c.maturity
	from 
		wine a 
		join wineName b 
			on a.wineNameN = b.wineNameN
		join mapPubGToWine c
			on c.wineN = a.wineN 
		left join price d
			on a.wineN = d.wineN
	where
		contains (a.encodedKeywords, @keywords)
		and 
			(d.wineN is null
				or (includesNotForSaleNow = 1 
						and includesAuction = d.includesAuction		
						and priceGN = @PriceGN)
				)
		and pubGN = @PubGN
	order by rating desc, producer, labelName, vintage desc


	goto SortBeforeReturn


--------------------------------------------------------------
SortBeforeReturn:
--------------------------------------------------------------
                          
/* TEST

select * from fWine (
		 ' "petrus*"  '	--@keywords varchar(500)
		,1						--@MustBeCurrentlyForSale bit
		,1						--@IncludeAuctions bit
		,0						--@MustHaveReviewInThisPubG bit
		,null					--@MyWinesN int
		,18220				--@PriceGN erpRetailAll
		,18223				--@PubGN	/	erp excluding Neal
		,null					--@Where varchar(max) 
		,null					--@OrderBy varchar(max)
		,null					--@GroupBy varchar(max)
		,500					--@MaxResultCount int
		)




*/


return
end
