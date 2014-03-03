-- =============================================
-- Author:		Alex B.
-- Create date: 1/26/2014
-- Description:	Adds new Tastin Event.
-- =============================================
CREATE PROCEDURE [dbo].[TastingEvent_Add]
	--@ID int = NULL, 
	@UserId int = NULL, 
	@Title nvarchar(255), 
	@StartDate date = NULL, @EndDate date = NULL,

	@Location nvarchar(100) = NULL,
	@locCountry nvarchar(50) = NULL, @locRegion nvarchar(50) = NULL, 
	@locLocation nvarchar(50) = NULL, @locLocale nvarchar(50) = NULL, @locSite nvarchar(50) = NULL,
	
	@Notes nvarchar(max) = NULL,
	@SortOrder smallint = 0,
	
	@WF_StatusID smallint = NULL,
	--@UserName varchar(50),
	@ShowRes smallint = 1
	
/*
declare @r int
exec @r = TastingEvent_Add @ReviewerID=2,
	@Title = 'Test Flight', @StartDate=NULL,
	@locCountry = 'France',
	@Notes = 'First in my list...',
	@WF_StatusID = NULL
select @r
*/

AS
set nocount on
set xact_abort on

declare @Result int, 
		@CreatorID int

select @UserId = nullif(@UserId, 0)

------------ Checks
if @UserId is NOT NULL 
	select @UserId = UserId from Users (nolock) where UserId = @UserId
if @UserId is NULL begin
	raiserror('TastingEvent_Add:: @UserId is required.', 16, 1)
	RETURN -2
end

------------- Audit
--if len(isnull(@UserName, '')) < 1 begin
--	raiserror('TastingEvent_Add:: @UserName is required.', 16, 1)
--	RETURN -1
--end
--exec @CreatorID = Audit_GetLookupID @ObjectName = 'entryuser', @ObjectValue = @UserName
------------ Checks

------------ Lookup IDs
declare @locCountryID int, @locRegionID int, @locLocationID int, @locLocaleID int, @locSiteID int
exec @locCountryID = Location_GetLookupID @ObjectName='locCountry', @ObjectValue=@locCountry, @IsAutoCreate=1
exec @locRegionID = Location_GetLookupID @ObjectName='locRegion', @ObjectValue=@locRegion, @IsAutoCreate=1
exec @locLocationID = Location_GetLookupID @ObjectName='locLocation', @ObjectValue=@locLocation, @IsAutoCreate=1
exec @locLocaleID = Location_GetLookupID @ObjectName='locLocale', @ObjectValue=@locLocale, @IsAutoCreate=1
exec @locSiteID = Location_GetLookupID @ObjectName='locSite', @ObjectValue=@locSite, @IsAutoCreate=1
------------ Lookup IDs

BEGIN TRY
	BEGIN TRANSACTION

	insert into TastingEvent (UserId,
		Title, StartDate, EndDate, Location,
		locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
		Notes, SortOrder,
		created, updated, WF_StatusID)
	values (@UserId,
		@Title, @StartDate, @EndDate, @Location,
		@locCountryID, @locRegionID, @locLocationID, @locLocaleID, @locSiteID,
		@Notes, isnull(@SortOrder, 0),
		getdate(), null, isnull(@WF_StatusID, 0))
	if @@error <> 0 begin
		select @Result = -1
		ROLLBACK TRAN
	end else begin
		select @Result = scope_identity()
	--	declare @msg nvarchar(1024) = dbo.fn_GetObjectDescription('WineProducer', @Result)
	--	exec Audit_Add @Type='Success', @Category='Add', @Source='SQL', @UserName=@UserName, @MachineName='', 
	--		@ObjectType='WineProducer', @ObjectID=@Result, @Description='WineProducer added', @Message=@msg,
	--		@ShowRes=0
	end

	COMMIT TRANSACTION
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
    ON OBJECT::[dbo].[TastingEvent_Add] TO [RP_DataAdmin]
    AS [dbo];

