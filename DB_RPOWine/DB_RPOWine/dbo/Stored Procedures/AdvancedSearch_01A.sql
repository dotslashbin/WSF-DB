-- =============================================
-- Author:		Alex B.
-- Create date: 6/14/14
-- Description:	Returns search results
--				1st stage of advanced search functionality
-- =============================================
CREATE PROCEDURE [dbo].[AdvancedSearch_01A]
	-- Wine attributes
	@WineProducer nvarchar(100) = '*',
	@WineVintage nvarchar(4) = NULL,
	@WineLabel nvarchar(120) = '*',
	@WineType nvarchar(50) = NULL,
	@WineColor nvarchar(30) = NULL,
	@WineVariety nvarchar(50) = NULL,
	@WineCountry nvarchar(25) = NULL,
	@WinePlaces nvarchar(50) = NULL,
	@WineMaturityID smallint = NULL,
	
	@TextSearch nvarchar(250) = '*',
	
	@WineCostLimit as money = NULL,
	@WineRatingLimit int = NULL,
	@IsWineOnAuction bit = NULL,
	@IsWineForSale bit = NULL,
	@IsTasteNoteExists bit = NULL,
	@showForERP bit = NULL,
	@showForWJ bit = NULL,
	
	-- Taste Notes attributes
	@Notes nvarchar(250) = '*',
	@Publication nvarchar(50) = NULL,
	@Issue nvarchar(255) = NULL,
	@ArticleID int = NULL,
	@Author nvarchar(50) = NULL,
	
	@IsActiveWineN smallint = 1,
	
	-- Sorting
	@StartRow int = NULL, @EndRow int = NULL,
	@SortBy varchar(20) = NULL, @SortOrder varchar(3) = NULL,
	
	@topNRows int = 500,
	@isDebug bit = 0

/*
exec AdvancedSearch_01A @SortBy = 'RecentPrice', @SortOrder = 'asc', @topNRows = 500, @isDebug = 1,
	@WineProducer = 'taylor', @WineLabel = 'port', @IsWineForSale = 1, @showForERP = 1,
	@StartRow = 7, @EndRow = 12
*/
	
AS
set nocount on;
SET ANSI_WARNINGS OFF;

declare @TotalRows int = 0

if @WineLabel is NOT NULL begin
	select @WineLabel = replace(replace(rtrim(ltrim(@WineLabel)), '%', '*'), '  ', ' ')
	-- applying macroses
	select @WineLabel = dbo.fn_GetAdjustedSearchString(@WineLabel)
	if @isDebug = 1
		print @WineLabel
end

-- Full text search parameters must not be null
select @WineProducer = isnull(nullif(@WineProducer, ''), '*'),
		@WineLabel = isnull(nullif(@WineLabel, ''), '*'),
		@TextSearch = isnull(nullif(@TextSearch, ''), '*'),
		@Notes = isnull(nullif(@Notes, ''), '*'),
		@WineVintage = case when @WineVintage is not null and len(@WineVintage) < 4 then @WineVintage + '%' else @WineVintage end
		
if isnull(@StartRow, 0) < 0 or isnull(@EndRow, 0) <= 0
	select @StartRow = NULL, @EndRow = NULL
--------- Results --------

if (@StartRow is NULL or @EndRow is NULL) begin
	-- no row_number!	
	select top (@topNRows)  
		[Vintage], 
		[Vintages] = isnull(Vintage, ''),	-- Case Vintage  WHEN '' THEN ''  ELSE Vintage  END,  
		[RatingString] = isnull(Rating,''),  
		[RatingShow] = isnull(RatingShow,''),  
		[Producer], 
		[ProducerShow], 
		[LabelName], 
		[MostRecentPriceString] =  case MostRecentPrice   
			when MostRecentPriceHi then (isnull(convert(varchar(10),convert(int,Round(MostRecentPrice,0))),''))  
			else (isnull(convert(varchar(10),convert(int,Round(MostRecentPrice,0))),''))+(isnull('-'+convert(varchar(10),convert(int,Round(MostRecentPriceHi,0))),'')) 
		end , 
		[WineN],  
		[ColorClass], 
		[ScreenWineName]= isnull(ProducerShow,'') + ' ' +  isnull(LabelName,''), 
		Publication = ISNULL(Publication,''),  
		IsERPTasting,  
		IsWJTasting,  
		[RecentPrice] = (isnull(convert(varchar(10),convert(int,Round(MostRecentPrice,0))),'')), 
		[MostRecentPriceHi] = (isnull(convert(varchar(10),convert(int,Round(MostRecentPriceHi,0))),'')), 
		[mostRecentAuctionPrice] = (isnull(convert(varchar(10),convert(int,Round(mostRecentAuctionPrice,0))),'')), 
		[IsCurrentlyForSale], 
		ReviewerIdN = ISNULL(ReviewerIdN,''), 
		[Maturity] = ISNULL(Maturity,'6'),  
		[VinN],
		TotalRows = 0
	from Wine (nolock)
	--where isActiveWineN = 1
	--	and contains((encodedKeyWords,labelname,producershow), @Keyword)
	--	and (showForERP=1) 
	where 
		    (@WineProducer = '*' or contains((Producer, ProducerShow), @WineProducer))
		and (@WineLabel = '*' or contains((encodedKeyWords,labelname,producershow), @WineLabel))	-- LabelName for proper search by macroses
		and (@TextSearch = '*' or contains((encodedKeyWords, ProducerShow, LabelName), @TextSearch))
		and (@Notes = '*' or contains(Notes, @Notes))
		
		and (@WineVintage is NULL or Vintage like @WineVintage)
		and (@WineType is NULL or WineType = @WineType)
		and (@WineColor is NULL or ColorClass = @WineColor)
		and (@WineVariety is NULL or Variety = @WineVariety)
		and (@WineCountry is NULL or Country = @WineCountry)
		and (@WinePlaces is NULL or Places = @WinePlaces)
		and (@WineMaturityID is NULL or Maturity = @WineMaturityID)
		
		and (@Publication is NULL or Publication = @Publication)
		and (@Issue is NULL or Issue = @Issue)
		and (@ArticleID is NULL or ArticleID = @ArticleID)
		and (@Author is NULL or source = @Author)
		
		and (@WineCostLimit is NULL or (MostRecentPrice is not null and MostRecentPrice <= @WineCostLimit))
		and (@WineRatingLimit is NULL or (Rating is not null and Rating >= @WineRatingLimit))

		and (@IsWineOnAuction is NULL or IsCurrentlyOnAuction = @IsWineOnAuction)
		and (@IsWineForSale is NULL or IsCurrentlyForSale = @IsWineForSale)
		and (@IsTasteNoteExists is NULL or (Notes is NOT NULL and Notes!= ''))
		and (@showForERP is NULL or showForERP = @showForERP)
		and (@showForWJ is NULL or showForWJ = @showForWJ)
		and (@IsActiveWineN is NULL or IsActiveWineN = @IsActiveWineN)
	order by 
		case when @SortBy = 'Vintage' and @SortOrder = 'asc' then Vintage else null end asc, 
		case when @SortBy = 'Vintage' and @SortOrder = 'des' then Vintage else null end desc,
		case when @SortBy = 'RatingString' and @SortOrder = 'asc' then Rating else null end asc, 
		case when @SortBy = 'RatingString' and @SortOrder = 'des' then Rating else null end desc,
		case when @SortBy = 'RatingShow' and @SortOrder = 'asc' then RatingShow else null end asc, 
		case when @SortBy = 'RatingShow' and @SortOrder = 'des' then RatingShow else null end desc,
		case when @SortBy = 'Producer' and @SortOrder = 'asc' then Producer else null end asc, 
		case when @SortBy = 'Producer' and @SortOrder = 'des' then Producer else null end desc,
		case when @SortBy = 'ProducerShow' and @SortOrder = 'asc' then ProducerShow else null end asc, 
		case when @SortBy = 'ProducerShow' and @SortOrder = 'des' then ProducerShow else null end desc,
		case when @SortBy = 'LabelName' and @SortOrder = 'asc' then LabelName else null end asc, 
		case when @SortBy = 'LabelName' and @SortOrder = 'des' then LabelName else null end desc,
		case when @SortBy = 'ColorClass' and @SortOrder = 'asc' then ColorClass else null end asc, 
		case when @SortBy = 'ColorClass' and @SortOrder = 'des' then ColorClass else null end desc,
		case when @SortBy = 'Publication' and @SortOrder = 'asc' then Publication else null end asc, 
		case when @SortBy = 'Publication' and @SortOrder = 'des' then Publication else null end desc,
		case when @SortBy = 'RecentPrice' and @SortOrder = 'asc' then MostRecentPrice else null end asc, 
		case when @SortBy = 'RecentPrice' and @SortOrder = 'des' then MostRecentPrice else null end desc,
		case when @SortBy = 'MostRecentPriceHi' and @SortOrder = 'asc' then MostRecentPriceHi else null end asc, 
		case when @SortBy = 'MostRecentPriceHi' and @SortOrder = 'des' then MostRecentPriceHi else null end desc,
		case when @SortBy = 'MostRecentAuctionPrice' and @SortOrder = 'asc' then MostRecentAuctionPrice else null end asc, 
		case when @SortBy = 'MostRecentAuctionPrice' and @SortOrder = 'des' then MostRecentAuctionPrice else null end desc,
		case when @SortBy = 'Maturity' and @SortOrder = 'asc' then Maturity else null end asc, 
		case when @SortBy = 'Maturity' and @SortOrder = 'des' then Maturity else null end desc,
		ProducerShow, LabelName, Vintage, WineN
end else begin
	select @TotalRows = count(*)
	from Wine (nolock)
	where
			(@WineProducer = '*' or contains((Producer, ProducerShow), @WineProducer))
		and (@WineLabel = '*' or contains((encodedKeyWords,labelname,producershow), @WineLabel))	-- LabelName for proper search by macroses
		and (@TextSearch = '*' or contains((encodedKeyWords, ProducerShow, LabelName), @TextSearch))
		and (@Notes = '*' or contains(Notes, @Notes))
		
		and (@WineVintage is NULL or Vintage like @WineVintage)
		and (@WineType is NULL or WineType = @WineType)
		and (@WineColor is NULL or ColorClass = @WineColor)
		and (@WineVariety is NULL or Variety = @WineVariety)
		and (@WineCountry is NULL or Country = @WineCountry)
		and (@WinePlaces is NULL or Places = @WinePlaces)
		and (@WineMaturityID is NULL or Maturity = @WineMaturityID)
		
		and (@Publication is NULL or Publication = @Publication)
		and (@Issue is NULL or Issue = @Issue)
		and (@ArticleID is NULL or ArticleID = @ArticleID)
		and (@Author is NULL or source = @Author)
		
		and (@WineCostLimit is NULL or (MostRecentPrice is not null and MostRecentPrice <= @WineCostLimit))
		and (@WineRatingLimit is NULL or (Rating is not null and Rating >= @WineRatingLimit))

		and (@IsWineOnAuction is NULL or IsCurrentlyOnAuction = @IsWineOnAuction)
		and (@IsWineForSale is NULL or IsCurrentlyForSale = @IsWineForSale)
		and (@IsTasteNoteExists is NULL or (Notes is NOT NULL and Notes!= ''))
		and (@showForERP is NULL or showForERP = @showForERP)
		and (@showForWJ is NULL or showForWJ = @showForWJ)
		and (@IsActiveWineN is NULL or IsActiveWineN = @IsActiveWineN)
		
	; with res as (
	select top (@topNRows)  
		[Vintage], 
		[Vintages] = isnull(Vintage, ''),	-- Case Vintage  WHEN '' THEN ''  ELSE Vintage  END,  
		[RatingString] = isnull(Rating,''),  
		[RatingShow] = isnull(RatingShow,''),  
		[Producer], 
		[ProducerShow], 
		[LabelName], 
		[MostRecentPriceString] =  case MostRecentPrice   
			when MostRecentPriceHi then (isnull(convert(varchar(10),convert(int,Round(MostRecentPrice,0))),''))  
			else (isnull(convert(varchar(10),convert(int,Round(MostRecentPrice,0))),''))+(isnull('-'+convert(varchar(10),convert(int,Round(MostRecentPriceHi,0))),'')) 
		end , 
		[WineN],  
		[ColorClass], 
		[ScreenWineName]= isnull(ProducerShow,'') + ' ' +  isnull(LabelName,''), 
		Publication = ISNULL(Publication,''),  
		IsERPTasting,  
		IsWJTasting,  
		[RecentPrice] = (isnull(convert(varchar(10),convert(int,Round(MostRecentPrice,0))),'')), 
		[MostRecentPriceHi] = (isnull(convert(varchar(10),convert(int,Round(MostRecentPriceHi,0))),'')), 
		[mostRecentAuctionPrice] = (isnull(convert(varchar(10),convert(int,Round(mostRecentAuctionPrice,0))),'')), 
		[IsCurrentlyForSale], 
		ReviewerIdN = ISNULL(ReviewerIdN,''), 
		[Maturity] = ISNULL(Maturity,'6'),  
		[VinN],
		
		TotalRows = isnull(@TotalRows, 0),
		RowNumber = row_number() over (order by 
			case when @SortBy = 'Vintage' and @SortOrder = 'asc' then Vintage else null end asc, 
			case when @SortBy = 'Vintage' and @SortOrder = 'des' then Vintage else null end desc,
			case when @SortBy = 'RatingString' and @SortOrder = 'asc' then Rating else null end asc, 
			case when @SortBy = 'RatingString' and @SortOrder = 'des' then Rating else null end desc,
			case when @SortBy = 'RatingShow' and @SortOrder = 'asc' then RatingShow else null end asc, 
			case when @SortBy = 'RatingShow' and @SortOrder = 'des' then RatingShow else null end desc,
			case when @SortBy = 'Producer' and @SortOrder = 'asc' then Producer else null end asc, 
			case when @SortBy = 'Producer' and @SortOrder = 'des' then Producer else null end desc,
			case when @SortBy = 'ProducerShow' and @SortOrder = 'asc' then ProducerShow else null end asc, 
			case when @SortBy = 'ProducerShow' and @SortOrder = 'des' then ProducerShow else null end desc,
			case when @SortBy = 'LabelName' and @SortOrder = 'asc' then LabelName else null end asc, 
			case when @SortBy = 'LabelName' and @SortOrder = 'des' then LabelName else null end desc,
			case when @SortBy = 'ColorClass' and @SortOrder = 'asc' then ColorClass else null end asc, 
			case when @SortBy = 'ColorClass' and @SortOrder = 'des' then ColorClass else null end desc,
			case when @SortBy = 'Publication' and @SortOrder = 'asc' then Publication else null end asc, 
			case when @SortBy = 'Publication' and @SortOrder = 'des' then Publication else null end desc,
			case when @SortBy = 'RecentPrice' and @SortOrder = 'asc' then MostRecentPrice else null end asc, 
			case when @SortBy = 'RecentPrice' and @SortOrder = 'des' then MostRecentPrice else null end desc,
			case when @SortBy = 'MostRecentPriceHi' and @SortOrder = 'asc' then MostRecentPriceHi else null end asc, 
			case when @SortBy = 'MostRecentPriceHi' and @SortOrder = 'des' then MostRecentPriceHi else null end desc,
			case when @SortBy = 'MostRecentAuctionPrice' and @SortOrder = 'asc' then MostRecentAuctionPrice else null end asc, 
			case when @SortBy = 'MostRecentAuctionPrice' and @SortOrder = 'des' then MostRecentAuctionPrice else null end desc,
			case when @SortBy = 'Maturity' and @SortOrder = 'asc' then Maturity else null end asc, 
			case when @SortBy = 'Maturity' and @SortOrder = 'des' then Maturity else null end desc,
			ProducerShow, LabelName, Vintage, WineN)
	from Wine (nolock)
	where
			(@WineProducer = '*' or contains((Producer, ProducerShow), @WineProducer))
		and (@WineLabel = '*' or contains((encodedKeyWords,labelname,producershow), @WineLabel))	-- LabelName for proper search by macroses
		and (@TextSearch = '*' or contains((encodedKeyWords, ProducerShow, LabelName), @TextSearch))
		and (@Notes = '*' or contains(Notes, @Notes))
		
		and (@WineVintage is NULL or Vintage like @WineVintage)
		and (@WineType is NULL or WineType = @WineType)
		and (@WineColor is NULL or ColorClass = @WineColor)
		and (@WineVariety is NULL or Variety = @WineVariety)
		and (@WineCountry is NULL or Country = @WineCountry)
		and (@WinePlaces is NULL or Places = @WinePlaces)
		and (@WineMaturityID is NULL or Maturity = @WineMaturityID)
		
		and (@Publication is NULL or Publication = @Publication)
		and (@Issue is NULL or Issue = @Issue)
		and (@ArticleID is NULL or ArticleID = @ArticleID)
		and (@Author is NULL or source = @Author)
		
		and (@WineCostLimit is NULL or (MostRecentPrice is not null and MostRecentPrice <= @WineCostLimit))
		and (@WineRatingLimit is NULL or (Rating is not null and Rating >= @WineRatingLimit))

		and (@IsWineOnAuction is NULL or IsCurrentlyOnAuction = @IsWineOnAuction)
		and (@IsWineForSale is NULL or IsCurrentlyForSale = @IsWineForSale)
		and (@IsTasteNoteExists is NULL or (Notes is NOT NULL and Notes!= ''))
		and (@showForERP is NULL or showForERP = @showForERP)
		and (@showForWJ is NULL or showForWJ = @showForWJ)
		and (@IsActiveWineN is NULL or IsActiveWineN = @IsActiveWineN)
	)
	select *
	from res
	where RowNumber between @StartRow and @EndRow
	order by RowNumber
end

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[AdvancedSearch_01A] TO [RP_DataAdmin]
    AS [dbo];

