-- timing test of wineSQL xx [=]
create proc xxTimeTestWineSQL as begin

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


-------------------------------------------------------------
select
@Select  = 'Select fullWineName, colorClass, myIconN, pubIconN, forSaleIconN, count(*) numberOfVintages'
,@maxRows  = 300
,@Where  = 'where contains (encodedKeywords, ''  "chapoutier*"   '')'
,@GroupBy  = 'Group By FullWineName, ColorClass'
,@OrderBy  = 'Order by count(*) desc'
,@PubGN  = 0
,@MustHaveReviewInThisPubG  = 0
,@PriceGN  = 18220
,@MustBeCurrentlyForSale  = 0
,@IncludeAuctions  = 1
,@MyWinesN  = 0
,@MustBeInMyWines  = 0
,@doFlagMyTastingsInMyWines  = 1
,@doFlagMyBottlesInMyWines  = 1 
,@doGetAllTastings  = 0
-------------------------------------------------------------
 
declare @i int, @m varchar(100);set @i = 10000

set @m = convert(varchar, @i) + ' loops of wineSql'

exec dbo.timer @m
while @i > 0 begin
	set @s = dbo.wineSql( @Select,@maxRows,@Where,@GroupBy,@OrderBy,@PubGN,@MustHaveReviewInThisPubG,@PriceGN,@MustBeCurrentlyForSale,@IncludeAuctions,@MyWinesN,@MustBeInMyWines,@doFlagMyTastingsInMyWines,@doFlagMyBottlesInMyWines, @doGetAllTastings)
	set @i = @i - 1
	end;
exec dbo.timer @m, 1;
select * from times order by starttime desc

--print @s
--exec (@s)
end