-- =============================================
-- Author:		Alex B.
-- Create date: 4/27/14
-- Description:	Returns list of producers
--				3rd stage of advanced search functionality
-- =============================================
CREATE PROCEDURE [dbo].[AdvancedSearch_03]
	@Keyword varchar(50)
	
/*
exec AdvancedSearch_03 @Keyword='port'
*/
	
AS
set nocount on;
	
if len(isnull(@Keyword,'')) < 1 begin
	raiserror('AdvancedSearch_03:: @Keyword is required.', 16, 1)
	RETURN -1
end

; with r as (
	select 
		ProducerShow,
		CntForSale = sum(case when isCurrentlyForSale = 1 then 1 else 0 end),
		CntHasTasting = sum(case when reviewerIdN is not null then 1 else 0 end)
	from Wine (nolock)
	where isActiveWineN = 1
		and showForERP = 1
		and contains(encodedKeyWords, @Keyword) -- and (CntHasTasting >0)  
	group by ProducerShow
)
select 
	ProducerShow ,  
	Price = case isnull(CntForSale, 0)
		when 0 then '<img src=''images/icons/spacer.gif'' border=0>'   
		else '<img src=images/icons/$.jpg border=0 alt=''Click to see only wines for this producer currently for sale'' title=''Click to see only wines for this producer currently for sale''>'
	end,  
	Reviewer = case isnull(CntHasTasting, 0)
		when 0 then '<img src=''images/icons/spacer.gif'' border=0>'
		else '<img src=''images/icons/corkscrew.gif'' border=0   alt=''Click to see only wines for this producer reviewed in The Wine Advocate'' title=''Click to see only wines for this producer reviewed in The Wine Advocate''>'
	end,   
	CountWines = CntHasTasting
from r
where CntHasTasting > 0
order by ProducerShow

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[AdvancedSearch_03] TO [RP_DataAdmin]
    AS [dbo];

