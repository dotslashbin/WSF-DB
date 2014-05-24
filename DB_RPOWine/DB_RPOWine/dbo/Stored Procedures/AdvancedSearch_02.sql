-- =============================================
-- Author:		Alex B.
-- Create date: 4/27/14
-- Description:	Returns search results
--				2nd stage of advanced search functionality
-- =============================================
CREATE PROCEDURE dbo.AdvancedSearch_02
	@Keyword varchar(50)
	
/*
exec AdvancedSearch_02 @Keyword='port'
*/
	
AS
set nocount on;
	
if len(isnull(@Keyword,'')) < 1 begin
	raiserror('AdvancedSearch_02:: @Keyword is required.', 16, 1)
	RETURN -1
end

; with r as (
	select 
		ScreenWineName = isnull(ProducerShow,'') + ' ' +  isnull(LabelName,''),
		ColorClass,
		CntForSale = sum(case when isCurrentlyForSale = 1 then 1 else 0 end),
		CntHasTasting = sum(case when reviewerIdN is not null then 1 else 0 end),
		CntForSaleAndHasTasting = sum(case when isCurrentlyForSale = 1 and reviewerIdN is not null then 1 else 0 end)
	from Wine (nolock)
	where isActiveWineN = 1
		and showForERP = 1
		and contains(encodedKeyWords, @Keyword) -- and (CntHasTasting >0)  
	group by isnull(ProducerShow,'') + ' ' +  isnull(LabelName,''), ColorClass
)
select 
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
where CntHasTasting > 0
order by ScreenWineName

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[AdvancedSearch_02] TO [RP_DataAdmin]
    AS [dbo];

