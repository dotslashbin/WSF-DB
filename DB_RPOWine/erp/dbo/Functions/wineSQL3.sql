CREATE  function [dbo].[wineSQL3] ( 
	 @Select varChar(1000)
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
-------------------------------------------------------------------------------------
-- Fixup arguments since initializing bits doesn't work
-------------------------------------------------------------------------------------
Select 
	 @MustHaveReviewInThisPubG = isnull(@MustHaveReviewInThisPubG,0)
	,@MustBeCurrentlyForSale = isnull(@MustBeCurrentlyForSale,0)
	,@IncludeAuctions = isnull(@IncludeAuctions,0)
	,@doFlagMyBottlesAndTastings = isnull(@doFlagMyBottlesAndTastings,0)
	,@doGetAllTastings = isnull(@doGetAllTastings, 0)
	,@mustBeTrustedTaster = isnull(@mustBeTrustedTaster,0)
 
-------------------------------------------------------------------------------------
-- Fields needed
-------------------------------------------------------------------------------------
declare @select2 varchar(max), @ss varchar(5000)='', @sf varchar(5000)='', @sm varchar(5000)='', @sx varchar(max), @R varchar(5000)='', @allTastings bit=0, @Errors varchar(max)=null
 
--Get Icon Constants     CHECK CODE BELOW FOR BAKED-IN USE OF THESE
declare @iconWA nvarchar = '1', @iconWJ nvarchar = '2', @iconMy nvarchar = '3', @iconMyT nvarchar = '4', @iconMyB nvarchar = '5', @iconMyBT nvarchar = '6', @iconForSaleNow nvarchar = '7', @iconHasTrusted nvarchar = '8', @iconHasTasting nvarchar = '9' --, @iconPZ1 nchar(2) = '10', @iconPZ2 nchar(2) = '11', @iconPZ3 nchar(2) = '12' 
declare @where1 nvarChar(max) = null, @where2 nvarChar(max) = null
 
--Error Detection
if @pubGN is null  begin
	set @errors = '
          /*PubGN is NULL*/'
     end
 
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
if 0<>charIndex(',locale,', @Select2) begin set @ss = replace(@ss, ',locale,',',b.locale,') end
if 0<>charIndex(',site,', @Select2) begin set @ss = replace(@ss, ',site,',',b.site,') end
if 0<>charIndex(',variety,', @Select2) begin set @ss = replace(@ss, ',variety,',',b.variety,') end
if 0<>charIndex(',colorClass,', @Select2) begin set @ss = replace(@ss, ',colorClass,',',b.colorClass,') end
if 0<>charIndex(',dryness,', @Select2) begin set @ss = replace(@ss, ',dryness,',',b.dryness,') end
if 0<>charIndex(',wineType,', @Select2) begin set @ss = replace(@ss, ',wineType,',',b.wineType,') end
 
if 0<>charIndex(',parkerZralyLevel,', @Select2) begin set @ss = replace(@ss, ',parkerZralyLevel,',',e.parkerZralyLevel,') end
 
if @pubGN > 0
	if 0<>charIndex(',pubGN,', @Select2) begin set @ss = replace(@ss, ',pubGN,',','+convert(nvarchar, @pubGN)+' pubGN,') end 
  
-------------------------------------------------------------------------------------
-- Price
-------------------------------------------------------------------------------------
if @priceGN > 0 begin
	if @GroupBy like '%[^ ]%' begin
		if 0<>charIndex(',forSaleIconN,', @Select2) begin set @ss = replace (@ss, ',forSaleIconN,',',case when max(mostRecentPriceLo) > 0 then ' + @iconForSaleNow + ' else 0 end forSaleIconN,') end
	end
	else begin
		if 0<>charIndex(',forSaleIconN,', @Select2) begin set @ss = replace (@ss, ',forSaleIconN,',',case when mostRecentPriceLo > 0 then ' + @iconForSaleNow + ' else 0 end forSaleIconN,') end
		if 0<>charIndex(',priceLo,', @Select2) begin set @ss = replace(@ss, ',priceLo,',',isNull(d.mostRecentPriceLo, a.estimatedCostLo) priceLo,') end
		if 0<>charIndex(',priceHi,', @Select2) begin set @ss = replace(@ss, ',priceHi,',',isNull(d.mostRecentpriceHi, a.estimatedCostHi) priceHi,') end
		if 0<>charIndex(',priceCnt,', @Select2) begin set @ss = replace(@ss, ',priceCnt,',',isNull(d.priceCnt,0) priceCnt,') end
		if 0<>charIndex(',priceShow,', @Select2) begin set @ss = replace(@ss, ',priceShow,',',dbo.formatPrice(d.mostRecentPriceLo,a.estimatedCostLo, d.mostRecentPriceHi, a.estimatedCostHi) priceShow,') end
		if 0<>charIndex(',priceShowRelease,', @Select2) begin set @ss = replace(@ss, ',priceShowRelease,',',dbo.formatPriceRelease(d.mostRecentPriceLo, d.mostRecentPriceHi,a.estimatedCostLo) priceShowRelease,') end
	end
end
else begin
	if 0<>charIndex(',forSaleIconN,', @Select2) begin set @ss = replace (@ss, ',forSaleIconN,',',0 forSaleIconN,') end
	if 0<>charIndex(',priceLo,', @Select2) begin set @ss = replace(@ss, ',priceLo,',',a.estimatedCostLo priceLo,') end
	if 0<>charIndex(',priceHi,', @Select2) begin set @ss = replace(@ss, ',priceHi,',',a.estimatedCostHi priceHi,') end
	if 0<>charIndex(',priceCnt,', @Select2) begin set @ss = replace(@ss, ',priceCnt,',',0 priceCnt,') end
	if 0<>charIndex(',priceShow,', @Select2) begin set @ss = replace(@ss, ',priceShow,',',dbo.formatPrice(null, a.estimatedCostLo, null, a.estimatedCostHi) priceShow,') end
	if 0<>charIndex(',priceShowRelease,', @Select2) begin set @ss = replace(@ss, ',priceShowRelease,',',dbo.formatPriceRelease(null,null,a.estimatedCostLo) priceShowRelease,') end
end
 
 
-------------------------------------------------------------------------------------
-- Ensure Fields For Active Tasting
-------------------------------------------------------------------------------------
 if @doGetAllTastings = 0 begin
	--wineN, hasRating desc, isErpTasting desc, tasteDate desc, tastingN
	if 0=charIndex(',wineN,', @Select2) set @ss += 'a.wineN wineN,'
	if 0=charIndex(',hasRating,', @Select2) set @ss += 'e.hasRating,'
	if 0=charIndex(',isErpTasting,', @Select2) set @ss += 'e.isErpTasting,'
	if 0=charIndex(',parkerZralyLevel,', @Select2) set @ss += 'e.parkerZralyLevel,'
	if 0=charIndex(',tasteDate,', @Select2) set @ss += 'e.tasteDate,'
	if 0=charIndex(',tastingN,', @Select2) set @ss += 'e.tastingN,'
end
 
 
-------------------------------------------------------------------------------------
-- Group By
-------------------------------------------------------------------------------------
if @groupBy like '%[^ ]%' begin
	if 0<>charIndex(',pubIconN,', @Select2) begin set @ss = replace(@ss, ',pubIconN,',',max(isnull(f.iconN, -1)) pubIconN,'); select @te=1, @tf=1 end
end
else begin			
	if @doGetAllTastings = 1 begin
		if 0<>charIndex(',tastingN,', @Select2) begin set @ss = replace(@ss, ',tastingN,',',e.tastingN,'); set @te=1 end
 
		if 0<>charIndex(',rating,', @Select2) begin set @ss = replace(@ss, ',rating,',',e.rating,') end
		--if 0<>charIndex(',ratingShow,', @Select2) begin set @ss = replace(@ss, ',ratingShow,',',isNull(e.ratingShow,'''') ratingShow,') end
		if 0<>charIndex(',ratingShow,', @Select2) begin set @ss = replace(@ss, ',ratingShow,',',isNull(e.ratingShow,convert(varchar, e.rating)+''*'') ratingShow,') end		
		if 0<>charIndex(',ratingSort,', @Select2) begin set @ss = replace(@ss, ',ratingSort,',',isnull(e.ratingSort,0) ratingSort,') end
		if 0<>charIndex(',maturity,', @Select2) begin set @ss = replace(@ss, ',maturity,',',isNull(e.maturityN, 6) maturity,') end
		
		--PubIcon: 1. PubN.icon (Parker Publications/Wine Advocates)     2. ParkerZraly     3. Trusted Taster     4. PubN.icon (other)     6. Generic Note
		if 0<>charIndex(',pubIconN,', @Select2) begin
							set @sx = '
		case when e.sourceIconN is not null then e.sourceIconN else '
 
	
			if @mustBeTrustedTaster <> 0 begin
				set @sx += @iconHasTrusted+' end pubIconN
		'  
				set @ss = replace(@ss, ',pubIconN,',','+@sx+','); select @te=1, @tf=1
			end 
			else begin
				set @sx += ' 
			case when n.tasterN is not null then '+@iconHasTrusted+' else '+@iconHasTasting+' end
		end pubIconN
		'  
				set @ss = replace(@ss, ',pubIconN,',','+@sx+','); select @te=1, @tf=1, @tn=1 
			end
		end
		/*
		if 0<>charIndex(',pubIconN,', @Select2) begin
			if @mustBeTrustedTaster <> 0 begin
				set @sx = '
		case when f.iconN is not null then f.iconN else '+@iconHasTrusted+' end pubIconN
		'  
				set @ss = replace(@ss, ',pubIconN,',','+@sx+','); select @te=1, @tf=1
			end 
			else begin
				set @sx = '
		case when f.iconN is not null then f.iconN else 
			case when n.tasterN is not null then '+@iconHasTrusted+' else '+@iconHasTasting+' end
		end pubIconN
		'  
				set @ss = replace(@ss, ',pubIconN,',','+@sx+','); select @te=1, @tf=1, @tn=1 
			end
		end
 
		*/
 
	end
	else begin
		if 0<>charIndex(',tastingN,', @Select2) begin set @ss = replace(@ss, ',tastingN,',',e.tastingN,'); set @te=1 end
		if 0<>charIndex(',rating,', @Select2) begin set @ss = replace(@ss, ',rating,',',e.rating,') end
		--if 0<>charIndex(',ratingShow,', @Select2) begin set @ss = replace(@ss, ',ratingShow,',',isNull(e.ratingShow,'''') ratingShow,') end
		if 0<>charIndex(',ratingShow,', @Select2) begin set @ss = replace(@ss, ',ratingShow,',',isNull(e.ratingShow,convert(varchar, e.rating)+''*'') ratingShow,') end		
		if 0<>charIndex(',ratingSort,', @Select2) begin set @ss = replace(@ss, ',ratingSort,',',isnull(e.ratingSort,0) ratingSort,') end
		if 0<>charIndex(',maturity,', @Select2) begin set @ss = replace(@ss, ',maturity,',',isNull(e.maturityN, 6) maturity,') end
		if 0<>charIndex(',pubIconN,', @Select2) begin
			if @mustBeTrustedTaster <> 0 begin
				set @sx = '
		case when e.sourceIconN is not null then e.sourceIconN else '+@iconHasTrusted+' end pubIconN
		'  
				set @ss = replace(@ss, ',pubIconN,',','+@sx+','); select @te=1, @tf=1
			end
			else begin
				set @sx = '
		case when e.sourceIconN is not null then e.sourceIconN else 
			case when k.wineN is not null then '+@iconHasTrusted+' else '+@iconHasTasting+' end
		end pubIconN
		'  
				set @ss = replace(@ss, ',pubIconN,',','+@sx+','); select @te=1, @tf=1, @tk=1, @tm=1
			end
		end
	end
end
 
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
 
 
-------------------------------------------------------------------------------------
-- MyWines
-------------------------------------------------------------------------------------
if isNull(@whN,0) <> 0 begin
	if 0<>charIndex(',MyIconN,', @Select2) begin
		if @doFlagMyBottlesAndTastings = 1 begin
			--set @sm = 'case when isnull(h.bottleCount, 0) > 0 then case when isnull(h.tastingCount, 0) > 0 then '+@iconMyBT+' else '+@iconMyB+' end else case when isnull(h.tastingCount, 0) > 0 then '+@iconMyT+' else '+@iconMy+' end end '
			set @sm = 'case when isnull(h.bottleCount, 0) <> 0 then case when isnull(h.tastingCount, 0) <> 0 then '+@iconMyBT+' else '+@iconMyB+' end else case when isnull(h.tastingCount, 0) <> 0 then '+@iconMyT+' else case when isnull(h.isOfInterestX, 0) <> 0 then '+@iconMy+' else 0 end end end '
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
		if @GroupBy like '%[^ ]%' set @sm = ' max(' + @sm + ')'
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
	
	/*0909Sep27
	if @where like '% taster %' begin 
		Set @Where = replace(@where, ' taster ', ' e.tastingN '); 
		set @te = 1 
	end
	*/
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
 
if @GroupBy like '%[^ ]%' begin
	Set @GroupBy = replace(@GroupBy, ' FullWineName', ' b.producerShow, b.labelName')
	Set @GroupBy = replace(@GroupBy, '(FullWineName', '(b.producerShow, b.labelName')
	Set @GroupBy = replace(@GroupBy, ' producerShow', ' producerShow')
	Set @GroupBy = replace(@GroupBy, '(producerShow', '(producerShow')
end
 
 
declare @includesNotForSaleNow bit
set @includesNotForSaleNow = case when @MustBeCurrentlyForSale = 1 then 0 else 1 end
set @sf = '
	from 
		wine a
		join wineName b
			on b.wineNameN = a.wineNameN'
 
set @sf +='
		join tasting e
			on e.wineN = a.wineN
				and (e.isPrivate <> 1  or e.tasterN = '+isNull(convert(nvarchar, @whN), '') +')'
                   
if @MustHaveReviewInThisPubG = 0 and isNull(@mustBeTrustedTaster,0) = 0
	set @sf = replace(@sf, 'join', 'left join')
 
if isnull(@priceGN,0) > 0 begin
	set @sf += '
		'
            if 0=@MustBeCurrentlyForSale set @sf += 'left '
            set @sf = @sf + 'join price d
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
 
if 1 = @tk begin
          set @sf = @sf + '
		left join
			(select distinct(wineN)
				from 
					tasting z
					join whToTrustedTaster y
						on z.tasterN = y.tasterN
				where y.whN = '+convert(nvarchar,@whN)+'
			) k
				on a.wineN = k.wineN'
end
 
if 1 = @tm begin
            set @sf = @sf + '
		left join 
			(select distinct wineN from tasting) m
				on a.wineN = m.wineN'
end
 
if 1 = @tn begin
          set @sf = @sf + '
		left join whToTrustedTaster n
			on e.tasterN = n.tasterN
				and n.whN = '+convert(nvarchar,@whN)
end
 
-------------------------------------------------------------------------------------
-- Ensure Fields For Where, Order By, Group By
-------------------------------------------------------------------------------------
 
set @sx = ' ' + isNull(@OrderBy, '') + ' '
--if @sx like '%[(), ]encodedKeywords[(), ]%' set @ss += case when @te <> 0 then ',e.' else ',a.' end + 'encodedKeywords encodedKeywords'
if @sx like '%[(), ]encodedKeywords[(), ]%' set @ss += ',a.encodedKeywords encodedKeywords'
 
 
 
 
 
 
 
 
-------------------------------------------------------------------------------------
-- Trusted Tasters NEW
-------------------------------------------------------------------------------------
if @whN is not null and @mustBeTrustedTaster <> 0 
	begin
		set @sf += '
		'+case when @mustBeTrustedTaster = -1 then 'left ' else '' end+'join 
			(select distinct(tasterN)
				from whToTrustedTaster where whN='+convert(nvarchar, @whN)+'
			) tt on tt.tasterN = e.tasterN'
 
/*
		if @doGetAllTastings = 1
			begin
				set @sf += '
		'+case when @mustBeTrustedTaster = -1 then 'left ' else '' end+'join 
			(select distinct(tasterN)
				from whToTrustedTaster where whN='+convert(nvarchar, @whN)+'
			) tt on tt.tasterN = e.tasterN'
 
			end
		else 
			begin
				set @sf += '
		join 
			(select distinct(wineN)
				from tasting z
					join whToTrustedTaster y
						on y.tasterN = z.tasterN
				where y.whN='+convert(nvarchar, @whN)+'
			) tw on tw.wineN = a.wineN'
			end
*/
	end
 
 
 
 
 
 
 
-------------------------------------------------------------------------------------
-- Must Be In PubGN
-------------------------------------------------------------------------------------
if @pubGN is not null and @MustHaveReviewInThisPubG <> 0 
	begin
		set @sf += '
		'+case when @MustHaveReviewInThisPubG = -1 then 'left ' else '' end +'join pubGToPub pp
			on pp.pubN = e.pubN 
				and pp.pubGN='+convert(varchar,@pubGN)+'
'
/*
		set @sf += '
		join 
			(select distinct(wineN)
				from tasting z
					join pubGToPub y
						on y.pubN = z.pubN
				where y.pubGN='+convert(nvarchar, @pubGN)+'
			) tp on tw.wineN = a.wineN'
*/
 
 
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
 
if @mustBeTrustedTaster = -1 or @MustHaveReviewInThisPubG = -1 begin
	if @where not like '%where%'  set @where = 'where '
	
	declare @where3 varchar(max) = ''
	if @mustBeTrustedTaster = -1 set @where3 = 'tt.tasterN is null'
	if @MustHaveReviewInThisPubG = -1 
		begin
			if len(@where3) > 0 set @where3 += ' and '
			set @where3 += ' pp.pubN is null'
		end
	
	set @where = replace(@where, 'where ', 'where (' + @where3 +') and (') + ')'
end
--end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
-------------------------------------------------------------------------------------
-- Trusted Tasters OLD
-------------------------------------------------------------------------------------
/*
if (@pubGN is not null and isNull(@MustHaveReviewInThisPubG,0) <> 0) or (@whN is not null and isNull(@mustBeTrustedTaster,0) <> 0) begin	
	declare @where1 nvarChar(max) = null, @where2 nvarChar(max) = null
	if @MustHaveReviewInThisPubG <> 0 begin
		if @where like '%where%' 
			set @where += '
		and '
		else
			set @where = '
		where '
		set @where1 = '(e.pubN='+convert(nvarchar,@pubGN)+' or exists(select * from whToTrustedPub v where v.whN = '+convert(nvarchar, @pubGN)+' and v.pubN = e.pubN))'
	end
	if @mustBeTrustedTaster <> 0
		--set @where2 = '(e.tasterN='+convert(nvarchar,@whN)+' or exists(select * from whToTrustedTaster v where v.whN = '+convert(nvarchar, @whN)+' and v.tasterN = e.tasterN))'
		if @doGetAllTastings = 1 begin
			set @sf += '
		'+case when @mustNotBeTrustedTaster = 1 then 'left ' else '' end+'join 
			(select distinct(tasterN)
				from whToTrustedTaster where whN='+convert(nvarchar, @whN)+'
			) tt on tt.tasterN = e.tasterN'
 
		end
		else begin
		set @sf += '
		join 
			(select distinct(wineN)
				from tasting z
					join whToTrustedTaster y
						on y.tasterN = z.tasterN
				where y.whN='+convert(nvarchar, @whN)+'
			) tw on tw.wineN = a.wineN'
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
 
	if @mustNotBeTrustedTaster = 1 begin
		if @where not like '%where%'  set @where = 'where '
		set @where = replace(@where, 'where ', 'where tt.tasterN is null and (') + ')'
	end
end
*/
 
if @Errors is not null begin
	set @R = @Errors
end
else begin
	set @R = @ss + @sf
	if @where like '%[^ ]%'              set @R += '
	' + @where
	if @GroupBy like '%[^ ]%' set @R += '
	' + @GroupBy
/*-----------------------------
	if @OrderBy like '%[^ ]%' set @R += '
	' + @OrderBy
-----------------------------*/
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
 
 
if @doGetAllTastings = 0 begin
	set @R = 'with a as (
'+@R+'
)
, b as (
select *, row_number() over (partition by wineN order by wineN, hasRating desc, isErpTasting desc, parkerZralyLevel desc, tasteDate desc, tastingN) ii
	from a
)
'+@Select+'
	from b
		where ii = 1
'
end
 
/*-------------------- 
	if @where like '%[^ ]%'
		set @R += '
	' + @where
--------------------*/ 

 
/*-------------------- 
if @GroupBy like '%[^ ]%'
	set @R += '
	' + @GroupBy
--------------------*/ 
 
if @OrderBy like '%[^ ]%'
	set @R += '
	' + @OrderBy
 
return (@R)
 
 
/*
 declare @s nvarchar(max) =  dbo.wineSQL3(
	'Select TastingN,wineN, vintage, fullWineName, colorClass, publication, pubiconN,  forSaleIconN, priceLo, estimatedCostLo, priceShow, priceShowRelease, ratingShow, maturity,MyIconN,MyBottleCount,ProducerURL, Site , Locale,Location,Region ,Country, variety, dryness,  winetype,ProducerShow,rating,hasUserComplaint'			--@Select2
	,100		--@maxRows,
	,'where contains ( encodedKeywords, ''  "pavie*" and "2003*"'')  and (hasUserComplaint=0 or (hasUserComplaint=1 and isApproved=1) or hasUserComplaint is null)'				--@where
	,''		--@GroupBy
	,'order by  fullWineName asc, Vintage desc'	--@OrderBy
	,9		--@PubGN
	,1		--@MustHaveReviewInThisPubG,
	,18220	--@PriceGN,
	,0		--@MustBeCurrentlyForSale,
	,1		--@IncludeAuctions,
	,20		--@whN,
	,1		 --@doFlagMyBottlesAndTastings,
	,0		--@doGetAllTastings
	,0		--@mustBeTrustedTaster
)
print @s
exec (@s)



 
declare @s nvarchar(max) =  dbo.wineSQL3(
	' Select tastingN, wineN, taster, pubIconN, parkerZralyLevel, vintage,producerShow, priceLo, publication, country, labelName, rating,notes'			--@Select2
	,100			--@maxRows,
	,'where contains(encodedKeywords, ''        "pavie*" and "2003*"       '')'				--@where	,''								--@GroupBy,
	,''
	,''--'order by priceLo desc'					--@OrderBy,
	,18223	--@PubGN,
	,-1		--@MustHaveReviewInThisPubG,
	,null		--@PriceGN,
	,0		--@MustBeCurrentlyForSale,
	,1		--@IncludeAuctions,
	,20		--@whN,
	,1		 --@doFlagMyBottlesAndTastings,
	,0		--@doGetAllTastings
	,0		--@mustBeTrustedTaster
)
set @s +=' select * from sql'
print @s
exec (@s)
 
 
 
 
 
 */
 end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
