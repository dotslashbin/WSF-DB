
 ------------------------------------------------------------------------------------------------------------------------------
-- use erp			--DonRuso
-- use x
------------------------------------------------------------------------------------------------------------------------------
CREATE function [dbo].[wineSQL_before13March2011] ( 
	 @Select varChar(max)
	,@maxRows int = 100
	,@Where varchar(max) = ''
	,@GroupBy varchar(max) = ''
	,@OrderBy varchar(max) = ''
	,@PubGN int = Null
	,@MustHaveReviewInThisPubG int = 0
	,@PriceGN int = Null
	,@MustBeCurrentlyForSale bit = 0
	,@IncludeAuctions bit = 0
	,@whN int = Null
	,@doFlagMyBottlesAndTastings bit = 0
	,@doGetAllTastings bit = 0
	,@mustBeTrustedTaster int = 0	--set to -1 for special case of trying to get only tasting that don't have a trusted taster (The "Other Tasting" option on the Rating Tab)
)
returns varchar(max)
as begin
declare @trace varchar(max)='--Trace'
-------------------------------------------------------------------------------------
-- Fixup arguments since initializing bits doesn't work
-------------------------------------------------------------------------------------
Select 
	 @MustHaveReviewInThisPubG = isnull(@MustHaveReviewInThisPubG,0)
	,@MustBeCurrentlyForSale = isnull(@MustBeCurrentlyForSale,0)
	,@IncludeAuctions = 0	     --For now, we NEVER use auction prices.  We may remove this argument eventuallyww 
	,@doFlagMyBottlesAndTastings = isnull(@doFlagMyBottlesAndTastings,0)
	,@doGetAllTastings = isnull(@doGetAllTastings, 0)
	,@mustBeTrustedTaster = isnull(@mustBeTrustedTaster,0)
 
-------------------------------------------------------------------------------------
-- Constants - Cross check with other parts of system
-------------------------------------------------------------------------------------
declare @iconWA nvarchar = '1', @iconWJ nvarchar = '2', @iconMy nvarchar = '3', @iconMyT nvarchar = '4', @iconMyB nvarchar = '5', @iconMyBT nvarchar = '6', @iconForSaleNow nvarchar = '7', @iconHasTrusted nvarchar = '8', @iconHasTasting nvarchar = '9' --, @iconPZ1 nchar(2) = '10', @iconPZ2 nchar(2) = '11', @iconPZ3 nchar(2) = '12' 
declare @pubGNWineAdvocate int = 18223, @pubGNWineAdvocates int = 18240, @priceGNAllRetailers int=18220
 
-- "Must Have" incompatiblble with null whN
if isNull(@whN,0) < 1 set @mustBeTrustedTaster=0;
 
--limit pubGN to just wineAdvocate or wineAdvocates
if isNull(@pubGN, 0) <> @pubGNWineAdvocates
	set @pubGN = @pubGNWineAdvocate
 
 
-------------------------------------------------------------------------------------
-- Fields needed
-------------------------------------------------------------------------------------
declare @select2 varchar(max), @ss varchar(5000)='', @sf varchar(5000)='', @sm varchar(5000)='', @sx varchar(max), @R varchar(5000)='', @allTastings bit=0, @Errors varchar(max)=null
 declare @where1 varChar(max) = null, @where2 varChar(max) = null, @wherex varchar(max) = null
 
 
-------------------------------------------------------------------------------------
-- Normalize
-------------------------------------------------------------------------------------
--'  '
--if @doGetAllTastings <> 0 and @mustBeTrustedTaster = -1 begin
--	-- special case to handle the Other option on the Rating tab
--	set @mustBeTrustedTaster = 1
--	set @mustNotBeTrustedTaster = 1
--end
 
set @Select2 = replace(@Select, ' ', ' ')		--replace space look-alike with true space
set @Select2 = replace(@Select2, '     ', ' ')
set @Select2 = replace(@Select2, '   ', ' ')
set @Select2 = replace(@Select2, '  ', ' ')
 
--remove leading select 
set @Select2 = replace('|' + LTrim(@Select2), '|Select ', '')
set @Select2 = ',' + replace(@Select2, ' ','') + ','
set @Select2 = replace(@Select2, ',,', ',')
set @ss = @Select2
 
declare @te bit=0, @tf bit=0, @tg bit=0, @th bit=0, @ti bit=0, @tj bit=0, @tk bit=0, @tm bit=0, @tn bit = 0
 
if 0<>charIndex(',wineN,', @Select2) begin set @ss = replace(@ss, ',wineN,',',a.wineN,') end
if 0<>charIndex(',vintage,', @Select2) begin set @ss = replace(@ss, ',vintage,',',a.vintage,') end
if 0<>charIndex(',estimatedCostLo,', @Select2) begin set @ss = replace(@ss, ',estimatedCostLo,',',a.estimatedCostLo,') end
if 0<>charIndex(',estimatedCostHi,', @Select2) begin set @ss = replace(@ss, ',estimatedCostHi,',',a.estimatedCostHi,') end
if 0<>charIndex(',maturity,', @Select2) begin set @ss = replace(@ss, ',maturity,',',e.maturityN maturity,') end
 
if 0<>charIndex(',vintageSort,', @Select2) begin set @ss = replace(@ss, ',vintageSort,',',isnull(a.vintage, '''') vintageSort,') end
if 0<>charIndex(',producer,', @Select2) begin set @ss = replace(@ss, ',producer,',',b.producer,') end
if 0<>charIndex(',producerShow,', @Select2) begin set @ss = replace(@ss, ',producerShow,',',b.producerShow,') end
if 0<>charIndex(',producerURL,', @Select2) begin set @ss = replace(@ss, ',producerURL,',',j.currentURL producerURL,'); set @tj = 1 end
if 0<>charIndex(',producerProfileFile,', @Select2) begin set @ss = replace(@ss, ',producerProfileFile,',',b.producerProfileFile,'); set @tj = 1 end
if 0<>charIndex(',labelName,', @Select2) begin set @ss = replace(@ss, ',labelName,',',b.labelName,') end
if 0<>charIndex(',country,', @Select2) begin set @ss = replace(@ss, ',country,',',b.country,') end
if 0<>charIndex(',region,', @Select2) begin set @ss = replace(@ss, ',region,',',b.region,') end
if 0<>charIndex(',location,', @Select2) begin set @ss = replace(@ss, ',location,',',b.location,') end
 
if 0<>charIndex(',fullWineName,', @Select2) begin set @ss = replace(@ss, ',fullWineName,',',(b.producerShow+isnull(('' '' + b.labelName), '''')) fullWineName,') end
 
--if 0<>charIndex(',fullWineNamePlus,', @Select2) begin set @ss = replace(@ss, ',fullWineNamePlus,',',(b.producerShow+isnull(('' ''+b.labelName),'''')+isNull(''(''+isNull(colorClass+'', '','''')+isNull(isNull(site,isNull(locale,isNull(location,isNull(region,isNull(country,''''))))),'''')+'')'',''''))fullWineNamePlus,') end
if 0<>charIndex(',fullWineNamePlus,', @Select2) begin set @ss = replace(@ss, ',fullWineNamePlus,',',(b.producerShow+isnull(('' ''+b.labelName),'''')+isNull(''(''+isNull(colorClass+'', '','''')+isNull(isNull(b.site,isNull(b.locale,isNull(b.location,isNull(b.region,isNull(b.country,''''))))),'''')+'')'',''''))fullWineNamePlus,') end
 
if 0<>charIndex(',locale,', @Select2) begin set @ss = replace(@ss, ',locale,',',b.locale,') end
if 0<>charIndex(',site,', @Select2) begin set @ss = replace(@ss, ',site,',',b.site,') end
if 0<>charIndex(',variety,', @Select2) begin set @ss = replace(@ss, ',variety,',',b.variety,') end
if 0<>charIndex(',colorClass,', @Select2) begin set @ss = replace(@ss, ',colorClass,',',b.colorClass,') end
if 0<>charIndex(',dryness,', @Select2) begin set @ss = replace(@ss, ',dryness,',',b.dryness,') end
if 0<>charIndex(',wineType,', @Select2) begin set @ss = replace(@ss, ',wineType,',',b.wineType,') end
 
--if 0<>charIndex(',isTrustedTaster,', @Select2) select @ss = replace(@ss, ',isTrustedTaster,',',(case when n.tasterN is null then 0 else 1 end) isTrustedTaster,'), @tn = 1
--if 0<>charIndex(',isTrustedTaster,', @Select2) select @ss = replace(@ss, ',isTrustedTaster,',',(case when e.tasterN is null then 0 else 1 end) isTrustedTaster,'), @tn = 1
if 0<>charIndex(',isTrustedTaster,', @Select2) select @ss = replace(@ss, ',isTrustedTaster,',',(case when k.tasterN is null then 0 else 1 end) isTrustedTaster,'), @tk = 1
 
 
if 0<>charIndex(',parkerZralyLevel,', @Select2) begin set @ss = replace(@ss, ',parkerZralyLevel,',',e.parkerZralyLevel,') end
 
if @pubGN > 0
	if 0<>charIndex(',pubGN,', @Select2) begin set @ss = replace(@ss, ',pubGN,',','+convert(nvarchar, @pubGN)+' pubGN,') end 
  
-------------------------------------------------------------------------------------
-- Price
-------------------------------------------------------------------------------------
if @priceGN > 0 begin
	if @priceGN=@priceGNAllRetailers
		begin
			if 0<>charIndex(',forSaleIconN,', @Select2) begin set @ss = replace (@ss, ',forSaleIconN,',',case when a.mostRecentPriceLoStd > 0 then ' + @iconForSaleNow + ' else 0 end forSaleIconN,') end
			if 0<>charIndex(',priceLo,', @Select2) begin set @ss = replace(@ss, ',priceLo,',',isNull(a.mostRecentPriceLoStd, a.estimatedCostLo) priceLo,') end
			if 0<>charIndex(',priceHi,', @Select2) begin set @ss = replace(@ss, ',priceHi,',',isNull(a.mostRecentPriceHiStd, a.estimatedCostHi) priceHi,') end
			if 0<>charIndex(',priceCnt,', @Select2) begin set @ss = replace(@ss, ',priceCnt,',',isNull(a.priceCnt,0) priceCnt,') end
			if 0<>charIndex(',priceShow,', @Select2) begin set @ss = replace(@ss, ',priceShow,',',dbo.formatPrice(a.mostRecentPriceLoStd,a.estimatedCostLo, a.mostRecentPriceHiStd, a.estimatedCostHi) priceShow,') end
			if 0<>charIndex(',priceShowRelease,', @Select2) begin set @ss = replace(@ss, ',priceShowRelease,',',dbo.formatPriceRelease(a.mostRecentPriceLoStd, a.mostRecentPriceHiStd,a.estimatedCostLo) priceShowRelease,') end
		end
	else
		begin
			if 0<>charIndex(',forSaleIconN,', @Select2) begin set @ss = replace (@ss, ',forSaleIconN,',',case when d.mostRecentPriceLo > 0 then ' + @iconForSaleNow + ' else 0 end forSaleIconN,') end
			if 0<>charIndex(',priceLo,', @Select2) begin set @ss = replace(@ss, ',priceLo,',',isNull(d.mostRecentPriceLo, a.estimatedCostLo) priceLo,') end
			if 0<>charIndex(',priceHi,', @Select2) begin set @ss = replace(@ss, ',priceHi,',',isNull(d.mostRecentpriceHi, a.estimatedCostHi) priceHi,') end
			if 0<>charIndex(',priceCnt,', @Select2) begin set @ss = replace(@ss, ',priceCnt,',',isNull(d.priceCnt,0) priceCnt,') end
			if 0<>charIndex(',priceShow,', @Select2) begin set @ss = replace(@ss, ',priceShow,',',dbo.formatPrice(d.mostRecentPriceLo,a.estimatedCostLo, d.mostRecentPriceHi, a.estimatedCostHi) priceShow,') end
			if 0<>charIndex(',priceShowRelease,', @Select2) begin set @ss = replace(@ss, ',priceShowRelease,',',dbo.formatPriceRelease(d.mostRecentPriceLo, d.mostRecentPriceHi,a.estimatedCostLo) priceShowRelease,') end
		end
 
 
		if 0<>charIndex(',forSaleIconN,', @Select2) begin set @ss = replace (@ss, ',forSaleIconN,',',case when d.mostRecentPriceLo > 0 then ' + @iconForSaleNow + ' else 0 end forSaleIconN,') end
		if 0<>charIndex(',priceLo,', @Select2) begin set @ss = replace(@ss, ',priceLo,',',isNull(d.mostRecentPriceLo, a.estimatedCostLo) priceLo,') end
		if 0<>charIndex(',priceHi,', @Select2) begin set @ss = replace(@ss, ',priceHi,',',isNull(d.mostRecentpriceHi, a.estimatedCostHi) priceHi,') end
		if 0<>charIndex(',priceCnt,', @Select2) begin set @ss = replace(@ss, ',priceCnt,',',isNull(d.priceCnt,0) priceCnt,') end
		if 0<>charIndex(',priceShow,', @Select2) begin set @ss = replace(@ss, ',priceShow,',',dbo.formatPrice(d.mostRecentPriceLo,a.estimatedCostLo, d.mostRecentPriceHi, a.estimatedCostHi) priceShow,') end
		if 0<>charIndex(',priceShowRelease,', @Select2) begin set @ss = replace(@ss, ',priceShowRelease,',',dbo.formatPriceRelease(d.mostRecentPriceLo, d.mostRecentPriceHi,a.estimatedCostLo) priceShowRelease,') end
 
end
else begin
	if 0<>charIndex(',forSaleIconN,', @Select2) begin set @ss = replace (@ss, ',forSaleIconN,',',0 forSaleIconN,') end
	if 0<>charIndex(',priceLo,', @Select2) begin set @ss = replace(@ss, ',priceLo,',',a.estimatedCostLo priceLo,') end
	if 0<>charIndex(',priceHi,', @Select2) begin set @ss = replace(@ss, ',priceHi,',',a.estimatedCostHi priceHi,') end
	if 0<>charIndex(',priceCnt,', @Select2) begin set @ss = replace(@ss, ',priceCnt,',',0 priceCnt,') end
	if 0<>charIndex(',priceShow,', @Select2) begin set @ss = replace(@ss, ',priceShow,',',dbo.formatPrice(null, a.estimatedCostLo, null, a.estimatedCostHi) priceShow,') end
	if 0<>charIndex(',priceShowRelease,', @Select2) begin set @ss = replace(@ss, ',priceShowRelease,',',dbo.formatPriceRelease(null,null,a.estimatedCostLo) priceShowRelease,') end
end
 
 
/*--1007Jul05--
-------------------------------------------------------------------------------------
-- Ensure Fields For Active Tasting
-------------------------------------------------------------------------------------
set @trace+='--glorp' 
 if @doGetAllTastings = 0 begin
	--wineN, hasRating desc, isErpTasting desc, tasteDate desc, tastingN
	set @trace+= '(select2:'+@select2+')'
	if 0=charIndex(',wineN,', @Select2) set @ss += 'a.wineN wineN,'
	if 0=charIndex(',hasRating,', @Select2) set @ss += 'e.hasRating,'
	--1006Jun30--if 0=charIndex(',isErpTasting,', @Select2) set @ss += 'e.isErpTasting,'
	--1006Jun30--if 0=charIndex(',isProTasting,', @Select2) set @ss += 'e.isProTasting,'
	if 0=charIndex(',parkerZralyLevel,', @Select2) set @ss += 'e.parkerZralyLevel,'
	if 0=charIndex(',tasteDate,', @Select2) set @ss += 'e.tasteDate,'
	if 0=charIndex(',tastingN,', @Select2) set @ss += 'e.tastingN,'
end
*/
 
------------------------------------------------------------------------------------------
-- Rating Range
------------------------------------------------------------------------------------------
if 0<>charIndex(',ratingRange,', @Select2) begin set @ss = replace(@ss, ',ratingRange,',',case
		when e.rating between 96 and 100
			then ''96-100''
		when e.rating between 90 and 95
			then ''90-95''
		when e.rating between 80 and 89
			then ''80-89''
		when e.rating between 70 and 79
			then ''70-79''
		when e.rating between 0 and 69
			then ''Below 70''
		else 
			''Not Rated''				 
	  end ratingRange,') end		
		
 
 
-------------------------------------------------------------------------------------
-- Group By
-------------------------------------------------------------------------------------
--if 0<>charIndex(',ratingRange,', @Select2) begin set @ss = replace(@ss, ',ratingRange,','ratingRange,') end
 
 
	if @doGetAllTastings = 1 begin
		if 0<>charIndex(',tastingN,', @Select2) begin set @ss = replace(@ss, ',tastingN,',',e.tastingN,'); set @te=1 end
 
		if 0<>charIndex(',rating,', @Select2) begin set @ss = replace(@ss, ',rating,',',e.rating,') end
		
		--if 0<>charIndex(',ratingShow,', @Select2) begin set @ss = replace(@ss, ',ratingShow,',',isNull(e.ratingShow,'''') ratingShow,') end
		--if 0<>charIndex(',ratingShow,', @Select2) begin set @ss = replace(@ss, ',ratingShow,',',isNull(e.ratingShow,convert(varchar, e.rating)+''*'') ratingShow,') end		
		--if 0<>charIndex(',ratingShow,', @Select2) begin set @ss = replace(@ss, ',ratingShow,',',isNull(e.ratingShow,'''') ratingShow,') end
		--if 0<>charIndex(',ratingMinor,', @Select2) begin set @ss = replace(@ss, ',ratingMinor,',',case when ratingShow is null then 1 else 0 end ratingMinor,') end				
		
		
		
		if 0<>charIndex(',ratingSort,', @Select2) begin set @ss = replace(@ss, ',ratingSort,',',isnull(e.ratingSort,0) ratingSort,') end
		if 0<>charIndex(',maturity,', @Select2) begin set @ss = replace(@ss, ',maturity,',',isNull(e.maturityN, 6) maturity,') end
		
		--PubIcon: 1. PubN.icon (Parker Publications/Wine Advocates)     2. ParkerZraly     3. Trusted Taster     4. PubN.icon (other)     6. Generic Note
		if 0<>charIndex(',pubIconN,', @Select2) 
			begin
				set @sx = '
		case when e.sourceIconN is not null then e.sourceIconN else '
 
			if @mustBeTrustedTaster <> 0 
				begin
					set @sx += @iconHasTrusted+' end pubIconN
		'  
					set @ss = replace(@ss, ',pubIconN,',','+@sx+','); select @te=1, @tf=1
				end 
			else 
				begin
					set @sx += ' 
			case when k.tasterN is not null then '+@iconHasTrusted+' else '+@iconHasTasting+' end
		end pubIconN
		'  
					set @ss = replace(@ss, ',pubIconN,',','+@sx+','); select @te=1, @tf=1, @tn=1 , @tk=1
				end
			end
	end
	else 
		begin
			if 0<>charIndex(',tastingN,', @Select2) begin set @ss = replace(@ss, ',tastingN,',',e.tastingN,'); set @te=1 end
			if 0<>charIndex(',rating,', @Select2) begin set @ss = replace(@ss, ',rating,',',e.rating,') end
			if 0<>charIndex(',ratingSort,', @Select2) begin set @ss = replace(@ss, ',ratingSort,',',isnull(e.ratingSort,0) ratingSort,') end
			if 0<>charIndex(',maturity,', @Select2) begin set @ss = replace(@ss, ',maturity,',',isNull(e.maturityN, 6) maturity,') end
			if 0<>charIndex(',pubIconN,', @Select2) 
				begin
					if @mustBeTrustedTaster <> 0 
						begin
							set @sx = '
		case when e.sourceIconN is not null then e.sourceIconN else '+@iconHasTrusted+' end pubIconN
		'  
						set @ss = replace(@ss, ',pubIconN,',','+@sx+','); select @te=1, @tf=1
					end
				else 
					begin
						set @sx = '
		case when e.sourceIconN is not null then e.sourceIconN else 
			case when k.tasterN is not null then '+@iconHasTrusted+' else '+@iconHasTasting+' end
		end pubIconN
		'  
/*
						set @sx = '
		case when e.sourceIconN is not null then e.sourceIconN else 
			case when k.wineN is not null then '+@iconHasTrusted+' else '+@iconHasTasting+' end
		end pubIconN
		'  
*/
						set @ss = replace(@ss, ',pubIconN,',','+@sx+','); select @te=1, @tf=1, @tk=1, @tm=1
					end
				end
		end
--1005May06     eend
 
if 0<>charIndex(',ratingHi,', @Select2) begin set @ss = replace(@ss, ',ratingHi,',',e.ratingHi,'); set @te=1 end
if 0<>charIndex(',drinkdate,', @Select2) begin set @ss = replace(@ss, ',drinkdate,',',e.drinkdate,'); set @te=1 end
if 0<>charIndex(',drinkdateHi,', @Select2) begin set @ss = replace(@ss, ',drinkdateHi,',',e.drinkdateHi,'); set @te=1 end
 
if 0<>charIndex(',articleURL,', @Select2) begin set @ss = replace(@ss, ',articleURL,',',e.articleURL,'); set @te=1 end
if 0<>charIndex(',publication,', @Select2) begin set @ss = replace(@ss, ',publication,',',isNull(f.displayName,'''') publication,'); select @te=1, @tf=1 end
if 0<>charIndex(',pubDate,', @Select2) begin set @ss = replace(@ss, ',pubDate,',',e.pubDate,'); set @te=1 end
if 0<>charIndex(',tasteDate,', @Select2) begin set @ss = replace(@ss, ',tasteDate,',',e.tasteDate,'); set @te=1 end
if 0<>charIndex(',issue,', @Select2) begin set @ss = replace(@ss, ',issue,',',e.issue,'); set @te=1 end
if 0<>charIndex(',pages,', @Select2) begin set @ss = replace(@ss, ',pages,',',isNull(e.pages,'''') pages,'); set @te=1 end
if 0<>charIndex(',notes,', @Select2) begin set @ss = replace(@ss, ',notes,',',isNull(e.notes,'''') notes,'); set @te=1 end
if 0<>charIndex(',clumpName,', @Select2) begin set @ss = replace(@ss, ',clumpName,',',e.clumpName,'); set @te=1 end
if 0<>charIndex(',articleId,', @Select2) begin set @ss = replace(@ss, ',articleId,',',e.articleId,'); set @te=1 end
if 0<>charIndex(',articleIdNKey,', @Select2) begin set @ss = replace(@ss, ',articleIdNKey,',',e.articleIdNKey,'); set @te=1 end
if 0<>charIndex(',articleOrder,', @Select2) begin set @ss = replace(@ss, ',articleOrder,',',e.articleOrder,'); set @te=1 end
if 0<>charIndex(',tasterN,', @Select2) begin set @ss = replace(@ss, ',tasterN,',',e.tasterN,'); set @te=1 end
--if 0<>charIndex(',taster,', @Select2) begin set @ss = replace(@ss, ',taster,',',g.displayName2 taster,'); select @te=1, @tg=1 end
if 0<>charIndex(',taster,', @Select2) begin set @ss = replace(@ss, ',taster,',',@taster@ taster,'); select @te=1, @tg=1 end
 
if 0<>charIndex(',shortTitle,', @Select2) begin set @ss = replace(@ss, ',shortTitle,',',isNull(i.title,'''') shortTitle,'); select @te=1, @ti=1 end
 
if 0<>charIndex(',ratingShow,', @Select2) begin set @ss = replace(@ss, ',ratingShow,',',e.ratingShow,'); set @te=1 end
if 0<>charIndex(',ratingMinor,', @Select2) begin set @ss = replace(@ss, ',ratingMinor,',',case when isErpTasting = 1 then 0 else 1 end ratingMinor,') end				
 
 
 
-------------------------------------------------------------------------------------
-- MyWines
-------------------------------------------------------------------------------------
if isNull(@whN,0) <> 0 begin
	if 0<>charIndex(',cellarInfo,', @Select2) begin
		set @sm = 'case when bottleLocations is null or bottleLocations not like ''%[^
 ]%'' then isNull(''['' + userComments + '']'', '''') when userComments is null or userComments not like ''%[^
 ]%''  then bottleLocations else bottleLocations +''
 
 ['' + userComments + '']'' end'
		
		set @sm = ',' + @sm  + ' cellarInfo,'
 
		set @ss = replace(@ss, ',cellarInfo,',@sm) set @th=1
	end
 
 
	if 0<>charIndex(',MyIconN,', @Select2) begin
		if @doFlagMyBottlesAndTastings = 1 begin
			--set @sm = 'case when isnull(h.bottleCount, 0) > 0 then case when isnull(h.tastingCount, 0) > 0 then '+@iconMyBT+' else '+@iconMyB+' end else case when isnull(h.tastingCount, 0) > 0 then '+@iconMyT+' else '+@iconMy+' end end '
			--set @sm = 'case when isnull(h.bottleCount, 0) <> 0 then case when isnull(h.tastingCount, 0) <> 0 then '+@iconMyBT+' else '+@iconMyB+' end else case when isnull(h.tastingCount, 0) <> 0 then '+@iconMyT+' else case when isnull(h.isOfInterestX, 0) <> 0 then '+@iconMy+' else 0 end end end '
			set @sm = 'case when isnull(hasBottlesShow, 0) <> 0 then case when isnull(h.tastingCount, 0) <> 0 then '+@iconMyBT+' else '+@iconMyB+' end else case when isnull(h.tastingCount, 0) <> 0 then '+@iconMyT+' else case when isnull(h.isOfInterestX, 0) <> 0 then '+@iconMy+' else 0 end end end '
			--KEEP AS BASE FOR ANY FUTURE REVISION
			--set @sm = 'case when isnull(h.bottleCount, 0) <> 0 then YHASBOTTLESY else ZHASTASTINGSZ end '
			--case when isnull(h.tastingCount, 0) <> 0 then '+@iconMyBT+' else '+@iconMyB+' end 
			--case when isnull(h.tastingCount, 0) <> 0 then '+@iconMyT+' else '+@iconMy+' end 
			--case when isnull(h.isOfInterestX, 0) <> 0 then '+@iconMy+' else 0 end 
			--KEEP AS BASE FOR ANY FUTURE REVISION
		       end
		else begin
			set @sm = @iconMy
		end
		set @sm = 'case when h.wineN is null then 0 else ' + @sm + ' end'
		set @sm = ',' + @sm  + ' myIconN,'
 
		set @ss = replace(@ss, ',MyIconN,',@sm) set @th=1
	end
 
	if 0<>charIndex(',myTastingCount,', @Select2) begin set @ss = replace(@ss, ',myTastingCount,',',isNull(h.tastingCount, 0) myTastingCount,') set @th=1 end 
	if 0<>charIndex(',myBottleCount,', @Select2) begin set @ss = replace(@ss, ',myBottleCount,',',isNull(h.BottleCount, 0) myBottleCount,') set @th=1 end         
	if 0<>charIndex(',myWantToSellCount,', @Select2) begin set @ss = replace(@ss, ',myWantToSellCount,',',isNull(h.wantToSellCount, 0) myWantToSellCount,') set @th=1 end       
	if 0<>charIndex(',myWantToBuyCount,', @Select2) begin set @ss = replace(@ss, ',myWantToBuyCount,',',isNull(h.wantToBuyCount, 0) myWantToBuyCount,') set @th=1 end      
	if 0<>charIndex(',myBuyerCount,', @Select2) begin set @ss = replace(@ss, ',myBuyerCount,',',isNull(h.buyerCount, 0) myBuyerCount,') set @th=1 end        
	if 0<>charIndex(',mySellerCount,', @Select2) begin set @ss = replace(@ss, ',mySellerCount,',',isNull(h.sellerCount, 0) mySellerCount,') set @th=1 end         
end
else begin
	if 0<>charIndex(',MyIconN,', @Select2) begin set @ss = replace(@ss, ',MyIconN,',',0 MyIconN,') end
	if 0<>charIndex(',myTastingCount,', @Select2) begin set @ss = replace(@ss, ',myTastingCount,',', 0 myTastingCount,') set @th=1 end           
	if 0<>charIndex(',myBottleCount,', @Select2) begin set @ss = replace(@ss, ',myBottleCount,',', 0 myBottleCount,') set @th=1 end     
 
	if 0<>charIndex(',myWantToSellCount,', @Select2) begin set @ss = replace(@ss, ',myTastingCount,',', 0 myTastingCount,') set @th=1 end           
	if 0<>charIndex(',myWantToBuyCount,', @Select2) begin set @ss = replace(@ss, ',myWantToBuyCount,',', 0 myWantToBuyCount,') set @th=1 end           
	if 0<>charIndex(',myBuyerCount,', @Select2) begin set @ss = replace(@ss, ',myBuyerCount,',', 0 myBuyerCount,') set @th=1 end    
	if 0<>charIndex(',mySellerCount,', @Select2) begin set @ss = replace(@ss, ',mySellerCount,',', 0 mySellerCount,') set @th=1 end     
end
 
set @ss = replace(@ss, ',', ', ')
set @ss = replace(@ss, '(', ' (')
set @ss = replace(@ss, ')', ') ')
set @ss = ltrim(rtrim(replace(@ss, '  ', ' ')))
set @ss = substring(@ss, 2, len(@ss) -2);
--set @ss = 'Select  top(' + convert(varchar, @maxRows + 1) + ') ' + @ss
set @ss = 'Select ' + @ss
 
-------------------------------------------------------------------------------------
-- Where
-------------------------------------------------------------------------------------
if @Where like '%[^ ]%' begin
	set @where = dbo.doubleUpQuotes(@where)
 
	set @where = replace(@where, ',', ' , ')
	set @where = replace(@where, '=', ' = ')
	set @where = replace(@where, '(', ' ( ')
	set @where = replace(@where, ')', ' ) ')
	set @where = replace(@where, '<>', '@<>@')
	set @where = replace(@where, '<', ' < ')
	set @where = replace(@where, '>', ' > ')
	set @where = replace(@where, '@<>@', ' <> ')
 
	set @Where = replace(@where, ' encodedKeywords ', ' a.encodedKeywords ') 
	set @Where = replace(@Where, ' FullWineName ', ' (b.producerShow+isnull(('' '' + b.labelName), '''')) ') 
	set @Where = replace(@where, ' wineN ', ' a.wineN ')
	set @Where = replace(@Where, ' producerShow ',' b.producerShow ')
	set @Where = replace(@Where, ' labelName ',' b.labelName ')
	--set  @where = replace(@where,' taster ',' g.displayName2 ')
	set  @where = replace(@where,' taster ',' @taster@ ')
 
	set  @where = replace(@where,' country ',' b.country ')
	set  @where = replace(@where,' publication ',' isNull (f.displayName, '''') ') 
        
       --if 0<>charIndex(',maturity,', @Select2) begin set @ss = replace(@ss, ',maturity,',',e.maturityN maturity,') end
	set @Where = replace(@Where, ' maturity ',' e.maturityN ')
	set @Where = replace(@Where, ' parkerZralyLevel ',' e.parkerZralyLevel ')
            
	if @priceGN > 0
		set @where = replace(@where, ' priceLo', ' isNull(d.mostRecentPriceLo, a.estimatedCostLo)')
	else
		set @where = replace(@where, ' priceLo', ' a.estimatedCostLo')
           
	if @where like '% issue %' begin 
		Set @Where = replace(@where, ' issue ', ' e.issue ')
		set @te = 1
	end
 
	if @where like '% tastingN %' begin 
		Set @Where = replace(@where, ' tastingN ', ' e.tastingN '); 
		set @te = 1 
	end
	
	set @where = ' ' + @where + ' '
end
 
-------------------------------------------------------------------------------------
-- Order By
-------------------------------------------------------------------------------------
/*--------------------------
if @OrderBy like '%[^ ]%' begin
	set @OrderBy = replace(@OrderBy, ',', ' , ')
 
	Set @OrderBy = replace(@OrderBy, ' Vintage', ' isNull(a.Vintage, '''')')
	--Set @OrderBy = replace(@OrderBy, '(Vintage', '(isNull(a.Vintage, '''')')
	Set @OrderBy = replace(@OrderBy, ' FullWineName', ' (b.producerShow+isnull(('' '' + b.labelName), ''''))')        
	--Set @OrderBy = replace(@OrderBy, '(FullWineName', '((b.producerShow+isnull(('' '' + b.labelName), ''''))')        
	Set @OrderBy = replace(@OrderBy, ' ColorClass', ' isNull(b.ColorClass, ''z'')')
	--Set @OrderBy = replace(@OrderBy, '(ColorClass', '(isNull(b.ColorClass, ''z'')')
	Set @OrderBy = replace(@OrderBy, ' issue', ' isNull(e.issue, 6)')
	--Set @OrderBy = replace(@OrderBy, '(issue', '(isNull(e.issue, 6)')
 
	if @te = 1 begin
		Set @OrderBy = replace(@OrderBy, ' Rating', ' isNull(e.Rating, 0)')
		--Set @OrderBy = replace(@OrderBy, '(Rating', '(isNull(e.Rating, 0)')
		Set @OrderBy = replace(@OrderBy, ' maturity', ' isNull(e.maturityN, 6)')
		--Set @OrderBy = replace(@OrderBy, '(maturity', '(isNull(e.maturityN, 6)')
	end
            else begin
		Set @OrderBy = replace(@OrderBy, ' Rating', ' isNull(e.Rating, 0)')
		--Set @OrderBy = replace(@OrderBy, '(Rating', '(isNull(e.Rating, 0)')
		Set @OrderBy = replace(@OrderBy, ' maturity', ' isNull(e.maturityN, 6)')
		--Set @OrderBy = replace(@OrderBy, '(maturity', '(isNull(e.maturityN, 6)')
	end
 
	if @priceGN > 0 begin
		Set @OrderBy = replace(@OrderBy, ' priceLo', ' isNull(d.mostRecentPriceLo, a.estimatedCostLo)')
		--Set @OrderBy = replace(@OrderBy, '(priceLo', '(isNull(d.mostRecentPriceLo, isnull(a.estimatedCostLo,  0))')
	end
	else begin
		Set @OrderBy = replace(@OrderBy, ' priceLo', ' a.estimatedCostLo')
		--Set @OrderBy = replace(@OrderBy, '(priceLo', '(isNull(a.estimatedCostLo, 0)')
	end
end
--------------------------*/ 
 
 
declare @includesNotForSaleNow bit
set @includesNotForSaleNow = case when @MustBeCurrentlyForSale = 1 then 0 else 1 end
set @sf = '
	from 
		wine a
		join wineName b
			on b.wineNameN = a.wineNameN'
 
/*--1006Jun19
set @sf +='
		'+case when @doGetAllTastings = 1 then '' else 'left ' end+'join @tasting@ e
			on e.wineN = a.wineN
				and (e.isPrivate <> 1  or e.tasterN = '+isNull(convert(nvarchar, @whN), '') +')'
*/
set @sf +='
		'+case when @mustHaveReviewInThisPubG=1 or @mustBeTrustedTaster=1 then '' else 'left ' end+'join @tasting@ e
			on e.wineN = a.wineN
				and (e.isPrivate <> 1  or e.tasterN = '+isNull(convert(nvarchar, @whN), '') +')'
				+ case when @mustHaveReviewInThisPubG=1 or @doGetAllTastings=1 then '' else '
				and e.isActive=1' end
 
                   
/*
if @MustHaveReviewInThisPubG = 0 and isNull(@mustBeTrustedTaster,0) = 0
	set @sf = replace(@sf, 'join', 'left join')
*/ 
 
if isnull(@priceGN,0) > 0 and @priceGN<>@priceGNAllRetailers begin
	set @sf += '
		'
/*--1006Jun22     SQL optimizer totally messes up the case without the "left" taking 10 minutes instead of seconds
            if 0=@MustBeCurrentlyForSale set @sf += 'left '
            set @sf = @sf + 'join price d
			on d.wineN = a.wineN
				and d.priceGN = ' + convert(varchar, @priceGN) + '
				and d.includesNotForSaleNow = ' + convert(varchar,@includesNotForSaleNow) + '
				and d.includesAuction = ' + convert(varchar, @IncludeAuctions)
*/
            set @sf = @sf + 'left join price d
			on d.wineN = a.wineN
				and d.priceGN = ' + convert(varchar, @priceGN) + '
				and d.includesNotForSaleNow = ' + convert(varchar,@includesNotForSaleNow) + '
				and d.includesAuction = ' + convert(varchar, @IncludeAuctions)
 
 
end
else if 1=@MustBeCurrentlyForSale set @sf = @sf + '--(No PriceGN specified)
                        '
 
--MY WINES 
if isnull(@whN,0) <> 0 and isnull(@doFlagMyBottlesAndTastings, 0) <> 0  begin
            set @sf += '
		left join whToWine h
			on h.wineN = a.wineN
				and h.whN = ' + convert(varchar, @whN)
end
 
if 1=@tf begin
            set @sf = @sf + '
		left join wh f
			on f.whN = e.pubN'
end
 
 
if 1=@tg begin
            set @sf = @sf + '
		left join wh g
			on g.whN = e.tasterN'
end
 
if 1=@ti begin
            set @sf = @sf + '
		left join articleTitle i
			on i.articleId = e.articleId'
end
 
if 1=@tj begin
            set @sf = @sf + '
		left join producerURL j
			on j.idN = b.producerUrlN'
end
 
/*     --1006Jun18
if 1 = @tk begin
          set @sf = @sf + '
		left join
			(select distinct(wineN)
				from 
					@tasting@ z
					join whToTrustedTaster y
						on z.tasterN = y.tasterN
				where y.whN = '+convert(nvarchar,@whN)+'
			) k
				on a.wineN = k.wineN'
end
*/
if 1=@tk begin
	set @sf += '
		left join whToTrustedTaster k
			on k.tasterN=e.tasterN
				and k.whN = '+convert(nvarchar,@whN)+'
'
end
 
 
 
/*--1006Jun30
if 1 = @tm begin
            set @sf = @sf + '
		left join 
			(select distinct wineN from @tasting@) m
				on a.wineN = m.wineN'
end
 
if 1 = @tn begin
          set @sf = @sf + '
		left join whToTrustedTaster n
			on e.tasterN = n.tasterN
				and n.whN = '+convert(nvarchar,@whN)
end
*/
 
-------------------------------------------------------------------------------------
-- Ensure Fields For Where, Order By, Group By
-------------------------------------------------------------------------------------
 
set @sx = ' ' + isNull(@OrderBy, '') + ' '
--if @sx like '%[(), ]encodedKeywords[(), ]%' set @ss += case when @te <> 0 then ',e.' else ',a.' end + 'encodedKeywords encodedKeywords'
if @sx like '%[(), ]encodedKeywords[(), ]%' set @ss += ',a.encodedKeywords encodedKeywords'
 
--1006Jun22
--if @MustBeCurrentlyForSale=1 set @ss+=',case when d.wineN is null then 0 else 1 end hasPrice'
--1007Jul03     isCurrentlyForSale
if @MustBeCurrentlyForSale=1 set @ss+=',isCurrentlyForSale' 
 
 
 
 
 
 
 
 
-------------------------------------------------------------------------------------
-- Trusted Tasters NEW
-------------------------------------------------------------------------------------
/*--1006Jun30--
if @whN is not null and (@mustBeTrustedTaster=0 or @doGetAllTastings=1)
	begin
		set @sf += '
				'+case when @mustBeTrustedTaster = -1 then 'left ' else '' end+'join 
					(select distinct(tasterN)
						from whToTrustedTaster where whN='+convert(nvarchar, @whN)+'
					) tt on tt.tasterN = e.tasterN'
	end
*/
-------------------------------------------------------------------------------------
-- Must Be In PubGN
-------------------------------------------------------------------------------------
if @pubGN is not null and @MustHaveReviewInThisPubG <> 0 
	begin
		set @trace +='--BORK '
		if @pubGN = @pubGNWineAdvocates
			begin
				if @doGetAllTastings=1 or @mustBeTrustedTaster=1
					set @whereX='isErpPro=1'
				else
					set @whereX='isErpProActive=1'
			end
		else
			begin
				if @doGetAllTastings=1 or @mustBeTrustedTaster=1
					set @whereX='isWA=1'
				else
					set @whereX='isWAActive=1'
			end
 
		set @where += case when @where like '%where%' then ' and ' else 'where ' end + @wherex
	end
 
 
 
 
if @where1 is not null begin
	if @where2 is not null 
	set @where += '
(
        '+@where1+'
	and
        '+@where2+'
)'
else
	set @where += @where1
end
else
	if @where2 is not null set @where += @where2
 
if @Errors is not null 
	begin
		set @R = @Errors
	end
else 
	begin
		set @R = @ss + @sf
		if @where like '%[^ ]%'              set @R += '
	' + @where
	end 
 
 
 
--set @R=replace(@R, '@taster@', 'g.displayName')
--set @R=replace(@R, '@taster@', 'case when isAnnonymous = 1 then ''Anonymous'' + case when e.tasterN = '+convert(varchar,@whN)+' then '' (me)'' else '''' end else g.displayName end')
set @R = replace(@R, '@taster@', '
		case when isAnnonymous = 1 then 
			case when e.tasterN = '+convert(varchar, @whN)+' then ''Anonymous ('' +g.displayName + '')'' else ''Anonymous'' end
		else g.displayName end')
 
 
if @maxRows like '%[0-9]%' begin
	set @Select = replace(' ' + @Select, 'Select ', ' Select Top '+ convert(nvarChar, @maxRows)+' ')
end
 
/* 1006Jun03
if @doGetAllTastings = 1 
	set @select = replace(@select, 'vActiveTasting', 'tasting') 
*/
 
if @mustBeTrustedTaster=1
	begin
	set @R = 'with' + dbo.tastingSQL(@whN, @pubGN, @doGetAllTastings, 0, @mustBeTrustedTaster) + '
, a as (
		'+replace(@R,'@tasting@', 'td')
	end
else
	begin
		set @R = 'with a as (
		'+replace(@R,'@tasting@', 'tasting')
	end
set @R+='
)
'+@Select+case when @GroupBy like '%[^ ]%' then ', count(*) cnt' else '' end + '
	from a'
 
if @MustBeCurrentlyForSale=1 set @R+='
	where isCurrentlyForSale=1'
/*-------------------- 
	if @where like '%[^ ]%'
		set @R += '
	' + @where
--------------------*/ 
 
 if @GroupBy like '%[^ ]%'
	set @R += '
	' + @GroupBy 
 
if @OrderBy like '%[^ ]%'
	set @R += '
	' + @OrderBy
 
/*1006Jun18
if @doGetAllTastings = 1 
	set @R = replace(@R, 'vActiveTasting', 'tasting') 
*/
 
return (@R+@trace)
 
 
/*
 
 
 
 
 
 
 
 
 
 
declare @s nvarchar(max) =  dbo.wineSQL_new(
	' Select tastingN, wineN, taster, pubIconN, parkerZralyLevel, vintage,producerShow, priceLo, publication, country, labelName, rating,notes'			--@Select2
	,100			--@maxRows,
	,'where contains(encodedKeywords, ''        "pavie*" and "2003*"       '')'				--@where	,''								--@GroupBy,
	,''
	,''--'order by priceLo desc'					--@OrderBy,
	,18223	--@PubGN,
	,0		--@MustHaveReviewInThisPubG,
	,null		--@PriceGN,
	,0		--@MustBeCurrentlyForSale,
	,1		--@IncludeAuctions,
	,20		--@whN,
	,1		 --@doFlagMyBottlesAndTastings,
	,1		--@doGetAllTastings
	,0		--@mustBeTrustedTaster
)
set @s +=' select * from sql'
print @s
exec (@s)
 
 
 
 
  
 
declare @s nvarchar(max) =  dbo.wineSQL (
     'Select TastingN,wineN, vintage, fullWineName, colorClass, publication, pubiconN,  forSaleIconN, priceLo, estimatedCostLo, priceShow, priceShowRelease, ratingShow, maturity,MyIconN,MyBottleCount,ProducerURL, Site , Locale,Location,Region ,Country, variety, dryness,  winetype,ProducerShow,rating,hasUserComplaint,ratingMinor,cellarInfo,valuation'
     ,1000          --@maxRows,
     --,'where contains ( encodedKeywords, ''  "pavie*" and "2003*"'')  '                 --@where
     ,'where contains ( encodedKeywords, ''"cabernet*"'')  and (hasUserComplaint=0 or (hasUserComplaint=1 and isApproved=1) or hasUserComplaint is null '                --@where
     ,''--'Group by country'       --@GroupBy
     ,'order by  fullWineNamePlus asc, Vintage desc'   --@OrderBy
     ,18240         --@PubGN
     ,0--1          --@MustHaveReviewInThisPubG,
     ,18220    --@PriceGN,
     ,0        --@MustBeCurrentlyForSale,
     ,0        --@IncludeAuctions,
     ,22       --@whN,
     ,1        --@doFlagMyBottlesAndTastings,
     ,0        --@doGetAllTastings
     ,0        --@mustBeTrustedTaster
)
print @s
exec (@s)
 
 
 
 
 
 
 
 
 
 
declare @s nvarchar(max) =  dbo.wineSQL_dev1005May06(
	--'Select taster, istrustedtaster, rating,ratingShow, ratingMinor, TastingN,wineN, vintage, fullWineName, colorClass, publication, pubiconN,  forSaleIconN, priceLo, estimatedCostLo, priceShow, priceShowRelease, maturity,MyIconN,MyBottleCount,ProducerURL, Site , Locale,Location,Region ,Country, variety, dryness,  winetype,ProducerShow,hasUserComplaint'			--@Select2
	--'Select wineN, vintage, cellarInfo, myIconN, fullWineNamePlus'     --@select
	'Select country'
	,100		--@maxRows,
	--,'where contains ( encodedKeywords, ''  "pavie*" and "2003*"'')  '				--@where
	,'where contains ( encodedKeywords, ''  "pav*" and "2003*"'')  '				--@where
	--,'where isOfInterestX = 1  '				--@where
	--,'where notYetCellaredX = 1  '				--@where
	--,'where toBeDeliveredX = 1  '				--@where
	--,'where isOfInterestX=1'     				--@where
	--,'where isOfInterestX=1 and fullWineName like ''%former%'''     				--@where	
	,''--'Group by country'		--@GroupBy
	,''--,'order by  fullWineNamePlus asc, Vintage desc'	--@OrderBy
	,9		--@PubGN
	,0--1		--@MustHaveReviewInThisPubG,
	,18220	--@PriceGN,
	,0		--@MustBeCurrentlyForSale,
	,0		--@IncludeAuctions,
	,20		--@whN,
	,1		 --@doFlagMyBottlesAndTastings,
	,0		--@doGetAllTastings
	,0		--@mustBeTrustedTaster
)
print @s
exec (@s)
 
 
 
 
 
 
 
 
declare @s nvarchar(max) =  dbo.wineSQL_dev1005May06(
	'Select maturity'
	,100		--@maxRows,
	,'where contains ( encodedKeywords, ''  "pa*" and "2003*"'')  '				--@where
	,'Group by maturity'		--@GroupBy
	,'Order by cnt desc'     --@OrderBy
	,9		--@PubGN
	,0--1		--@MustHaveReviewInThisPubG,
	,18220	--@PriceGN,
	,0		--@MustBeCurrentlyForSale,
	,0		--@IncludeAuctions,
	,20		--@whN,
	,1		 --@doFlagMyBottlesAndTastings,
	,0		--@doGetAllTastings
	,0		--@mustBeTrustedTaster
)
print @s 
exec (@s)
 
 
 
 
declare  @s varchar(max); 
set @s = dbo.wineSQL(
'Select country'--@Select,
,10--,@maxRows,
,'where contains ( encodedKeywords, ''  "cabernet*" '') and maturity =''1'' '--@Where,
,'Group by country'--@GroupBy,
,'Order by cnt desc'--@OrderBy,
,18223--@PubGN,
,0--@MustHaveReviewInThisPubG,
,18220--@PriceGN,
,0--@MustBeCurrentlyForSale,
,1--@IncludeAuctions,
,22--@whN,
,1--@doFlagMyBottlesAndTastings,
,0
,0
) 
print @s
exec (@s)
 
 
 
 
 
 
declare @s nvarchar(max) =  dbo.wineSQL(
	'Select taster, istrustedtaster, pubIconN, rating,ratingShow, ratingMinor, TastingN,wineN, vintage, fullWineName, colorClass, publication, forSaleIconN, priceLo, estimatedCostLo, priceShow, priceShowRelease, maturity,MyIconN,MyBottleCount,ProducerURL, Site , Locale,Location,Region ,Country, variety, dryness,  winetype,ProducerShow,hasUserComplaint'			--@Select2
	,100		--@maxRows,
	--,'where contains ( encodedKeywords, ''  "latour*"    and "1982"   '')  '				--@where
	,'where contains ( encodedKeywords, ''  "petrus*"    and "1943*"   '')  '				--@where
	,''		--'Group by ratingRange'		--@GroupBy
	,''		--'Order by cnt desc'				--@OrderBy
	,9		--@PubGN
	,0--1		--@MustHaveReviewInThisPubG,
	,18220	--@PriceGN,
	,0		--@MustBeCurrentlyForSale,
	,0		--@IncludeAuctions,
	,20		--@whN,
	,1		 --@doFlagMyBottlesAndTastings,
	,0		--@doGetAllTastings
	,0		--@mustBeTrustedTaster
)
print @s
exec (@s)
 
 
 
 
*/
 
end

