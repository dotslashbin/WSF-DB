create proc xxArticle as begin

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
	@Select = 'Select articleId,shortTitle,producerProfileFile,ProducerURL, notes,TastingN,wineN, vintage, fullWineName, colorClass, publication, pubiconN,  forSaleIconN, priceLo, estimatedCostLo, priceShow, priceShowRelease, ratingShow, maturity,MyIconN'
    ,@maxRows = 300
    ,@where = 'where wineN = 106691'
    ,@OrderBy = 'order by  tastedate desc, PubDate desc'
    ,@PubGN = '18223'
    ,@MustHaveReviewInThisPubG = 1


set @s = dbo.wineSql( @Select,@maxRows,@Where,@GroupBy,@OrderBy,@PubGN,@MustHaveReviewInThisPubG,@PriceGN,@MustBeCurrentlyForSale,@IncludeAuctions,@MyWinesN,@MustBeInMyWines,@doFlagMyTastingsInMyWines,@doFlagMyBottlesInMyWines, @doGetAllTastings)
 
print @s
exec (@s)
end