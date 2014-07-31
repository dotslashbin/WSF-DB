 -- database doug interface userInterface xx [=]
CREATE proc [dbo].[SQ] ( 
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
		,@MyWinesN int = Null
		,@MustBeInMyWines bit = 0
		,@doFlagMyTastingsInMyWines bit = 0
		,@doFlagMyBottlesInMyWines bit = 0
		,@doGetAllTastings bit = 0
        )
 
 
as begin

-------------------------------------------------------------
-- DEBUG: Save this call in the log file
-------------------------------------------------------------

declare @c nVarChar(50) = char(13) + char(10) + '          '
insert into sqlCalls(dateCreated, args)
	select
		getDate()
		, 'wineSQL ('
			+ @c + +'  '''+ @select +	'''			--select'
			+ @c + ', '+  convert(varchar(max), isNull(@maxRows,'')) +	'			--maxRows'
			+ @c + +', '''+ convert(varchar(max), isNull(replace(@Where,'''',''''''),'')) +	'''			--where'
--			+ @c + +', '''+  +	'''			--xxxxxx'
--			+ @c + +', '''+ case when @xxxxx like '%[^ ]%' then @xxxxx else convert(varchar(max), isNull(@xxxxx,'')) end +	'''			--xxxxxx'			
			+ @c + +', '''+ case when @GroupBy like '%[^ ]%' then @GroupBy else convert(varchar(max), isNull(@GroupBy,'')) end +	'''			--GroupBy'						
			+ @c + +', '''+ case when @OrderBy like '%[^ ]%' then @OrderBy else convert(varchar(max), isNull(@OrderBy,'')) end +	'''			--OrderBy'						
			+ @c + ', '+  convert(varchar(max), isNull(@PubGN,'')) +	'			--PubGN'
			+ @c + ', '+  convert(varchar(max), isNull(@MustHaveReviewInThisPubG,'')) +	'			--MustHaveReviewInThisPubG'
			+ @c + ', '+  convert(varchar(max), isNull(@PriceGN,'')) +	'			--PriceGN'
			+ @c + ', '+  convert(varchar(max), isNull(@MustBeCurrentlyForSale,'')) +	'			--@MustBeCurrentlyForSale'
			+ @c + ', '+  convert(varchar(max), isNull(@IncludeAuctions,'')) +	'			--IncludeAuctions'
			+ @c + ', '+  convert(varchar(max), isNull(@MyWinesN,'')) +	'			--MyWinesN'
			+ @c + ', '+  convert(varchar(max), isNull(@MustBeInMyWines,'')) +	'			--MustBeInMyWines'
			+ @c + ', '+  convert(varchar(max), isNull(@doFlagMyTastingsInMyWines,'')) +	'			--doFlagMyTastingsInMyWines'
			+ @c + ', '+  convert(varchar(max), isNull(@doFlagMyTastingsInMyWines,'')) +	'			--doFlagMyTastingsInMyWines'
			+ @c + ', '+  convert(varchar(max), isNull(@doGetAllTastings,'')) +	'			--doGetAllTastings'

			+ @c + ')'

			
/*
	print ',@MustBeCurrentlyForSale  = ' + convert(varchar(max), isNull(@MustBeCurrentlyForSale,''))
	print ',@IncludeAuctions  = ' + convert(varchar(max), isNull(@IncludeAuctions,''))
	print ',@MyWinesN  = ' + convert(varchar(max), isNull(@MyWinesN,''))
	print ',@MustBeInMyWines  = ' + convert(varchar(max), isNull(@MustBeInMyWines,''))
	print ',@doFlagMyTastingsInMyWines  = ' + convert(varchar(max), isNull(@doFlagMyTastingsInMyWines,''))
	print ',@doFlagMyBottlesInMyWines  = ' + convert(varchar(max), isNull(@doFlagMyBottlesInMyWines,''))
	print ',@doGetAllTastings  = ' + convert(varchar(max), isNull(@doGetAllTastings,''))
	print 'set @s = dbo.wineSql( @Select,@maxRows,@Where,@GroupBy,@OrderBy,@PubGN,@MustHaveReviewInThisPubG,@PriceGN,@MustBeCurrentlyForSale,@IncludeAuctions,@MyWinesN,@MustBeInMyWines,@doFlagMyTastingsInMyWines,@doFlagMyBottlesInMyWines, @doGetAllTastings)'
*/

declare @s nvarchar(max)
set @s = dbo.wineSql( @Select,@maxRows,@Where,@GroupBy,@OrderBy,@PubGN,@MustHaveReviewInThisPubG,@PriceGN,@MustBeCurrentlyForSale,@IncludeAuctions,@MyWinesN,@MustBeInMyWines,@doFlagMyTastingsInMyWines,@doFlagMyBottlesInMyWines, @doGetAllTastings)
exec (@s)

end

/*

declare @s nvarchar(max)
select top 1 @s = args from sqlcalls order by idn desc
print @s



declare @s nvarchar(max)
select top 1 @s = 'dbo.' + args from sqlcalls order by idn desc

declare @u nvarchar(max) = 
'
declare @t nvarchar(max)
set @t = @s
exec (@t)
'
print @u

set @u = replace(@u, '@s', @s)
exec (@u)


-------------------------------------------------------------
declare @Select varChar(1000),@maxRows int,@Where varchar(max),@GroupBy varchar(max),@OrderBy varchar(max),@PubGN int,@MustHaveReviewInThisPubG bit,@PriceGN int,@MustBeCurrentlyForSale bit,@IncludeAuctions bit,@MyWinesN int,@MustBeInMyWines bit,@doFlagMyTastingsInMyWines bit,@doFlagMyBottlesInMyWines bit,@doGetAllTastings bit,@s varchar(max)
Select 
@Select  = 'Select producerShow, labelName, vintage, wineN, taster, publication, pubDate, issue, ratingShow, notes'
,@maxRows  = 300
,@Where  = 'where wineN = 26417'
,@PubGN  = 18223
,@MustHaveReviewInThisPubG  = 1
,@PriceGN  = 18220
,@MustBeCurrentlyForSale  = 0
,@IncludeAuctions  = 1
,@MyWinesN  = 5163
,@MustBeInMyWines  = 0
,@doFlagMyTastingsInMyWines  = 1
,@doFlagMyBottlesInMyWines  = 1
,@doGetAllTastings  = 1;
exec dbo.SQ @Select,@maxRows,@Where,@GroupBy,@OrderBy,@PubGN,@MustHaveReviewInThisPubG,@PriceGN,@MustBeCurrentlyForSale,@IncludeAuctions,@MyWinesN,@MustBeInMyWines,@doFlagMyTastingsInMyWines,@doFlagMyBottlesInMyWines, @doGetAllTastings




*/