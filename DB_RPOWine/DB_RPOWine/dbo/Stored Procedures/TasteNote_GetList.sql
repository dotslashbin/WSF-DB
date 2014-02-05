-- =============================================
-- Author:		Alex B.
-- Create date: 1/28/2014
-- Description:	Gets List of Taste Notes.
--				Input parameters are used as a filter.
-- =============================================
CREATE PROCEDURE [dbo].[TasteNote_GetList]
	@ID int = NULL, 
	@ReviewerID int = NULL, @ReviewerUserID int = NULL, @ReviewerName nvarchar(120) = NULL,
	@Wine_N_ID int = NULL,

	@ShowRes smallint = 1
	
/*
exec TasteNote_GetList @ReviewerID = 5

TODO: add filter by 
	- Publication
	- Rating
	- Drink Date
*/
	
AS
set nocount on

if @ReviewerID is NOT NULL 
	select @ReviewerID = ID from Reviewer (nolock) where ID = @ReviewerID
else if @ReviewerUserID is NOT NULL
	select @ReviewerID = ID from Reviewer (nolock) where UserId = @ReviewerUserID
else
	select @ReviewerID = ID from Reviewer (nolock) where Name = @ReviewerName

if @Wine_N_ID is NOT NULL and not exists(select * from Wine_N (nolock) where ID = @Wine_N_ID) begin
	raiserror('TasteNote_GetList:: Wine_N record with ID=%i does not exist.', 16, 1, @Wine_N_ID)
	RETURN -1
end

	select 
		ID = tn.ID,
		OriginID = tn.OriginID,
		ReviewerID = tn.ReviewerID,
		ReviewerName = r.Name,
		
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
		join Reviewer r (nolock) on tn.ReviewerID = r.ID
		join WF_Statuses wfs (nolock) on tn.WF_StatusID = wfs.ID
		join vWineDetails w on tn.Wine_N_ID = w.Wine_N_ID
		join WineMaturity wm (nolock) on tn.MaturityID = wm.ID
	where tn.ID = isnull(@ID, tn.ID)
		and (@ReviewerID is NULL or tn.ReviewerID = @ReviewerID)
		and (@Wine_N_ID is NULL or tn.Wine_N_ID = @Wine_N_ID)
	order by TasteDate desc, ReviewerName, tn.ID
	
RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[TasteNote_GetList] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[TasteNote_GetList] TO [RP_Customer]
    AS [dbo];

