-- =============================================
-- Author:		Alex B.
-- Create date: 8/8/14
-- Description:	Returns search results
--				3rd intermediate screen of Wine Search functionality - group by Producers
-- =============================================
CREATE PROCEDURE [dbo].[Wine_Search_03]
	@IsTWASearch bit = 1,
	@IsWA bit = 0, @IsWJ bit = 0, @IsOnSale bit = 0,
	@Keyword varchar(250),
	@SortBy varchar(20) = NULL, @SortOrder varchar(3) = NULL
	
--
-- @IsTWASearch set to 1 when "The Wine Advocate Search"
-- @IsWA set to 1 when WA.Checked = True
-- @IsWJ set to 1 when WJ.Checked = True
-- @IsOnSale set to 1 when FIO.Checked = True
--
-- Valid values for sorting are:
--	@SortBy: countWines, ProducerShow
--	@SortOrder: asc, desc
--
	
/*
exec Wine_Search_03 @IsTWASearch=1, @IsWA = 1, @IsWJ = 0, @IsOnSale = 1, @Keyword='port'
*/
	
AS
set nocount on;
	
if len(isnull(@Keyword,'')) < 1 begin
	raiserror('Wine_Search_03:: @Keyword is required.', 16, 1)
	RETURN -1
end

if @IsTWASearch = 1 begin
	; with r as (
		select 
			wProducerID,
			ProducerShow,
			CntVintage = count(distinct Vintage),
			CntShowForERP = sum(case when showForERP = 1 then 1 else 0 end),
			CntForSale = sum(case when showForERP = 1 and isCurrentlyForSale = 1 then 1 else 0 end),
			CntHasTasting = sum(case when showForERP = 1 and TasteNote_ID > 0 then 1 else 0 end),
			CntForSaleAndHasTasting = sum(case when isCurrentlyForSale = 1 and showForERP = 1 and TasteNote_ID > 0 then 1 else 0 end)
		from Wine (nolock)
		where isActiveWineN = 1 and showForERP = 1
			and contains((encodedKeyWords,labelname,producershow), @Keyword)
		group by wProducerID, ProducerShow
	)
	select 
		ProducerShow, 
		Price = isnull(CntForSale, 0),
		Reviewer = isnull(CntHasTasting, 0),
		countWines = case 
			when @IsWA = 0 and @IsOnSale = 0 then CntVintage
			when @IsWA = 1 and @IsOnSale = 0 then CntHasTasting 
			else CntForSaleAndHasTasting 
		end, 
		--CntHasTasting,  
		--CntForSaleAndHasTasting,  
		--CntForSale,   
		wProducerID
	from r
	where 			
		((@IsWA = 0 and @IsOnSale = 0 and CntShowForERP > 0)
		  or (@IsWA = 1 and @IsOnSale = 0 and CntHasTasting > 0)
		  or (@IsWA = 1 and @IsOnSale = 1 and CntForSaleAndHasTasting > 0)
		  or (@IsWA = 0 and @IsOnSale = 1 and CntForSale > 0)
		  )
	order by 
		case when @SortBy = 'countWines' and @SortOrder = 'asc' then 
			case when @IsOnSale = 0 then CntHasTasting else CntForSaleAndHasTasting end
			else null end asc, 
		case when @SortBy = 'countWines' and @SortOrder = 'des' then 
			case when @IsOnSale = 0 then CntHasTasting else CntForSaleAndHasTasting end
			else null end desc,
		case when @SortBy = 'ProducerShow' and @SortOrder = 'asc' then ProducerShow else null end asc, 
		case when @SortBy = 'ProducerShow' and @SortOrder = 'des' then ProducerShow else null end desc,
		ProducerShow
end else if @IsTWASearch = 0 begin
	; with r as (
		select 
			wProducerID, 
			ProducerShow,
			CntVintage = count(distinct Vintage),
			CntShowForWJ = sum(case when showForWJ = 1 then 1 else 0 end),
			CntForSale = sum(case when showForWJ = 1 and isCurrentlyForSale = 1 then 1 else 0 end),
			CntHasTasting = sum(case when showForWJ = 1 and TasteNote_ID > 0 then 1 else 0 end),
			CntForSaleAndHasTasting = sum(case when isCurrentlyForSale = 1 and showForWJ = 1 and TasteNote_ID > 0 then 1 else 0 end)
		from Wine (nolock)
		where --isActiveWineN = 1
			showForWJ = 1
			and contains((encodedKeyWords,labelname,producershow), @Keyword)
		group by wProducerID, ProducerShow
	)
	select 
		ProducerShow, 
		Price = isnull(CntForSale, 0),
		Reviewer = isnull(CntHasTasting, 0),
		countWines = case 
			when @IsWJ = 0 and @IsOnSale = 0 then CntVintage
			when @IsWJ = 1 and @IsOnSale = 0 then CntHasTasting 
			else CntForSaleAndHasTasting 
		end, 
		--CntHasTasting,  
		--CntForSaleAndHasTasting,  
		--CntForSale,   
		wProducerID
	from r
	where 			
		((@IsWJ = 0 and @IsOnSale = 0 and CntShowForWJ > 0)
		  or (@IsWJ = 1 and @IsOnSale = 0 and CntHasTasting > 0)
		  or (@IsWJ = 1 and @IsOnSale = 1 and CntForSaleAndHasTasting > 0)
		  or (@IsWJ = 0 and @IsOnSale = 1 and CntForSale > 0)
		  )
	order by 
		case when @SortBy = 'countWines' and @SortOrder = 'asc' then 
			case when @IsOnSale = 0 then CntHasTasting else CntForSaleAndHasTasting end
			else null end asc, 
		case when @SortBy = 'countWines' and @SortOrder = 'des' then 
			case when @IsOnSale = 0 then CntHasTasting else CntForSaleAndHasTasting end
			else null end desc,
		case when @SortBy = 'ProducerShow' and @SortOrder = 'asc' then ProducerShow else null end asc, 
		case when @SortBy = 'ProducerShow' and @SortOrder = 'des' then ProducerShow else null end desc,
		ProducerShow
end

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Wine_Search_03] TO [RP_DataAdmin]
    AS [dbo];

