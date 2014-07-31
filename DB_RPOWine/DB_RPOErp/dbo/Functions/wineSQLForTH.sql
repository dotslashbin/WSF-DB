CREATE function [dbo].[wineSQLForTH] ( 

                         @Select varChar(1000)

                        ,@maxRows int = 100

                        ,@Where varchar(max) = ''

                        ,@GroupBy varchar(max) = ''

                        ,@OrderBy varchar(max) = ''

                       -- ,@PubGN int = Null

                        ,@MustHaveReviewInThisPubG bit = 0

                        ,@PriceGN int = Null

                        ,@MustBeCurrentlyForSale bit = 0

                        ,@IncludeAuctions bit = 0

                        ,@MyWinesN int = Null

                        ,@doFlagMyBottlesAndTastings bit = 0

                        ,@doGetAllTastings bit = 0

        )

returns varchar(max)

 

 

as begin

 

-------------------------------------------------------------

-- Fixup arguments since initializing bits doesn't work

-------------------------------------------------------------

 

Select 

                         @MustHaveReviewInThisPubG = isnull(@MustHaveReviewInThisPubG,0)

                        ,@MustBeCurrentlyForSale = isnull(@MustBeCurrentlyForSale,0)

                        ,@IncludeAuctions = isnull(@IncludeAuctions,0)

                        ,@doFlagMyBottlesAndTastings = isnull(@doFlagMyBottlesAndTastings,0)

                        ,@doGetAllTastings = isnull(@doGetAllTastings, 0)

 

 

 

-------------------------------------------------------------

-- Fields needed

-------------------------------------------------------------

declare @ss varchar(5000), @sf varchar(5000), @sm varchar(5000), @R varchar(5000), @allTastings bit, @LF varchar(10), @Errors varchar(max)

select @ss = '', @sf = '', @sm = '', @allTastings = 0, @Errors = Null, @LF = '

            '

 

--Get Icon Constants

declare @iconWA varchar(10), @iconWJ varchar(10), @iconForSaleNow varchar(10), @iconMy varchar(10), @iconMyB varchar(10), @iconMyT varchar(10), @iconMyBT varchar(10)

select @iconWA = '1', @iconWJ = '2', @iconMy = '3', @iconMyT = '4', @iconMyB = '5', @iconMyBT = '6', @iconForSaleNow = '7'

 

--Error Detection

--if @pubGN is null  begin

          --  set @errors = '/*PubGN is NULL*/

--'

           -- end

 

 

--remove leading select 

set @Select = replace('|' + LTrim(@select), '|Select ', '')

set @Select = ',' + replace(@Select, ' ','') + ','

set @Select = replace(@Select, ',,', ',')

set @ss = @Select

 

declare @te bit, @tf bit, @tg bit, @th bit, @ti bit, @tj bit

select @te=0, @tf=0, @tg=0, @th=0, @ti=0, @tj = 0

 

if 0<>charIndex(',wineN,', @Select) begin set @ss = replace(@ss, ',wineN,',',a.wineN,') end

if 0<>charIndex(',vintage,', @Select) begin set @ss = replace(@ss, ',vintage,',',a.vintage,') end

if 0<>charIndex(',estimatedCostLo,', @Select) begin set @ss = replace(@ss, ',estimatedCostLo,',',a.estimatedCostLo,') end

if 0<>charIndex(',estimatedCostHi,', @Select) begin set @ss = replace(@ss, ',estimatedCostHi,',',a.estimatedCostHi,') end

 

if 0<>charIndex(',vintageSort,', @Select) begin set @ss = replace(@ss, ',vintageSort,',',isnull(a.vintage, '''') vintageSort,') end

if 0<>charIndex(',producer,', @Select) begin set @ss = replace(@ss, ',producer,',',b.producer,') end

if 0<>charIndex(',producerShow,', @Select) begin set @ss = replace(@ss, ',producerShow,',',b.producerShow,') end

if 0<>charIndex(',producerURL,', @Select) begin set @ss = replace(@ss, ',producerURL,',',j.currentURL producerURL,'); set @tj = 1 end

if 0<>charIndex(',producerProfileFile,', @Select) begin set @ss = replace(@ss, ',producerProfileFile,',',b.producerProfileFile,'); set @tj = 1 end

if 0<>charIndex(',labelName,', @Select) begin set @ss = replace(@ss, ',labelName,',',b.labelName,') end

if 0<>charIndex(',country,', @Select) begin set @ss = replace(@ss, ',country,',',b.country,') end

if 0<>charIndex(',region,', @Select) begin set @ss = replace(@ss, ',region,',',b.region,') end

if 0<>charIndex(',location,', @Select) begin set @ss = replace(@ss, ',location,',',b.location,') end

if 0<>charIndex(',fullWineName,', @Select) begin set @ss = replace(@ss, ',fullWineName,',',(b.producerShow+isnull(('' '' + b.labelName), '''')) fullWineName,') end

 

if 0<>charIndex(',locale,', @Select) begin set @ss = replace(@ss, ',locale,',',b.locale,') end

if 0<>charIndex(',site,', @Select) begin set @ss = replace(@ss, ',site,',',b.site,') end

if 0<>charIndex(',variety,', @Select) begin set @ss = replace(@ss, ',variety,',',b.variety,') end

if 0<>charIndex(',colorClass,', @Select) begin set @ss = replace(@ss, ',colorClass,',',b.colorClass,') end

if 0<>charIndex(',dryness,', @Select) begin set @ss = replace(@ss, ',dryness,',',b.dryness,') end

if 0<>charIndex(',wineType,', @Select) begin set @ss = replace(@ss, ',wineType,',',b.wineType,') end

 

if @priceGN > 0 begin

            if @GroupBy like '%[^ ]%' begin

                        if 0<>charIndex(',forSaleIconN,', @Select) begin set @ss = replace (@ss, ',forSaleIconN,',',case when max(mostRecentPriceLo) > 0 then ' + @iconForSaleNow + ' else 0 end forSaleIconN,') end

            end

            else begin

                        if 0<>charIndex(',forSaleIconN,', @Select) begin set @ss = replace (@ss, ',forSaleIconN,',',case when mostRecentPriceLo > 0 then ' + @iconForSaleNow + ' else 0 end forSaleIconN,') end

                        if 0<>charIndex(',priceLo,', @Select) begin set @ss = replace(@ss, ',priceLo,',',isNull(d.mostRecentPriceLo, a.estimatedCostLo) priceLo,') end

                        if 0<>charIndex(',priceHi,', @Select) begin set @ss = replace(@ss, ',priceHi,',',isNull(d.mostRecentpriceHi, a.estimatedCostHi) priceHi,') end

                        if 0<>charIndex(',priceCnt,', @Select) begin set @ss = replace(@ss, ',priceCnt,',',isNull(d.priceCnt,0) priceCnt,') end

                        if 0<>charIndex(',priceShow,', @Select) begin set @ss = replace(@ss, ',priceShow,',',dbo.formatPrice(d.mostRecentPriceLo,a.estimatedCostLo, d.mostRecentPriceHi, a.estimatedCostHi) priceShow,') end

                        if 0<>charIndex(',priceShowRelease,', @Select) begin set @ss = replace(@ss, ',priceShowRelease,',',dbo.formatPriceRelease(d.mostRecentPriceLo, d.mostRecentPriceHi,a.estimatedCostLo) priceShowRelease,') end

                        end

            end

else begin

            if 0<>charIndex(',forSaleIconN,', @Select) begin set @ss = replace (@ss, ',forSaleIconN,',',0 forSaleIconN,') end

            if 0<>charIndex(',priceLo,', @Select) begin set @ss = replace(@ss, ',priceLo,',',a.estimatedCostLo priceLo,') end

            if 0<>charIndex(',priceHi,', @Select) begin set @ss = replace(@ss, ',priceHi,',',a.estimatedCostHi priceHi,') end

            if 0<>charIndex(',priceCnt,', @Select) begin set @ss = replace(@ss, ',priceCnt,',',0 priceCnt,') end

            if 0<>charIndex(',priceShow,', @Select) begin set @ss = replace(@ss, ',priceShow,',',dbo.formatPrice(null, a.estimatedCostLo, null, a.estimatedCostHi) priceShow,') end

            if 0<>charIndex(',priceShowRelease,', @Select) begin set @ss = replace(@ss, ',priceShowRelease,',',dbo.formatPriceRelease(null,null,a.estimatedCostLo) priceShowRelease,') end

            end

 

if @groupBy like '%[^ ]%' begin

                        if 0<>charIndex(',pubIconN,', @Select) begin set @ss = replace(@ss, ',pubIconN,',',max(isnull(f.iconN, -1)) pubIconN,'); select @te=1, @tf=1 end

            end

else begin

            if @doGetAllTastings = 1 begin

                        if 0<>charIndex(',tastingN,', @Select) begin set @ss = replace(@ss, ',tastingN,',',e.tastingN,'); set @te=1 end

                        if 0<>charIndex(',pubIconN,', @Select) begin set @ss = replace(@ss, ',pubIconN,',',isnull(f.iconN, -1) pubIconN,'); select @te=1, @tf=1 end

             

                        if 0<>charIndex(',rating,', @Select) begin set @ss = replace(@ss, ',rating,',',e.rating,') end

                        if 0<>charIndex(',ratingShow,', @Select) begin set @ss = replace(@ss, ',ratingShow,',',isNull(e.ratingShow,'''') ratingShow,') end

                        if 0<>charIndex(',ratingSort,', @Select) begin set @ss = replace(@ss, ',ratingSort,',',isnull(e.ratingSort,0) ratingSort,') end

                        if 0<>charIndex(',maturity,', @Select) begin set @ss = replace(@ss, ',maturity,',',isNull(e.maturity, 6) maturity,') end

                        end

            else begin

                        if 0<>charIndex(',tastingN,', @Select) begin set @ss = replace(@ss, ',tastingN,',',c.activeTastingN tastingN,'); set @te=1 end

                        if 0<>charIndex(',pubIconN,', @Select) begin set @ss = replace(@ss, ',pubIconN,',',isNull(c.pubIconN, isnull(f.iconN, -1)) pubIconN,'); select @te=1, @tf=1 end

             

                        if 0<>charIndex(',rating,', @Select) begin set @ss = replace(@ss, ',rating,',',c.rating,') end

                        if 0<>charIndex(',ratingShow,', @Select) begin set @ss = replace(@ss, ',ratingShow,',',isNull(c.ratingShow,'''') ratingShow,') end

                        if 0<>charIndex(',ratingSort,', @Select) begin set @ss = replace(@ss, ',ratingSort,',',isnull(c.ratingSort,0) ratingSort,') end

                        if 0<>charIndex(',maturity,', @Select) begin set @ss = replace(@ss, ',maturity,',',isNull(c.maturity, 6) maturity,') end

                        end

            end

 

if 0<>charIndex(',ratingHi,', @Select) begin set @ss = replace(@ss, ',ratingHi,',',e.ratingHi,'); set @te=1 end

if 0<>charIndex(',drinkdate,', @Select) begin set @ss = replace(@ss, ',drinkdate,',',e.drinkdate,'); set @te=1 end

if 0<>charIndex(',drinkdateHi,', @Select) begin set @ss = replace(@ss, ',drinkdateHi,',',e.drinkdateHi,'); set @te=1 end

 

if 0<>charIndex(',articleURL,', @Select) begin set @ss = replace(@ss, ',articleURL,',',e.articleURL,'); set @te=1 end

if 0<>charIndex(',publication,', @Select) begin set @ss = replace(@ss, ',publication,',',isNull(f.fullName,'''') publication,'); select @te=1, @tf=1 end

if 0<>charIndex(',pubDate,', @Select) begin set @ss = replace(@ss, ',pubDate,',',e.pubDate,'); set @te=1 end

if 0<>charIndex(',tasteDate,', @Select) begin set @ss = replace(@ss, ',tasteDate,',',e.tasteDate,'); set @te=1 end

if 0<>charIndex(',issue,', @Select) begin set @ss = replace(@ss, ',issue,',',e.issue,'); set @te=1 end

if 0<>charIndex(',pages,', @Select) begin set @ss = replace(@ss, ',pages,',',isNull(e.pages,'''') pages,'); set @te=1 end

if 0<>charIndex(',notes,', @Select) begin set @ss = replace(@ss, ',notes,',',isNull(e.notes,'''') notes,'); set @te=1 end

if 0<>charIndex(',clumpName,', @Select) begin set @ss = replace(@ss, ',clumpName,',',e.clumpName,'); set @te=1 end

if 0<>charIndex(',articleId,', @Select) begin set @ss = replace(@ss, ',articleId,',',e.articleId,'); set @te=1 end

if 0<>charIndex(',articleIdNKey,', @Select) begin set @ss = replace(@ss, ',articleIdNKey,',',e.articleIdNKey,'); set @te=1 end

if 0<>charIndex(',articleOrder,', @Select) begin set @ss = replace(@ss, ',articleOrder,',',e.articleOrder,'); set @te=1 end

if 0<>charIndex(',tasterN,', @Select) begin set @ss = replace(@ss, ',tasterN,',',e.tasterN,'); set @te=1 end

if 0<>charIndex(',taster,', @Select) begin set @ss = replace(@ss, ',taster,',',isNull(g.fullName,'''') taster,'); select @te=1, @tg=1 end

 

if 0<>charIndex(',shortTitle,', @Select) begin set @ss = replace(@ss, ',shortTitle,',',isNull(i.title,'''') shortTitle,'); select @te=1, @ti=1 end

 

--MyWines

if isNull(@MyWinesN,0) <> 0 begin

            if 0<>charIndex(',MyIconN,', @Select) begin

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

            if 0<>charIndex(',myTastingCount,', @Select) begin set @ss = replace(@ss, ',myTastingCount,',',isNull(h.tastingCount, 0) myTastingCount,') set @th=1 end 

            if 0<>charIndex(',myBottleCount,', @Select) begin set @ss = replace(@ss, ',myBottleCount,',',isNull(h.BottleCount, 0) myBottleCount,') set @th=1 end         

 

            if 0<>charIndex(',myWantToSellCount,', @Select) begin set @ss = replace(@ss, ',myWantToSellCount,',',isNull(h.wantToSellCount, 0) myWantToSellCount,') set @th=1 end       

            if 0<>charIndex(',myWantToBuyCount,', @Select) begin set @ss = replace(@ss, ',myWantToBuyCount,',',isNull(h.wantToBuyCount, 0) myWantToBuyCount,') set @th=1 end      

            if 0<>charIndex(',myBuyerCount,', @Select) begin set @ss = replace(@ss, ',myBuyerCount,',',isNull(h.buyerCount, 0) myBuyerCount,') set @th=1 end        

            if 0<>charIndex(',mySellerCount,', @Select) begin set @ss = replace(@ss, ',mySellerCount,',',isNull(h.sellerCount, 0) mySellerCount,') set @th=1 end         

 

 

 

            end

else begin

            if 0<>charIndex(',MyIconN,', @Select) begin set @ss = replace(@ss, ',MyIconN,',',0 MyIconN,') end

            if 0<>charIndex(',myTastingCount,', @Select) begin set @ss = replace(@ss, ',myTastingCount,',', 0 myTastingCount,') set @th=1 end           

            if 0<>charIndex(',myBottleCount,', @Select) begin set @ss = replace(@ss, ',myBottleCount,',', 0 myBottleCount,') set @th=1 end     

 

            if 0<>charIndex(',myWantToSellCount,', @Select) begin set @ss = replace(@ss, ',myTastingCount,',', 0 myTastingCount,') set @th=1 end           

            if 0<>charIndex(',myWantToBuyCount,', @Select) begin set @ss = replace(@ss, ',myWantToBuyCount,',', 0 myWantToBuyCount,') set @th=1 end           

            if 0<>charIndex(',myBuyerCount,', @Select) begin set @ss = replace(@ss, ',myBuyerCount,',', 0 myBuyerCount,') set @th=1 end    

            if 0<>charIndex(',mySellerCount,', @Select) begin set @ss = replace(@ss, ',mySellerCount,',', 0 mySellerCount,') set @th=1 end     

            end

 

set @ss = replace(@ss, ',', ', ')

set @ss = replace(@ss, '(', ' (')

set @ss = replace(@ss, ')', ') ')

set @ss = ltrim(rtrim(replace(@ss, '  ', ' ')))

set @ss = substring(@ss, 2, len(@ss) -2);

set @ss = 'Select  top(' + convert(varchar, @maxRows + 1) + ') ' + @ss

 

 

--Set @Where = replace(@Where, 'FullWineName', '(b.producerShow+isnull(('' '' + b.labelName), ''''))')

if @Where like '%[^ ]%' begin

            Set @Where = replace(@where, ' encodedKeywords', ' a.encodedKeywords')

            Set @Where = replace(@where, '(encodedKeywords', '(a.encodedKeywords')

 

            Set @Where = replace(@Where, ' FullWineName', ' (b.producerShow+isnull(('' '' + b.labelName), ''''))')

            Set @Where = replace(@Where, '(FullWineName', '((b.producerShow+isnull(('' '' + b.labelName), ''''))')

 

            Set @Where = replace(@where, ' wineN', ' a.wineN')

            Set @Where = replace(@where, '(wineN', '(a.wineN')

 

            set @Where = replace(@Where, ' producerShow',' b.producerShow')

            set @Where = replace(@Where, '(producerShow','(b.producerShow')

 

            set @Where = replace(@Where, ' labelName',' b.labelName')

            set @Where = replace(@Where, '(labelName','(b.labelName')

 

            if @where like '%issue%' begin 

                        Set @Where = replace(@where, ' issue', ' e.issue')

                        Set @Where = replace(@where, '(issue', '(e.issue')

                        set @te = 1

                        end

 

            if @where like '%tastingN%' begin 

                        Set @Where = replace(@where, ' tastingN', ' e.tastingN'); 

                        Set @Where = replace(@where, '(tastingN', '(e.tastingN'); 

                        set @te = 1 

                        end

            end

 

if @OrderBy like '%[^ ]%' begin

            Set @OrderBy = replace(@OrderBy, ' Vintage', ' isNull(a.Vintage, '''')')

            Set @OrderBy = replace(@OrderBy, '(Vintage', '(isNull(a.Vintage, '''')')

 

            Set @OrderBy = replace(@OrderBy, ' FullWineName', ' (b.producerShow+isnull(('' '' + b.labelName), ''''))')        

            Set @OrderBy = replace(@OrderBy, '(FullWineName', '((b.producerShow+isnull(('' '' + b.labelName), ''''))')        

 

            Set @OrderBy = replace(@OrderBy, ' ColorClass', ' isNull(b.ColorClass, ''z'')')

            Set @OrderBy = replace(@OrderBy, '(ColorClass', '(isNull(b.ColorClass, ''z'')')

 

            Set @OrderBy = replace(@OrderBy, ' issue', ' isNull(e.issue, 6)')

            Set @OrderBy = replace(@OrderBy, '(issue', '(isNull(e.issue, 6)')

 

            if @te = 1 begin

                        Set @OrderBy = replace(@OrderBy, ' Rating', ' isNull(e.Rating, 0)')

                        Set @OrderBy = replace(@OrderBy, '(Rating', '(isNull(e.Rating, 0)')

                        Set @OrderBy = replace(@OrderBy, ' maturity', ' isNull(e.maturity, 6)')

                        Set @OrderBy = replace(@OrderBy, '(maturity', '(isNull(e.maturity, 6)')

                        end

            else begin

                        Set @OrderBy = replace(@OrderBy, ' Rating', ' isNull(c.Rating, 0)')

                        Set @OrderBy = replace(@OrderBy, '(Rating', '(isNull(c.Rating, 0)')

                        Set @OrderBy = replace(@OrderBy, ' maturity', ' isNull(c.maturity, 6)')

                        Set @OrderBy = replace(@OrderBy, '(maturity', '(isNull(c.maturity, 6)')

                        end

 

            if @priceGN > 0 begin

                        Set @OrderBy = replace(@OrderBy, ' priceLo', ' isNull(d.mostRecentPriceLo, isnull(a.estimatedCostLo,  0))')

                        Set @OrderBy = replace(@OrderBy, '(priceLo', '(isNull(d.mostRecentPriceLo, isnull(a.estimatedCostLo,  0))')

                        end

            else begin

                        Set @OrderBy = replace(@OrderBy, ' priceLo', ' isNull(a.estimatedCostLo, 0)')

                        Set @OrderBy = replace(@OrderBy, '(priceLo', '(isNull(a.estimatedCostLo, 0)')

                        end

            end

 

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

                                    on b.wineNameN = a.wineNameN

                        '

 

if @doGetAllTastings = 1 begin

            set @sf = @sf + ' join mapPubGToWineTasting c

                                                on c.wineN = a.wineN 

                                                           

                                    '

            end

else begin

            if 0=@mustHaveReviewInThisPubG set @sf = @sf + 'left '

            set @sf = @sf + ' join mapPubGToWine c

                                                on c.wineN = a.wineN 

                                                         

                                    '

            end

if isnull(@priceGN,0) > 0 begin

            if 0=@MustBeCurrentlyForSale set @sf = @sf + 'left '

            set @sf = @sf + 'join price d

                                    on d.wineN = a.wineN

                                                and d.priceGN = ' + convert(varchar, @priceGN) + '

                                                and d.includesNotForSaleNow = ' + convert(varchar,@includesNotForSaleNow) + '

                                                and d.includesAuction = ' + convert(varchar, @IncludeAuctions) + '

                        '

            end

else if 1=@MustBeCurrentlyForSale set @sf = @sf + '--(No PriceGN specified)

                        '

 

--MY WINES 

 

--if isnull(@MyWinesN,0) > 0 begin

if isnull(@MyWinesN,0) <> 0 begin

            --if 0=@MustBeInMyWines set @sf = @sf + 'left '

 

            --*****************************************

            --set @sf = @sf + 'join whToWine h

            set @sf = @sf + 'left join whToWine h

                                    on h.wineN = a.wineN

                                                and h.whN = ' + convert(varchar, @MyWinesN) + '

                        '

            end

 

if @doGetAllTastings = 1 begin

                        set @sf = @sf + ' join tasting e

                                                on e.tastingN = c.tastingN

                                    '

            end

else begin

            if 1=@te begin

                        if 0 = @MustHaveReviewInThisPubG set @sf = @sf + 'left '

                        set @sf = @sf + 'join tasting e

                                                on e.tastingN = c.activeTastingN

                                    '

                        end

            else begin

                        if 1=@MustHaveReviewInThisPubG set @where = case when len(@where) > 1 then @where + ' and ' end + '(c.activeTastingN is not null)'

                        end

            end

 

if 1=@tf begin

            set @sf = @sf + 'left join wh f

                                    on f.whN = e.pubN

            '

            end

 

if 1=@tg begin

            set @sf = @sf + 'left join wh g

                                    on g.whN = e.tasterN

            '

            end

 

if 1=@ti begin

            set @sf = @sf + 'left join articleTitle i

                                    on i.articleId = e.articleId

            '

            end

 

if 1=@tj begin

            set @sf = @sf + 'left join producerURL j

                                    on j.idN = b.producerUrlN

            '

            end

 

 --ooi article,''

 

 

/* 

set @R = 

            @ss 

            + isnull(@sf, '/* (NO FROM CLAUSE)  */

') 

            + isNull(@where, '/* (NO WHERE CLAUSE) */

            ') 

--          + isNull(@OrderBy, '/* (NO ORDER BY CLAUSE) */

            + isNull(@GroupBy+'

            ', '') 

            + isNull(@OrderBy + '

            ', '') 

*/

 

if @Errors is not null begin

            set @R = @Errors

            end

else begin

            set @R = @ss + @sf

            if @where like '%[^ ]%'              set @R = @R + @LF + @where

            if @GroupBy like '%[^ ]%' set @R = @R + @LF + @GroupBy

            if @OrderBy like '%[^ ]%' set @R = @R + @LF + @OrderBy

            end 

 

 

return (@R)

 

 

/*

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

declare 

                         @Select varChar(1000)

                        ,@maxRows int

                        ,@Where varchar(max)

                        ,@GroupBy varchar(max)

                        ,@OrderBy varchar(max)

                        ,@PubGN int

                        ,@MustHaveReviewInThisPubG bit

                        ,@PriceGN int

                        ,@MustBeCurrentlyForSale bit

                        ,@IncludeAuctions bit

                        ,@MyWinesN int

                        ,@MustBeInMyWines bit

                        ,@doFlagMyTastingsInMyWines bit

                        ,@doFlagMyBottlesInMyWines bit

                        ,@doGetAllTastings bit

                        ,@s varchar(max)

 

select 

            --@Select = 'Select wineN, tastingN, vintage, fullWineName, colorClass, publication, pubiconN, myBottleCount, myTastingCount, MyIconN, forSaleIconN, priceLo, estimatedCostLo, priceShow, priceShowRelease, ratingShow, maturity'

            --@Select = 'Select myiconN'

            --@Select = 'Select articleId, producerURL, shortTitle, Publication, Issue, wineN, vintage, producerShow, fullWineName, variety, dryness, colorclass, winetype, country, region, location, locale, site, PubDate, Taster, RatingShow, DrinkDate, DrinkDateHi, priceShowRelease, Notes'

            --@select = 'Select producerShow, myIconN, pubIconN, forSaleIconN, count(*) numberOfWines'

            --@select = 'Select fullWineName, colorClass, myIconN, pubIconN, forSaleIconN, count(*) numberOfVintages'

            --@select = 'Select fullWineName, vintage, forSaleIconN, priceLo, notes'

            --@select = 'Select fullWineName, colorClass, myIconN, pubIconN, forSaleIconN, count(*) numberOfVintages'

            --@select = 'Select producerShow, pubIconN, count(*) numberOfWines'

            --@select = 'Select myIconN, myTastingCount, myBottleCount, myWantToBuyCount, myWantToSellCount, mySellerCount,myBuyerCount, fullWineName, vintage, forSaleIconN, priceLo, notes'

 

            --@select = 'Select producerShow, vintage, pubIconN, count(*) numberOfWines'

            @select = 'Select producerShow, labelName, vintage, wineN, taster, publication, pubDate, issue, ratingShow, notes'

 

            --------------

            ,@maxRows = 300

            --------------

            --,@Where = 'where contains (encodedKeywords, ''  "chapoutier*"   '')'

            --,@Where = 'where contains (encodedKeywords, ''  "chapoutier*" and "m*"        '')'

            --,@Where = 'where contains (encodedKeywords, ''  "weinbach*"   '')'

            --,@Where = 'where contains (encodedKeywords, ''  "Sparr*"   '')'

            --,@Where = 'where contains (encodedKeywords, ''  "Reserve*"   '')'

            --,@Where = 'where contains (encodedKeywords, ''  "Wild*"  and "1990*"  '')'

            --,@Where = 'where contains (encodedKeywords, ''  "Port*"  and "1990*"  '')'

            --,@Where = 'where contains (encodedKeywords, ''  "Wildhurst*"   '')'                                                                 -- good test for mixture of myWines and not myWines when MyWinesN is 'MyIconTest'

            --,@where = 'where contains (encodedKeywords, ''  "Petrus*"  and "1982*"  '')'

            --,@where = 'where contains (encodedKeywords, ''  "Petrus*"  and "2005*"  '')'

            --,@where = 'where issue = ''175'''

            --,@where = 'where wineN in (4,14)'

            --,@where = 'where tastingN in(5142362,5142366)'

            --,@where = 'where wineN = 107220'

            --,@where = 'where wineN in (4,6,21963,41550,55620,62814,67692,82644,88695,92520,101394)'

            --,@where = 'where fullWineName = ''Graham Vintage Port'''

            --,@where = 'where producerShow = ''Robert Mondavi'''

            --,@Where = 'where contains (encodedKeywords, ''  "Reserve*"   '')'

            --,@Where = 'where contains (encodedKeywords, ''  "Haut*"  and "Brion*"and "1989*"  '')'

            ,@Where = 'where wineN = 26417'

 

            --------------

            --,@OrderBy = 'order by wineN, priceLo desc, maturity, vintage, colorClass desc, fullWineName'

            ,@OrderBy = 'Order by producerShow desc'

            --,@OrderBy = 'Order by count(*) desc'

            --,@OrderBy = 'Order by fullWineName'

 

            --------------

            --,@GroupBy = 'Group By FullWineName, ColorClass'

            --,@GroupBy = 'Group By ProducerShow'

            --------------

            --,@PubGN = dbo.getWhn('pubWa')

            --,@PubGN = 2282

            --,@PubGN = dbo.getWhn('pubAll')

            ,@PubGN = 18223

            --------------

            ,@MustHaveReviewInThisPubG = 1

            --------------

            ,@PriceGN = dbo.getWhn('erpRetailAll')

            --,@PriceGN = null 

            --------------

            ,@MustBeCurrentlyForSale = 0

            --------------

            ,@IncludeAuctions = 1

            --------------

            --,@MyWinesN = dbo.getWhn('Has100')

            --,@MyWinesN = dbo.getWhn('Has1000')

            --,@MyWinesN = dbo.getWhn('Has10000')

            --,@MyWinesN = dbo.getWhn('HasBT-1-3')

            --,@MyWinesN = dbo.getWhn('HasBT-24-3')

            --,@MyWinesN = dbo.getWhn('HasBT-75-5')

            --,@MyWinesN = 20

            --,@MyWinesN = dbo.getWhn('MyIconTest')

            ,@MyWinesN = 5163

            

            --------------

            --,@MustBeInMyWines = 1

            --------------

            ,@doFlagMyTastingsInMyWines = 1

            --------------

            ,@doFlagMyBottlesInMyWines = 1

            --------------

            ,@doGetAllTastings = 1

            --------------

            print '-------------------------------------------------------------'

            print 'declare @Select varChar(1000),@maxRows int,@Where varchar(max),@GroupBy varchar(max),@OrderBy varchar(max),@PubGN int,@MustHaveReviewInThisPubG bit,@PriceGN int,@MustBeCurrentlyForSale bit,@IncludeAuctions bit,@MyWinesN int,@MustBeInMyWines bit,@doFlagMyTastingsInMyWines bit,@doFlagMyBottlesInMyWines bit,@doGetAllTastings bit,@s varchar(max)'

            print 'Select '

            print '@Select  = ''' + convert(varchar(max), isNull(@Select,'')) + ''''

            print ',@maxRows  = ' + convert(varchar(max), isNull(@maxRows,''))

            --print ',@Where  = ''' + convert(varchar(max), isNull(@Where,'')) + ''''

            print ',@Where  = ''' + convert(varchar(max), isNull(replace(@Where,'''',''''''),'')) + ''''

            if @GroupBy like '%[^ ]%' print ',@GroupBy  = ' + convert(varchar(max), isNull(@GroupBy,''))

            if @GroupBy like '%[^ ]%' print ',@OrderBy  = ' + convert(varchar(max), isNull(@OrderBy,''))

            print ',@PubGN  = ' + convert(varchar(max), isNull(@PubGN,''))

            print ',@MustHaveReviewInThisPubG  = ' + convert(varchar(max), isNull(@MustHaveReviewInThisPubG,''))

            print ',@PriceGN  = ' + convert(varchar(max), isNull(@PriceGN,''))

            print ',@MustBeCurrentlyForSale  = ' + convert(varchar(max), isNull(@MustBeCurrentlyForSale,''))

            print ',@IncludeAuctions  = ' + convert(varchar(max), isNull(@IncludeAuctions,''))

            print ',@MyWinesN  = ' + convert(varchar(max), isNull(@MyWinesN,''))

            print ',@MustBeInMyWines  = ' + convert(varchar(max), isNull(@MustBeInMyWines,''))

            print ',@doFlagMyTastingsInMyWines  = ' + convert(varchar(max), isNull(@doFlagMyTastingsInMyWines,''))

            print ',@doFlagMyBottlesInMyWines  = ' + convert(varchar(max), isNull(@doFlagMyBottlesInMyWines,''))

            print ',@doGetAllTastings  = ' + convert(varchar(max), isNull(@doGetAllTastings,''))

            print 'set @s = dbo.wineSql( @Select,@maxRows,@Where,@GroupBy,@OrderBy,@PubGN,@MustHaveReviewInThisPubG,@PriceGN,@MustBeCurrentlyForSale,@IncludeAuctions,@MyWinesN,@MustBeInMyWines,@doFlagMyTastingsInMyWines,@doFlagMyBottlesInMyWines, @doGetAllTastings)'


            print 'exec (@s)'

            print '-------------------------------------------------------------'

 

set @s = dbo.wineSql( @Select,@maxRows,@Where,@GroupBy,@OrderBy,@PubGN,@MustHaveReviewInThisPubG,@PriceGN,@MustBeCurrentlyForSale,@IncludeAuctions,@MyWinesN,@MustBeInMyWines,@doFlagMyTastingsInMyWines,@doFlagMyBottlesInMyWines, @doGetAllTastings)

 

print @s

exec (@s)

-------------

 */

return ('done')

end

 

