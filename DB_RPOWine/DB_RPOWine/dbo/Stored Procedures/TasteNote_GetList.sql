-- =============================================
-- Author:		Alex B.
-- Create date: 1/28/2014
-- Description:	Gets List of Taste Notes.
--				Input parameters are used as a filter.
-- =============================================
CREATE PROCEDURE [dbo].[TasteNote_GetList]
	@ID int = NULL, 
	@UserId int = NULL,
	@Wine_N_ID int = NULL,

	@ShowRes smallint = 1
	
/*
exec TasteNote_GetList @UserID = -5

TODO: add filter by 
	- Publication
	- Rating
	- Drink Date
*/
	
AS
set nocount on

if @UserId is NOT NULL 
	select @UserId = UserId from Users (nolock) where UserId = @UserId

if @Wine_N_ID is NOT NULL and not exists(select * from Wine_N (nolock) where ID = @Wine_N_ID) begin
	raiserror('TasteNote_GetList:: Wine_N record with ID=%i does not exist.', 16, 1, @Wine_N_ID)
	RETURN -1
end

	select 
		ID = tn.ID,
		OriginID = tn.OriginID,
		UserId = tn.UserId,
		UserrName = u.FullName,
		
		Wine_N_ID = tn.Wine_N_ID,
		Wine_ProducerID = w.ProducerID,
		Wine_Producer = w.ProducerToShow,
		Wine_Appellation = w.Appellation,
		Wine_Label = w.Label,
		Wine_Vintage = w.Vintage,
		Wine_Name = w.Name,

		TasteDate = tn.TasteDate, 
		MaturityID = tn.MaturityID, 
		MaturityName = wm.Name,
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
	where tn.ID = isnull(@ID, tn.ID)
		and (@UserId is NULL or tn.UserId = @UserId)
		and (@Wine_N_ID is NULL or tn.Wine_N_ID = @Wine_N_ID)
	order by TasteDate desc, UserName, tn.ID
	
RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[TasteNote_GetList] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[TasteNote_GetList] TO [RP_Customer]
    AS [dbo];

