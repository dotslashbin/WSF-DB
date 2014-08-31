--dbo.dbo.tastingCountsInPieRangeSQL(22, -8456308, 18223, 1)(22, -8456308, 18223, 1)
CREATE function [dbo].[tastingCountsInPieRangeSQL](@whN int = null, @wineN int = null, @pubGN int,  @pieOption int = 1)
 
returns varchar(max)
begin
 
declare 
	 @s varChar(max)
	,@where2 varchar(max) = ' and (isnull(hasUserComplaint,0)=0 or (hasUserComplaint=1 and isApproved=1)) '
	,@MustHaveReviewInThisPubG int =0
	,@mustBeTrustedTaster int = 0
 
if @pieOption not in (1,2,3,4,5) set @pieOption = 1 
 
if @pieOption = 1
		select @MustHaveReviewInThisPubG = 0, @mustBeTrustedTaster = 0
 
if @pieOption = 2
		select @MustHaveReviewInThisPubG = 1, @mustBeTrustedTaster = 0
 
if @pieOption = 3 
		select @MustHaveReviewInThisPubG = 0, @mustBeTrustedTaster = 0, @where2 += ' and ParkerZralyLevel>0 '
 
if @pieOption = 4 
 		select @MustHaveReviewInThisPubG = 0, @mustBeTrustedTaster = 1
 
if @pieOption = 5 
		select @MustHaveReviewInThisPubG = -1, @mustBeTrustedTaster = -1, @where2 += ' and ParkerZralyLevel=0 '
 
set @s =  dbo.[wineSQL](
	'Select ratingRange'		--@Select
	,10000		--@maxRows,
	,'where wineN='+convert(varchar, @wineN) + @where2					--@where
	,'Group by ratingRange'		--@GroupBy,
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
--set @s = replace(@s, '@RC@', ' case when rating between 96 and 100 then 100     when rating between 90 and 95 then 95     when rating between 80 and 89 then 89          when rating between 70 and 79 then 79      else 69      end ')
--set @s = replace(@s, '@RR@', ' ratingRange ')
 
 
 
 
return @s
 
/*
 
 
 
use erp
go
declare @s varchar(max) = dbo.tastingCountsInPieRangeSQL(20, 84619, 18223, 1)
print @s
--exec (@s)
 
 
declare @s varchar(max) = dbo.tastingCountsInPieRangeSQL_New(22, -8456308, 18223, 1)
print @s
exec (@s)
 
declare @TT table(ratingrange int, cnt int)
insert into @TT(ratingrange, cnt) exec(@s)
select * from @TT
 
 
 
 
*/
 
end 
 
 
 
 
 
 
 
 
 
