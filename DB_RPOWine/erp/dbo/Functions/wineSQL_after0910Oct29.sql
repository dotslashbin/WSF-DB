CREATE  function [dbo].[wineSQL_after0910Oct29] ( 
	 @Select varChar(1000)
	,@maxRows int = 100
	,@Where varchar(max) = ''
	,@GroupBy varchar(max) = ''
	,@OrderBy varchar(max) = ''
	,@PubGN int = Null
	,@MustHaveReviewInThisPubG bit = 0
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
declare @s varchar(max) = dbo.wineSQL3
	(
	 @Select
	,@maxRows
	,@Where
	,@GroupBy
	,@OrderBy
	,@PubGN
	,@MustHaveReviewInThisPubG
	,@PriceGN
	,@MustBeCurrentlyForSale
	,@IncludeAuctions
	,@whN
	,@doFlagMyBottlesAndTastings
	,@doGetAllTastings
	,@mustBeTrustedTaster
	)
return (@s + 'select * from sql')
 

/*




declare @s nvarchar(max) =  dbo.[wineSQL_after0910Oct29](
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
	,0		--@doGetAllTastings
	,0		--@mustBeTrustedTaster
)
print @s
exec (@s)





*/ 
 
end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
