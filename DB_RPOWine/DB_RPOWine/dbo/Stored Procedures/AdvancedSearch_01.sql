-- =============================================
-- Author:		Alex B.
-- Create date: 4/27/14
-- Description:	Returns search results
--				1st stage of advanced search functionality
-- =============================================
CREATE PROCEDURE dbo.AdvancedSearch_01
	@Keyword varchar(50)
	
/*
exec AdvancedSearch_01 @Keyword='port'
*/
	
AS
set nocount on;
	
if len(isnull(@Keyword,'')) < 1 begin
	raiserror('AdvancedSearch_01:: @Keyword is required.', 16, 1)
	RETURN -1
end

select top 500  
	[Vintage], 
	[Vintages] =  Case Vintage  WHEN '' THEN ''  ELSE Vintage  END,  
	[RatingString] = ISNULL(Rating,''),  
	[RatingShow] = ISNULL(RatingShow,''),  
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
	ReviewerIdN=ISNULL(ReviewerIdN,''), 
	[Maturity]=ISNULL(Maturity,'6'),  
	[VinN] 
from Wine
where isActiveWineN = 1
	and contains((encodedKeyWords,labelname,producershow), @Keyword)
	and (showForERP=1) 
order by Rating desc

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[AdvancedSearch_01] TO [RP_DataAdmin]
    AS [dbo];

