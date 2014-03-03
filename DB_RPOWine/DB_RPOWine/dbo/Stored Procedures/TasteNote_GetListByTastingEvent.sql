
-- =============================================
-- Author:		Sergiy Savchenko
-- Create date: 2/23/2014
-- Description:	Gets List of Taste Notes mapped to tasting event
-- =============================================
CREATE PROCEDURE [dbo].[TasteNote_GetListByTastingEvent]
	@TastingEventID int 


AS
set nocount on


	select 
		ID = tn.ID,
		OriginID = tn.OriginID,
		UserId = tn.UserId,
		UserrName = u.FullName,
		
		Wine_N_ID = tn.Wine_N_ID,
		Wine_ProducerID = w.ProducerID,
		Wine_Producer = w.ProducerToShow,
		Wine_Country  = w.Country,
		Wine_Region   = w.Region,
		Wine_Location = w.Location,
		Wine_Locale   = w.Locale,
		Wine_Site     = w.Site,
		Wine_Label    = w.Label,
		Wine_Vintage  = w.Vintage,
		Wine_Name     = w.Name,
		
		Wine_Type     = w.Type,
		Wine_Variety  = w.Variety,
		Wine_Drynes   = w.Dryness,
		Wine_Color    = w.Color,
		

		TasteDate     = tn.TasteDate, 
		MaturityID    = tn.MaturityID, 
		MaturityName  = wm.Name,
		MaturitySuggestion = wm.Suggestion,
		Rating_Lo = tn.Rating_Lo, 
		Rating_Hi = tn.Rating_Hi, 
		DrinkDate_Lo = tn.DrinkDate_Lo, 
		DrinkDate_Hi = tn.DrinkDate_Hi, 
		IsBarrelTasting = tn.IsBarrelTasting, 
		Notes = tn.Notes, 
		--PublicationDate = tn.oldPublicationDate,

		WF_StatusID = tn.WF_StatusID,
		WF_StatusName = wfs.Name,
		created = tn.created, 
		updated = tn.updated
	from TasteNote tn (nolock)
		join Users u (nolock) on tn.UserId = u.UserId
		join WF_Statuses wfs (nolock) on tn.WF_StatusID = wfs.ID
		join vWineDetails w on tn.Wine_N_ID = w.Wine_N_ID
		join WineMaturity wm (nolock) on tn.MaturityID = wm.ID
		join TastingEvent_TasteNote ttn  (nolock) on ttn.TasteNoteID = tn.ID
	where ttn.TastingEventID = @TastingEventID
	order by TasteDate desc, UserName, tn.ID
	
RETURN 1