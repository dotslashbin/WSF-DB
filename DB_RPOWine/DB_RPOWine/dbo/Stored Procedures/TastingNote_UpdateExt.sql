-- =============================================
-- Author:		Alex B.
-- Create date: 9/20/2014
-- Description:	Updates extended information about TasteNote record,
--				including IsActiveWineN, HasERPTatsting, HasWJTasting flags and such.
-- =============================================
CREATE PROCEDURE [dbo].[TastingNote_UpdateExt]
	@TastingNoteID int,		-- ID of the updated record
	@oldWine_N_ID int, @newWine_N_ID int = NULL
	
AS
set nocount on;

if @newWine_N_ID is NULL 
	select @newWine_N_ID = Wine_N_ID from TasteNote (nolock) where ID = @TastingNoteID
	
if @oldWine_N_ID is NULL or @newWine_N_ID is null or @oldWine_N_ID = @newWine_N_ID
	RETURN 1	-- no changes
	
update TasteNote set oldEncodedKeyWords = '' where ID = @TastingNoteID

exec [srv].[Wine_UpdateIsActiveWineN] @Wine_N_ID1 = @oldWine_N_ID, @Wine_N_ID2 = @newWine_N_ID
	

-- extract from srv.Wine_UpdatePrices
;with has as (
	select
		tn.Wine_N_ID,
		hasWJTasting = max(case when pub.IsPrimary = 0 then 1 else 0 end),
		hasErpTasting = max(case when pub.IsPrimary = 1 then 1 else 0 end)
	from TasteNote tn (nolock)
		join Issue i (nolock) on tn.IssueID = i.ID
		join Publication p (nolock) on i.PublicationID = p.ID
		join Publisher pub (nolock) on p.PublisherID = pub.ID
	group by tn.Wine_N_ID
)
update Wine_N set
	hasWJTasting = has.hasWJTasting,
	hasERPTasting = has.hasERPTasting,
	updated = getdate()
from has
	join Wine_N wn on has.Wine_N_ID = wn.ID
where wn.ID in (@oldWine_N_ID, @newWine_N_ID)
;

exec [srv].[Wine_Reload] @IsFullReload = 0,	@Wine_N_ID1 = @oldWine_N_ID, @Wine_N_ID2 = @newWine_N_ID

RETURN 1