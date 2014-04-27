-- =============================================
-- Author:		Alex B.
-- Create date: 4/1/2014
-- Description:	Updates existing Article.
-- =============================================
CREATE PROCEDURE [dbo].[Article_Update]
	@ID int,
	@PublicationID int = NULL, @AuthorId int = NULL, @Author nvarchar(50) = NULL,
    @Title nvarchar(255) = NULL, 
    
    @ShortTitle nvarchar(150) = NULL, @Date date = NULL,
	@Notes nvarchar(max) = NULL,
	@MetaTags nvarchar(max) = NULL, @Event nvarchar(120) = NULL, 
	@CuisineID int = NULL, @Cuisine nvarchar(30) = NULL,
	@locCountry nvarchar(50) = NULL, @locRegion nvarchar(50) = NULL, 
	@locLocation nvarchar(50) = NULL, @locLocale nvarchar(50) = NULL, @locSite nvarchar(50) = NULL,
	@locState nvarchar(50) = NULL, @locCity nvarchar(50) = NULL,

	@WF_StatusID smallint = NULL,

	@oldArticleIdN int = NULL, @oldArticleId int = NULL, @oldArticleIdNKey int = NULL,
	@FileName varchar(50) = NULL, @Producer nvarchar(100) = NULL, @Source nvarchar(100) = NULL,
	@Topic nvarchar(100) = NULL, @Type nvarchar(100) = NULL, @Wine_Numbers nvarchar(500) = NULL,
	@Wines nvarchar(500) = NULL, @Vintage nvarchar(100) = NULL, @Appellation nvarchar(100) = NULL,
	
	@ShowRes smallint = 1
	
/*
declare @r int
exec @r = Article_Update @ID=4796, @PublicationID=2, @AuthorId=0, @Author='Test',
    @Title='TestArticle', @ShortTitle='Short title 2...',	@Notes='Just trying to add a new article 2...'
select @r
*/

AS
set nocount on
set xact_abort on

declare @Result int, 
		@CreatorID int

------------ Checks
if isnull(@ID, 0) < 1 or not exists(select * from Article (nolock) where ID = @ID) begin
	raiserror('Article_Update:: Article record with ID=%i does not exist.', 16, 1, @ID)
	RETURN -1
end

if isnull(@Author, 'a') = '' begin
	raiserror('Article_Update:: Author is required.', 16, 1)
	RETURN -1
end
if isnull(@Title, 'a') = '' begin
	raiserror('Article_Update:: Title is required.', 16, 1)
	RETURN -1
end

if @PublicationID is NOT NULL and not exists(select * from Publication (nolock) where ID = @PublicationID) begin
	raiserror('Article_Update:: Publication record with ID=%i does not exist.', 16, 1, @PublicationID)
	RETURN -1
end

if @AuthorId is NOT NULL and not exists(select * from Users (nolock) where UserId = @AuthorId) begin
	raiserror('Article_Update:: User record with ID=%i does not exist.', 16, 1, @AuthorId)
	RETURN -1
end

if isnull(@CuisineID, 0) < 1 and isnull(@Cuisine, '') != ''
	exec @CuisineID = GetLookupID @ObjectName='cuisine', @ObjectValue=@Cuisine
if @CuisineID is NOT NULL and not exists(select * from Cuisine (nolock) where ID = @CuisineID)
	select @CuisineID = NULL
	
declare @locCountryID int, @locRegionID int, @locLocationID int, @locLocaleID int, @locSiteID int,
	@locStateID int, @locCityID int
exec @locCountryID = Location_GetLookupID @ObjectName='locCountry', @ObjectValue=@locCountry, @IsAutoCreate=1
exec @locRegionID = Location_GetLookupID @ObjectName='locRegion', @ObjectValue=@locRegion, @IsAutoCreate=1
exec @locLocationID = Location_GetLookupID @ObjectName='locLocation', @ObjectValue=@locLocation, @IsAutoCreate=1
exec @locLocaleID = Location_GetLookupID @ObjectName='locLocale', @ObjectValue=@locLocale, @IsAutoCreate=1
exec @locSiteID = Location_GetLookupID @ObjectName='locSite', @ObjectValue=@locSite, @IsAutoCreate=1
exec @locStateID = Location_GetLookupID @ObjectName='locState', @ObjectValue=@locState, @IsAutoCreate=1
exec @locCityID = Location_GetLookupID @ObjectName='locCity', @ObjectValue=@locCity, @IsAutoCreate=1
---------- Checks

BEGIN TRY
	--BEGIN TRANSACTION

	update Article set 
		PublicationID = isnull(@PublicationID, PublicationID), 
		AuthorId = isnull(@AuthorId, AuthorId), 
		Author = isnull(@Author, Author),
		Title = isnull(@Title, Title), 
		ShortTitle = isnull(@ShortTitle,ShortTitle), 
		Date = isnull(@Date, Date), 
		Notes = isnull(@Notes,Notes), 
		MetaTags = isnull(@MetaTags, MetaTags), 
		Event = isnull(@Event, Event), 
		CuisineID = isnull(@CuisineID, CuisineID), 
		locCountryID = case when @locCountry is NULL then locCountryID else @locCountryID end, 
		locRegionID = case when @locRegion is NULL then locRegionID else @locRegionID end, 
		locLocationID = case when @locLocation is NULL then locLocationID else @locLocationID end, 
		locLocaleID = case when @locLocale is NULL then locLocaleID else @locLocaleID end,  
		locSiteID = case when @locSite is NULL then locSiteID else @locSiteID end, 
		locStateID = case when @locState is NULL then locStateID else @locStateID end, 
		locCityID = case when @locCity is NULL then locCityID else @locCityID end, 
		
		WF_StatusID = isnull(@WF_StatusID, WF_StatusID),
		oldArticleIdN = isnull(@oldArticleIdN, oldArticleIdN), 
		oldArticleId = isnull(@oldArticleId, oldArticleId), 
		oldArticleIdNKey = isnull(@oldArticleIdNKey, oldArticleIdNKey),
		FileName = isnull(@FileName, FileName), 
		Producer = isnull(@Producer,Producer), 
		Source = isnull(@Source, Source),	
		Topic = isnull(@Topic, Topic), 
		Type = isnull(@Type, Type), 
		Wine_Numbers = isnull(@Wine_Numbers, Wine_Numbers), 
		Wines = isnull(@Wines, Wines), 
		Vintage = isnull(@Vintage,Vintage), 
		Appellation = isnull(@Appellation, Appellation),
		updated = getdate()
	where ID = @ID
	
	select @Result = @@ROWCOUNT
	if @@error <> 0
		select @Result = -1
			
	--COMMIT TRANSACTION
	
END TRY
BEGIN CATCH
	declare @errSeverity int,
			@errMsg nvarchar(2048)
	select	@errSeverity = ERROR_SEVERITY(),
			@errMsg = ERROR_MESSAGE()

    -- Test XACT_STATE:
        -- If 1, the transaction is committable.
        -- If -1, the transaction is uncommittable and should be rolled back.
        -- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
    if (xact_state() = 1 or xact_state() = -1)
		ROLLBACK TRAN

	raiserror(@errMsg, @errSeverity, 1)
END CATCH

if @ShowRes = 1 ---> always return new ID in the ADD procedure
	select Result = isnull(@Result, -1)

RETURN isnull(@Result, -1)
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Article_Update] TO [RP_DataAdmin]
    AS [dbo];

