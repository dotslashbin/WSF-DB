 Create function [dbo].[tastingCountsInPieRange](@whN int = null, @wineN int = null, @pubGN int,  @pieOption int = 1)

returns varchar(max)
begin

/*
declare @wineN int = 84619, @whN int = 20 , @pubGN int = 18223, @pieOption int = 4
declare  @TT TABLE(wineN int, ratingRange int, cntTastingsInThisRange int)

drop function tastingCountsInPieRange
*/

declare 
	 @s varChar(max)
	,@where2 varchar(max) = ''
	,@MustHaveReviewInThisPubG int =0
	,@mustBeTrustedTaster int = 0

if @pieOption not in (1,2,3,4,5) set @pieOption = 1 

if @pieOption = 1
		select @MustHaveReviewInThisPubG = 0, @mustBeTrustedTaster = 0

if @pieOption = 2
		select @MustHaveReviewInThisPubG = 1, @mustBeTrustedTaster = 0

if @pieOption = 3 
		select @MustHaveReviewInThisPubG = 0, @mustBeTrustedTaster = 0, @where2 = 'and ParkerZralyLevel>0'

if @pieOption = 4 
 		select @MustHaveReviewInThisPubG = 0, @mustBeTrustedTaster = 1

if @pieOption = 5 
		select @MustHaveReviewInThisPubG = -1, @mustBeTrustedTaster = -1, @where2 = ' and ParkerZralyLevel=0'

set @s =  dbo.wineSQL3(
	--'Select rating'		--@Select
	'Select rating, tasterN'		--@Select
	,10000		--@maxRows,
	,'where wineN='+convert(varchar, @wineN) + @where2					--@where
	,''		--@GroupBy,
	,''		--@OrderBy,
	,@PubGN
	,@MustHaveReviewInThisPubG
	,null		--@PriceGN,
	,0		--@MustBeCurrentlyForSale,
	,1		--@IncludeAuctions,
	,@whN
	,0		 --@doFlagMyBottlesAndTastings,
	,1		--@doGetAllTastings
	,@mustBeTrustedTaster
)
/*
set @s +='select dbo.getName2(tasterN) from a'
print @s
exec (@s)
*/






set @s += ',b as (select case when rating between 96 and 100 then 100     when rating between 90 and 95 then 95     when rating between 80 and 89 then 89          when rating between 70 and 79 then 79      else 69      end     ratingRange from a)
,c as (select ratingRange, count(*) cnt from b group by ratingRange)
select '+convert(varchar,@wineN)+'wineN, ratingRange,cnt  from c'

return @s
end 

