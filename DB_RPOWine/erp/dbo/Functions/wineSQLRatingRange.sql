CREATE  function [dbo].wineSQLRatingRange ( 
	@byIndividualRating bit
	, @maxRows int = 100
	,@Where varchar(max) = ''
	,@PubGN int = Null
	,@MustHaveReviewInThisPubG int = 0
	,@PriceGN int = Null
	,@MustBeCurrentlyForSale bit = 0
	,@IncludeAuctions bit = 0
	,@whN int = Null
	,@doGetAllTastings bit = 0
	,@mustBeTrustedTaster int = 0	--set to -1 for special case of trying to get only tasting that don't have a trusted taster (The "Other Tasting" option on the Rating Tab)
)
returns @RR table (ratingRange varchar(50), cnt int, ratingMin int, ratingMax int)
as begin

declare 	@TT table (rating int, cnt int)
 declare @backSizeDivider int = 15 
 declare @s nvarchar(max) =  dbo.wineSQL(
	'Select rating'
	,100		--@maxRows,
	, @where
	,'Group by rating'		--@GroupBy
	,'Order by rating desc'     --@OrderBy
	, @PubGN
	, @MustHaveReviewInThisPubG
	, @PriceGN
	, @MustBeCurrentlyForSale
	, @IncludeAuctions
	, @whN
	, 1		 --@doFlagMyBottlesAndTastings,
	, @doGetAllTastings
	, @mustBeTrustedTaster
)

declare @c cursor, @ratingRange varchar(50), @cnt int
set @s = 'Set @c = cursor for ' + @s + '; open @c'

/*
exec sp_executeSQL @s, N'@c cursor output', @c = @c output
while 1=1
	begin
		fetch next from @c into @ratingRange, @cnt
		if @@fetch_status <> 0 break
		insert into @TT(rating, cnt) select @ratingRange, @cnt
	end
close @c ; deallocate @c 
 
if @byIndividualRating = 1
	begin
		insert into @RR(ratingRange, cnt, ratingMin, ratingMax)
			select top (@maxRows-1) convert(varchar, rating)
			, cnt
			, rating a
			, rating b from @tt  order by rating desc

		insert into @RR(ratingRange, cnt) select '(Back)', (select convert(int,1+(sum(cnt) / @backSizeDivider)) from @RR)
	end
else
	begin
		with
		a as (select
					  case
						when rating between 96 and 100
							then '96-100'
						when rating between 90 and 95
							then '90-95'
						when rating between 80 and 89
							then '80-89'
						when rating between 70 and 79
							then '96-100'
						when rating between 0 and 69
							then 'Below 70'
						else 
							'Not Rated'				 
					  end ratingRange
					, rating
					, cnt     
				from
					@TT		)
		insert into @RR(ratingRange, cnt, ratingMin, ratingMax)
			select top (@maxRows-1) 
					  ratingRange
					, sum(cnt) cnt
					, min(rating) ratingMin
					, max(rating) ratingMax
				from a  
				group by ratingRange
				order by ratingMin desc

	end

update @RR set ratingRange = 'Unspecified', ratingMin = null, ratingMax = null
	where ratingRange is null
*/
return 
 
/* 
select *from [dbo].wineSQLRatingRange ( 
	1		--@byIndividualRating bit
	,10
	,'where contains ( encodedKeywords, ''  "pa*" and "2003*"'')  '				--@where
	,9		--@PubGN
	,0		--@MustHaveReviewInThisPubG,
	,18220	--@PriceGN,
	,0		--@MustBeCurrentlyForSale,
	,0		--@IncludeAuctions,
	,20		--@whN,
	,0		--@doGetAllTastings
	,0		--@mustBeTrustedTaster
)

 */
 end
