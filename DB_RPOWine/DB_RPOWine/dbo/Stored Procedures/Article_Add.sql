CREATE PROCEDURE [dbo].[Article_Add]
	--@ID int,
	@PublicationID int, @AuthorId int, @Author nvarchar(50),
    @Title nvarchar(255), 
    
    @ShortTitle nvarchar(150) = NULL, @Date date = NULL,
	@Notes nvarchar(max) = NULL,
	@MetaTags nvarchar(max) = NULL, @Event nvarchar(100) = NULL, 
	@CuisineID int = 0, @Cuisine nvarchar(30) = NULL,
	
	@locCountry nvarchar(50) = NULL, @locRegion nvarchar(50) = NULL, 
	@locLocation nvarchar(50) = NULL, @locLocale nvarchar(50) = NULL, @locSite nvarchar(50) = NULL,
	@locState nvarchar(50) = NULL, @locCity nvarchar(50) = NULL,
	
	@WF_StatusID smallint = 0,

	@oldArticleIdN int = NULL, @oldArticleId int = NULL, @oldArticleIdNKey int = NULL,
	@FileName varchar(50) = NULL, @Producer nvarchar(100) = NULL, @Source nvarchar(100) = NULL,
	@Topic nvarchar(100) = NULL, @Type nvarchar(100) = NULL, @Wine_Numbers nvarchar(500) = NULL,
	@Wines nvarchar(500) = NULL, @Vintage nvarchar(100) = NULL, @Appellation nvarchar(100) = NULL,
	
	@ShowRes smallint = 1
	
/*
declare @r int
exec @r = Article_Add @PublicationID=2, @AuthorId=0, @Author='Test',
    @Title='TestArticle', @ShortTitle='Short title...',	@Notes='Just trying to add a new article...'
select @r
*/

AS
set nocount on
set xact_abort on

declare @Result int, 
		@CreatorID int
		
------------ Checks
if isnull(@Author, '') = '' begin
	raiserror('Article_Add:: Author is required.', 16, 1)
	RETURN -1
end
if isnull(@Title, '') = '' begin
	raiserror('Article_Add:: Title is required.', 16, 1)
	RETURN -1
end

if not exists(select * from Publication (nolock) where ID = @PublicationID) begin
	raiserror('Article_Add:: Publication record with ID=%i does not exist.', 16, 1, @PublicationID)
	RETURN -1
end

if @AuthorId is NOT NULL and not exists(select * from Users (nolock) where UserId = @AuthorId) begin
	raiserror('Article_Add:: User record with ID=%i does not exist.', 16, 1, @AuthorId)
	RETURN -1
end

if isnull(@CuisineID, 0) < 1 and isnull(@Cuisine, '') != ''
	exec @CuisineID = GetLookupID @ObjectName='cuisine', @ObjectValue=@Cuisine
if isnull(@CuisineID, 0) < 1 or not exists(select * from Cuisine (nolock) where ID = @CuisineID)
	select @CuisineID = 0
	
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

	insert into Article (PublicationID, AuthorId, Author,
		Title, ShortTitle, Date, Notes, MetaTags, Event, CuisineID, 
		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID, locStateID, locCityID,
		WF_StatusID,
		oldArticleIdN, oldArticleId, oldArticleIdNKey,
		FileName, Producer, Source,	Topic, Type, Wine_Numbers, Wines, Vintage, Appellation,
		created, updated)
	values (@PublicationID, @AuthorId, isnull(@Author, ''),
		@Title, @ShortTitle, @Date, isnull(@Notes,''), @MetaTags, @Event, isnull(@CuisineID, 0),
		isnull(@locCountryID,0), isnull(@locRegionID,0), isnull(@locLocationID,0), isnull(@locLocaleID,0), isnull(@locSiteID,0), isnull(@locStateID,0), isnull(@locCityID,0),
		isnull(@WF_StatusID,0),
		@oldArticleIdN, @oldArticleId, @oldArticleIdNKey,
		@FileName, @Producer, @Source, @Topic, @Type, @Wine_Numbers, @Wines, @Vintage, @Appellation,
		getdate(), null)
	if @@error <> 0 begin
		select @Result = -1
		--ROLLBACK TRAN
	end else begin
		select @Result = scope_identity()
	end

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
    ON OBJECT::[dbo].[Article_Add] TO [RP_DataAdmin]
    AS [dbo];

