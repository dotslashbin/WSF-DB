-- =============================================
-- Author:		Alex B.
-- Create date: 8/5/14
-- Description:	Returns search results
--				2nd intermediate screen of Wine Search functionality
-- =============================================
CREATE PROCEDURE [dbo].[Wine_Search_02]
	@IsTWASearch bit = 1,
	@IsWA bit = 0, @IsWJ bit = 0, @IsOnSale bit = 0,
	@Keyword varchar(250),
	@SortBy varchar(20) = NULL, @SortOrder varchar(3) = NULL,
	@wProducerID int = NULL
	
--
-- @IsTWASearch set to 1 when "The Wine Advocate Search"
-- @IsWA set to 1 when WA.Checked = True
-- @IsWJ set to 1 when WJ.Checked = True
-- @IsOnSale set to 1 when FIO.Checked = True
--
-- Valid values for sorting are:
--	@SortBy: countWines, ScreenWineName
--	@SortOrder: asc, desc
--
	
/*
exec Wine_Search_02 @IsTWASearch=1, @IsWA = 1, @IsWJ = 0, @IsOnSale = 1, @Keyword='port'
*/
	
AS
set nocount on;
	
if len(isnull(@Keyword,'')) < 1 begin
	raiserror('Wine_Search_02:: @Keyword is required.', 16, 1)
	RETURN -1
end

if @IsTWASearch = 1 begin
	; with r as (
		select 
			wProducerID, wLabelID, wColorID,
			ScreenWineName = isnull(ProducerShow,'') + ' ' +  isnull(LabelName,''),
			ColorClass,
			CntVintage = count(distinct Vintage),
			CntShowForERP = sum(case when isActiveWineN = 1 and showForERP = 1 then 1 else 0 end),
			CntForSale = sum(case when isActiveWineN = 1 and showForERP = 1 and isCurrentlyForSale = 1 then 1 else 0 end),
			CntHasTasting = sum(case when isActiveWineN = 1 and showForERP = 1 and TasteNote_ID > 0 then 1 else 0 end),
			CntForSaleAndHasTasting = sum(case when isActiveWineN = 1 and isCurrentlyForSale = 1 and showForERP = 1 and TasteNote_ID > 0 then 1 else 0 end)
		from Wine (nolock)
		where isActiveWineN = 1 and showForERP = 1
			and contains((encodedKeyWords,labelname,producershow), @Keyword)
			and (@wProducerID is NULL or wProducerID = @wProducerID)
		group by wProducerID, wLabelID, wColorID, isnull(ProducerShow,'') + ' ' +  isnull(LabelName,''), ColorClass
	)
	select 
		ScreenWineName, 
		ColorClass, 
		countWines = case 
			when @IsWA = 0 and @IsOnSale = 0 then CntVintage
			when @IsWA = 1 and @IsOnSale = 0 then CntHasTasting 
			else CntForSaleAndHasTasting 
		end, 
		Price = isnull(CntForSale, 0),
		--case isnull(CntForSale, 0)
		--	when 0 then '<img src=''images/icons/spacer.gif'' border=0>'   
		--	else '<img src=images/icons/$.jpg border=0 alt=''Click to see Current Retailer Offering(s) of this wine'' title=''Click to see Current Retailer Offering(s) of this wine''>'
		--end,  
		Reviewer = isnull(CntHasTasting, 0),
		--case isnull(CntHasTasting, 0)    
		--	when 0 then '<img src=''images/icons/spacer.gif'' border=0>'   
		--	else '<img src=''images/icons/corkscrew.gif'' border=0   alt=''Click to see the Wine Advocate Review(s) of this wine'' title=''Click to see the Wine Advocate Review(s) of this wine''>'
		--end,  
		CntHasTasting,  
		CntForSaleAndHasTasting,  
		CntForSale,   
		wProducerID, 
		wLabelID, 
		wColorID
	from r
	where 			
		(	 (@IsWA = 0 and @IsOnSale = 0 and CntVintage > 0)
		  or (@IsWA = 0 and @IsOnSale = 1 and CntForSale > 0)
		  or (@IsWA = 1 and @IsOnSale = 0 and CntHasTasting > 0)
		  or (@IsWA = 1 and @IsOnSale = 1 and CntForSaleAndHasTasting > 0)
		  )
	order by 
		case when @SortBy = 'countWines' and @SortOrder = 'asc' then 
			case when @IsOnSale = 0 then CntHasTasting else CntForSaleAndHasTasting end
			else null end asc, 
		case when @SortBy = 'countWines' and @SortOrder = 'des' then 
			case when @IsOnSale = 0 then CntHasTasting else CntForSaleAndHasTasting end
			else null end desc,
		case when @SortBy = 'ScreenWineName' and @SortOrder = 'asc' then ScreenWineName else null end asc, 
		case when @SortBy = 'ScreenWineName' and @SortOrder = 'des' then ScreenWineName else null end desc,
		ScreenWineName
end else if @IsTWASearch = 0 begin
	; with f as (
		select 
			WineID = w.ID,
			wWineN = w.WineN,
			rn = row_number() over(partition by WineN order by WineN, tn.TasteDate desc)
		from Wine w (nolock)
			join TasteNote tn (nolock) on w.TasteNote_ID = tn.ID
		where --w.IsActiveWineN = 1 and 
			w.showForWJ = 1
			and contains((encodedKeyWords,labelname,producershow), @Keyword)
			and (@wProducerID is NULL or wProducerID = @wProducerID)
	),
	r as (
		select 
			wProducerID, wLabelID, wColorID,
			ScreenWineName = isnull(ProducerShow,'') + ' ' +  isnull(LabelName,''),
			ColorClass,
			CntVintage = count(distinct Vintage),
			CntShowForWJ = sum(case when showForWJ = 1 then 1 else 0 end),
			CntForSale = sum(case when showForWJ = 1 and isCurrentlyForSale = 1 then 1 else 0 end),
			CntHasTasting = sum(case when showForWJ = 1 and TasteNote_ID > 0 then 1 else 0 end),
			CntForSaleAndHasTasting = sum(case when isCurrentlyForSale = 1 and showForWJ = 1 and TasteNote_ID > 0 then 1 else 0 end)
		from Wine (nolock)
			join f on Wine.ID = f.WineID
		where f.rn = 1
		--where --isActiveWineN = 1
		--	showForWJ = 1
		--	and contains((encodedKeyWords,labelname,producershow), @Keyword)
		--	and (@wProducerID is NULL or wProducerID = @wProducerID)
		group by wProducerID, wLabelID, wColorID, isnull(ProducerShow,'') + ' ' +  isnull(LabelName,''), ColorClass
	)
	select 
		ScreenWineName, 
		ColorClass, 
		countWines = case 
			when @IsWJ = 0 and @IsOnSale = 0 then CntVintage
			when @IsWJ = 1 and @IsOnSale = 0 then CntHasTasting 
			else CntForSaleAndHasTasting 
		end, 
		Price = isnull(CntForSale, 0),
		--case isnull(CntForSale, 0)
		--	when 0 then '<img src=''images/icons/spacer.gif'' border=0>'   
		--	else '<img src=images/icons/$.jpg border=0 alt=''Click to see Current Retailer Offering(s) of this wine'' title=''Click to see Current Retailer Offering(s) of this wine''>'
		--end,  
		Reviewer = isnull(CntHasTasting, 0),
		--case isnull(CntHasTasting, 0)    
		--	when 0 then '<img src=''images/icons/spacer.gif'' border=0>'   
		--	else '<img src=''images/icons/corkscrew.gif'' border=0   alt=''Click to see the Wine Advocate Review(s) of this wine'' title=''Click to see the Wine Advocate Review(s) of this wine''>'
		--end,  
		CntHasTasting,  
		CntForSaleAndHasTasting,  
		CntForSale,   
		wProducerID, 
		wLabelID, 
		wColorID
	from r
	where 			
		(    (@IsWJ = 0 and @IsOnSale = 0 and CntVintage > 0)
		  or (@IsWJ = 0 and @IsOnSale = 1 and CntForSale > 0)
		  or (@IsWJ = 1 and @IsOnSale = 0 and CntHasTasting > 0)
		  or (@IsWJ = 1 and @IsOnSale = 1 and CntForSaleAndHasTasting > 0)
		  )
	order by 
		case when @SortBy = 'countWines' and @SortOrder = 'asc' then 
			case when @IsOnSale = 0 then CntHasTasting else CntForSaleAndHasTasting end
			else null end asc, 
		case when @SortBy = 'countWines' and @SortOrder = 'des' then 
			case when @IsOnSale = 0 then CntHasTasting else CntForSaleAndHasTasting end
			else null end desc,
		case when @SortBy = 'ScreenWineName' and @SortOrder = 'asc' then ScreenWineName else null end asc, 
		case when @SortBy = 'ScreenWineName' and @SortOrder = 'des' then ScreenWineName else null end desc,
		ScreenWineName
end

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Wine_Search_02] TO [RP_DataAdmin]
    AS [dbo];

