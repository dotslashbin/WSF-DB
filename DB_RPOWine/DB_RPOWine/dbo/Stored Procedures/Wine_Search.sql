-- =============================================
-- Author:		Alex B.
-- Create date: 8/8/14
-- Description:	Returns search results
--				by producer
-- =============================================
CREATE PROCEDURE [dbo].[Wine_Search]
	@IsTWASearch bit = 1,
	@IsWA bit = 0, @IsWJ bit = 0, @IsOnSale bit = 0,
	@Keyword varchar(250),
	@wProducerID int = NULL,
	@wLabelID int = NULL, @wColorID int = NULL,
	@SortBy varchar(20) = NULL, @SortOrder varchar(3) = NULL
	
--
-- @IsTWASearch set to 1 when "The Wine Advocate Search"
-- @IsWA set to 1 when WA.Checked = True
-- @IsWJ set to 1 when WJ.Checked = True
-- @IsOnSale set to 1 when FIO.Checked = True
--
-- Valid values for sorting are:
--	@SortBy: ScreenWineName, SourceDate, MostRecentPrice, [Country, Region, Location, Locale, Site]
--	@SortOrder: asc, desc
--
	
/*
exec Wine_Search @wProducerID=2383,@IsTWASearch=1, @IsWA = 1, @IsWJ = 0, @IsOnSale = 1, @Keyword='port'
*/
	
AS
set nocount on;
	
if len(isnull(@Keyword,'')) < 1 begin
	raiserror('Wine_Search_02:: @Keyword is required.', 16, 1)
	RETURN -1
end

if @IsTWASearch = 1 begin
	select top 500  
		[Vintage], 
		[Vintages] =  Case Vintage  WHEN '' THEN ''  ELSE Vintage  END,  
		[RatingString] = ISNULL(Rating,''),  
		[RatingShow] = ISNULL(RatingShow,''),  
		[Producer], 
		[ProducerShow], 
		[LabelName], 
		[MostRecentPriceString] =  case    
			when isnull(MostRecentPrice,0) > 0 and isnull(MostRecentPriceHi,0) > 0 and MostRecentPrice != MostRecentPriceHi
				then (isnull(convert(varchar(10),convert(int,Round(MostRecentPrice,0))),''))+(isnull('-'+convert(varchar(10),convert(int,Round(MostRecentPriceHi,0))),'')) 
			when isnull(MostRecentPrice,0) > 0 and (MostRecentPriceHi is NULL or MostRecentPrice = MostRecentPriceHi or round(MostRecentPriceHi,0)=0 )
				then (isnull(convert(varchar(10),convert(int,Round(MostRecentPrice,0))),''))  
			else ''
		end , 
		[WineN],  
		[ColorClass], 
		[ScreenWineName]= isnull(ProducerShow,'') + ' ' +  isnull(LabelName,''), 
		Publication = isnull(Publication,''),  
		IsERPTasting,  
		IsWJTasting,  
		[RecentPrice] = (isnull(convert(varchar(10),convert(int,Round(MostRecentPrice,0))),'')), 
		[MostRecentPriceHi] = (isnull(convert(varchar(10),convert(int,Round(MostRecentPriceHi,0))),'')), 
		[mostRecentAuctionPrice] = (isnull(convert(varchar(10),convert(int,Round(mostRecentAuctionPrice,0))),'')), 
		[IsCurrentlyForSale], 
		[Maturity] = isnull(Maturity,'6'),  
		[VinN],
		Wine_VinN = w.Wine_VinN_ID,
		Location,
		wProducerID, wLabelID, wColorID,
		--ReviewerIdN=ISNULL(ReviewerIdN,''), 
		UserId = isnull(tn.UserId, 0)
	from Wine w (nolock)
		left join TasteNote tn (nolock) on w.TasteNote_ID = tn.ID
	where w.IsActiveWineN = 1 and w.showForERP = 1
		and contains((encodedKeyWords,labelname,producershow), @Keyword)
		and (@wProducerID is NULL or wProducerID = @wProducerID)
		and (@wLabelID is NULL or wLabelID = @wLabelID)
		and (@wColorID is NULL or wColorID = @wColorID)
		
		and ((@IsWA = 0 and @IsOnSale = 0)
		  or (@IsWA = 1 and @IsOnSale = 0 and IsERPTasting = 1 and tn.ID is NOT NULL)
		  or (@IsWA = 1 and @IsOnSale = 1 and IsERPTasting = 1 and IsCurrentlyForSale = 1)
		  or (@IsWA = 0 and @IsOnSale = 1 and IsCurrentlyForSale = 1)
		  )
	order by 
		case when @SortBy = 'ScreenWineName' and @SortOrder = 'asc' then isnull(ProducerShow,'') + ' ' +  isnull(LabelName,'') else null end asc, 
		case when @SortBy = 'ScreenWineName' and @SortOrder = 'des' then isnull(ProducerShow,'') + ' ' +  isnull(LabelName,'') else null end desc,
		
		case when @SortBy = 'Vintage' and @SortOrder = 'asc' then Vintage else null end asc, 
		case when @SortBy = 'Vintage' and @SortOrder = 'des' then Vintage else null end desc,
		case when @SortBy = 'Rating' and @SortOrder = 'asc' then isnull(Rating,'') else null end asc, 
		case when @SortBy = 'Rating' and @SortOrder = 'des' then isnull(Rating,'') else null end desc,
		case when @SortBy = 'Maturity' and @SortOrder = 'asc' then isnull(Maturity,'6') else null end asc, 
		case when @SortBy = 'Maturity' and @SortOrder = 'des' then isnull(Maturity,'6') else null end desc,
		case when @SortBy = 'RecentPrice' and @SortOrder = 'asc' then MostRecentPrice else null end asc, 
		case when @SortBy = 'RecentPrice' and @SortOrder = 'des' then MostRecentPrice else null end desc,
		
		case when @SortBy = 'Country, Region, Location, Locale, Site' and @SortOrder = 'asc' then Location else null end asc, 
		case when @SortBy = 'Country, Region, Location, Locale, Site' and @SortOrder = 'des' then Location else null end desc,
		case when @SortBy = 'SourceDate' and @SortOrder = 'asc' then Publication else null end asc, 
		case when @SortBy = 'SourceDate' and @SortOrder = 'des' then Publication else null end desc,
		case when @SortBy = 'MostRecentPrice' and @SortOrder = 'asc' then MostRecentPrice else null end asc, 
		case when @SortBy = 'MostRecentPrice' and @SortOrder = 'des' then MostRecentPrice else null end desc,
		ScreenWineName, Vintage
end else if @IsTWASearch = 0 begin
	select top 500  
		[Vintage], 
		[Vintages] =  Case Vintage  WHEN '' THEN ''  ELSE Vintage  END,  
		[RatingString] = ISNULL(Rating,''),  
		[RatingShow] = ISNULL(RatingShow,''),  
		[Producer], 
		[ProducerShow], 
		[LabelName], 
		[MostRecentPriceString] =  case    
			when isnull(MostRecentPrice,0) > 0 and isnull(MostRecentPriceHi,0) > 0 and MostRecentPrice != MostRecentPriceHi
				then (isnull(convert(varchar(10),convert(int,Round(MostRecentPrice,0))),''))+(isnull('-'+convert(varchar(10),convert(int,Round(MostRecentPriceHi,0))),'')) 
			when isnull(MostRecentPrice,0) > 0 and (MostRecentPriceHi is NULL or MostRecentPrice = MostRecentPriceHi or round(MostRecentPriceHi,0)=0 )
				then (isnull(convert(varchar(10),convert(int,Round(MostRecentPrice,0))),''))  
			else ''
		end , 
		[WineN],  
		[ColorClass], 
		[ScreenWineName]= isnull(ProducerShow,'') + ' ' +  isnull(LabelName,''), 
		Publication = isnull(Publication,''),  
		IsERPTasting,  
		IsWJTasting,  
		[RecentPrice] = (isnull(convert(varchar(10),convert(int,Round(MostRecentPrice,0))),'')), 
		[MostRecentPriceHi] = (isnull(convert(varchar(10),convert(int,Round(MostRecentPriceHi,0))),'')), 
		[mostRecentAuctionPrice] = (isnull(convert(varchar(10),convert(int,Round(mostRecentAuctionPrice,0))),'')), 
		[IsCurrentlyForSale], 
		[Maturity] = isnull(Maturity,'6'),  
		[VinN],
		Location,
		wProducerID, wLabelID, wColorID,
		--ReviewerIdN=ISNULL(ReviewerIdN,''), 
		UserId = isnull(tn.UserId, 0)
	from Wine w (nolock)
		left join TasteNote tn (nolock) on w.TasteNote_ID = tn.ID
	where --w.IsActiveWineN = 1 and 
		w.showForWJ = 1
		and contains((encodedKeyWords,labelname,producershow), @Keyword)
		and (@wProducerID is NULL or wProducerID = @wProducerID)
		and (@wLabelID is NULL or wLabelID = @wLabelID)
		and (@wColorID is NULL or wColorID = @wColorID)

		and ((@IsWJ = 0 and @IsOnSale = 0)
		  or (@IsWJ = 1 and @IsOnSale = 0 and IsWJTasting = 1 and tn.ID is NOT NULL)
		  or (@IsWJ = 1 and @IsOnSale = 1 and IsWJTasting = 1 and IsCurrentlyForSale = 1)
		  or (@IsWJ = 0 and @IsOnSale = 1 and IsCurrentlyForSale = 1)
		  )
	order by 
		case when @SortBy = 'ScreenWineName' and @SortOrder = 'asc' then isnull(ProducerShow,'') + ' ' +  isnull(LabelName,'') else null end asc, 
		case when @SortBy = 'ScreenWineName' and @SortOrder = 'des' then isnull(ProducerShow,'') + ' ' +  isnull(LabelName,'') else null end desc,
		
		case when @SortBy = 'Vintage' and @SortOrder = 'asc' then Vintage else null end asc, 
		case when @SortBy = 'Vintage' and @SortOrder = 'des' then Vintage else null end desc,
		case when @SortBy = 'Rating' and @SortOrder = 'asc' then isnull(Rating,'') else null end asc, 
		case when @SortBy = 'Rating' and @SortOrder = 'des' then isnull(Rating,'') else null end desc,
		case when @SortBy = 'Maturity' and @SortOrder = 'asc' then isnull(Maturity,'6') else null end asc, 
		case when @SortBy = 'Maturity' and @SortOrder = 'des' then isnull(Maturity,'6') else null end desc,
		case when @SortBy = 'RecentPrice' and @SortOrder = 'asc' then MostRecentPrice else null end asc, 
		case when @SortBy = 'RecentPrice' and @SortOrder = 'des' then MostRecentPrice else null end desc,
		
		case when @SortBy = 'Country, Region, Location, Locale, Site' and @SortOrder = 'asc' then Location else null end asc, 
		case when @SortBy = 'Country, Region, Location, Locale, Site' and @SortOrder = 'des' then Location else null end desc,
		case when @SortBy = 'SourceDate' and @SortOrder = 'asc' then Publication else null end asc, 
		case when @SortBy = 'SourceDate' and @SortOrder = 'des' then Publication else null end desc,
		case when @SortBy = 'MostRecentPrice' and @SortOrder = 'asc' then MostRecentPrice else null end asc, 
		case when @SortBy = 'MostRecentPrice' and @SortOrder = 'des' then MostRecentPrice else null end desc,
		ScreenWineName, Vintage

end

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Wine_Search] TO [RP_DataAdmin]
    AS [dbo];

