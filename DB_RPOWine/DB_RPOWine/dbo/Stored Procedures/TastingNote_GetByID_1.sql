








-- =============================================
-- Author:		Sergiy Savchenko
-- Create date: 2/23/2014
-- Description:	Gets List of Taste Notes mapped to tasting event

-- Update date: 10/2/2014
-- Description:	added two addiitonal columns to result list ratingq, importers
--              

-- =============================================
CREATE PROCEDURE [dbo].[TastingNote_GetByID]
	@ID int 


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
		WF_StatusName = '',
		created = tn.created, 
		updated = tn.updated, 
        Wine_N_WF_StatusID = w.Wine_N_WF_StatusID,
		Vin_N_WF_StatusID = w.Vin_N_WF_StatusID,
		EstimatedCost,
		EstimatedCost_Hi 

        ,RatingQ
        

      ,Importers =  REPLACE(  (select '+++IMPORTER+++'+'---new-line---'+ Name 
                     +  case
                          when LEN( isnull(Address,'')) > 0 then (', ' + Address )
                          else ''
                        end   
                     +  case
                          when LEN( isnull(Phone1,'')) > 0 then (', ' + Phone1 )
                          else ''
                        end   
                     +  case
                          when LEN( isnull(URL,'')) > 0 then (', ' + URL)
                          else ''
                        end   
                    from WineImporter wi
                    join WineProducer_WineImporter wpi  (nolock) on wpi.ImporterId  = wi.ID
                    where 
                    wpi.ProducerId = w.ProducerID
                    FOR XML PATH('')), '+++IMPORTER+++', '' )	

				
	from TasteNote tn (nolock)
		join Users u (nolock) on tn.UserId = u.UserId
		join vWineDetails w on tn.Wine_N_ID = w.Wine_N_ID
		join WineMaturity wm (nolock) on tn.MaturityID = wm.ID
		join TastingEvent_TasteNote ttn  (nolock) on ttn.TasteNoteID = tn.ID
	where tn.ID  = @ID
	order by TasteDate desc, UserName, tn.ID
	
RETURN 1