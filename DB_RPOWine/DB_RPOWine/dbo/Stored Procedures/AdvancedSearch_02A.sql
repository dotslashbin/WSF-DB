-- =============================================
-- Author:		Alex B.
-- Create date: 6/22/14
-- Description:	Returns search results
--				2nd stage of advanced search functionality
-- =============================================
CREATE PROCEDURE [dbo].[AdvancedSearch_02A]
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
	
	-- Sorting
	@StartRow int = NULL, @EndRow int = NULL,
	@SortBy varchar(20) = NULL, @SortOrder varchar(3) = NULL,
	
	@topNRows int = 500,
	@isDebug bit = 0
	
/*
exec AdvancedSearch_02A @SortBy = 'RecentPrice', @SortOrder = 'asc', @topNRows = 500, @isDebug = 1,
	@WineProducer = 'taylor', @WineLabel = 'port', @IsWineForSale = 1, @showForERP = 1,
	@StartRow = 7, @EndRow = 12
*/
	
AS
set nocount on;
	
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
	; with r as (
		select 
			ScreenWineName = isnull(ProducerShow,'') + ' ' +  isnull(LabelName,''),
			ColorClass,
			CntForSale = sum(case when isCurrentlyForSale = 1 then 1 else 0 end),
			CntHasTasting = sum(case when reviewerIdN is not null then 1 else 0 end),
			CntForSaleAndHasTasting = sum(case when isCurrentlyForSale = 1 and reviewerIdN is not null then 1 else 0 end)
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
		group by isnull(ProducerShow,'') + ' ' +  isnull(LabelName,''), ColorClass
	)
	select top (@topNRows) 
		ScreenWineName, 
		ColorClass, 
		countWines = CntHasTasting, 
		Price = case isnull(CntForSale, 0)
			when 0 then '<img src=''images/icons/spacer.gif'' border=0>'   
			else '<img src=images/icons/$.jpg border=0 alt=''Click to see Current Retailer Offering(s) of this wine'' title=''Click to see Current Retailer Offering(s) of this wine''>'
		end,  
		Reviewer = case isnull(CntHasTasting, 0)    
			when 0 then '<img src=''images/icons/spacer.gif'' border=0>'   
			else '<img src=''images/icons/corkscrew.gif'' border=0   alt=''Click to see the Wine Advocate Review(s) of this wine'' title=''Click to see the Wine Advocate Review(s) of this wine''>'
		end,  
		CntHasTasting,  
		CntForSaleAndHasTasting,  
		CntForSale,   
		IdN = 0
	from r
	order by 
		case when @SortBy = 'ScreenWineName' and @SortOrder = 'asc' then ScreenWineName else null end asc, 
		case when @SortBy = 'ScreenWineName' and @SortOrder = 'des' then ScreenWineName else null end desc,
		case when @SortBy = 'ColorClass' and @SortOrder = 'asc' then ColorClass else null end asc, 
		case when @SortBy = 'ColorClass' and @SortOrder = 'des' then ColorClass else null end desc,
		ScreenWineName, countWines desc
end

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[AdvancedSearch_02A] TO [RP_DataAdmin]
    AS [dbo];

