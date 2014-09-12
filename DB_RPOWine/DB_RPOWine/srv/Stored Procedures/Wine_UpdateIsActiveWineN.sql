-- =============================================
-- Author:		Alex B.
-- Create date: 6/13/2014
-- Description:	Updates IsActiveWineN and other bits required for the "old" site functionality.
-- =============================================
CREATE PROCEDURE [srv].[Wine_UpdateIsActiveWineN]

AS

set nocount on;
set xact_abort on;

--begin tran

	; with 
	tn1 as (
		-- No Publisher dependency version
		--select Wine_N_ID, TasteDate, ID,
		--	rn = row_number() over (partition by Wine_N_ID order by Wine_N_ID, TasteDate desc, ID)
		--from TasteNote (nolock)
		--where WF_StatusID > 99
		select Wine_N_ID, TasteDate, tn.ID,
			rn = row_number() over (partition by Wine_N_ID order by Wine_N_ID, TasteDate desc, tn.ID)
		from TasteNote tn (nolock)
			join Issue i (nolock) on tn.IssueID = i.ID
			join Publication p (nolock) on i.PublicationID = p.ID
			join Publisher pub (nolock) on p.PublisherID = pub.ID
		where tn.WF_StatusID > 99 and pub.IsPrimary = 1
	),
	tnRes as (
		select --top 20
			TasteNoteID = tn.ID,
			Wine_N_ID = tn.Wine_N_ID,
			IsActiveWineN = cast(case when act.ID is NOT NULL then 1 else 0 end as bit),
			showForERP = cast(case when pub.ID > 0 and pub.IsPrimary = 1 then 1 else 0 end as bit),	-- cast(pub.IsPrimary as bit),
			showForWJ = cast(case when pub.ID > 0 and pub.IsPrimary = 0 then 1 else 0 end as bit),
			isErpTasting = cast(case when pub.ID > 0 and pub.IsPrimary = 1 then 1 else 0 end as bit),	-- cast(pub.IsPrimary as bit),
			isWjTasting = cast(case when pub.ID > 0 and pub.IsPrimary = 0 then 1 else 0 end as bit)
		from TasteNote tn (nolock)
			join Issue i (nolock) on tn.IssueID = i.ID
			join Publication p (nolock) on i.PublicationID = p.ID
			join Publisher pub (nolock) on p.PublisherID = pub.ID
			left join (select * from tn1 where rn = 1) act on tn.ID = act.ID
		where tn.WF_StatusID > 99
	)
	update TasteNote set
		IsActiveWineN = tnRes.IsActiveWineN,
		oldShowForERP = tnRes.showForERP,
		oldShowForWJ = tnRes.showForWJ,
		oldIsErpTasting = tnRes.isErpTasting,
		oldIsWjTasting = tnRes.isWjTasting
	from tnRes
		join TasteNote tn on tnRes.TasteNoteID = tn.ID
	where (tn.IsActiveWineN != tnRes.IsActiveWineN 
		or tn.oldShowForERP != tnRes.showForERP or tn.oldShowForWJ != tnRes.showForWJ
		or tn.oldIsErpTasting != tnRes.isErpTasting or tn.oldIsWjTasting != tnRes.isWjTasting)
	;
	
--commit tran

RETURN 1