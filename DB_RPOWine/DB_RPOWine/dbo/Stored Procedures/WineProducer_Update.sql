-- =============================================
-- Author:		Alex B.
-- Create date: 1/22/2014
-- Description:	Updates WineProducer record.
-- =============================================
CREATE PROCEDURE [dbo].[WineProducer_Update]
	@ID int, 
	@Name nvarchar(100) = NULL, @NameToShow nvarchar(100) = NULL,
	@WebSiteURL nvarchar(255) = NULL,
	@locCountry nvarchar(50) = NULL, @locRegion nvarchar(50) = NULL, 
	@locLocation nvarchar(50) = NULL, @locLocale nvarchar(50) = NULL, @locSite nvarchar(50) = NULL,
	@Profile nvarchar(max) = NULL, @ContactInfo nvarchar(max) = NULL, 
	
	@WF_StatusID int = NULL,
	@UserName varchar(50),
	@ShowRes smallint = 1
	
/*
declare @r int
exec @r = WineProducer_Update
	!--- careful! @ID = 14403, 
	@Name = '', @NameToShow = 'Testalonga',
	@locCountry = 'France',
	@WF_StatusID = 100,
	@UserName = 'test'
select @r

*/	

AS
set nocount on
set xact_abort on

declare @Result int, 
		@EditorID int

select @Name = nullif(rtrim(ltrim(@Name)), ''), 
	@NameToShow = nullif(rtrim(ltrim(@NameToShow)), ''),
	@WebSiteURL = nullif(rtrim(ltrim(@WebSiteURL)), '')

------------ Checks
if not exists(select * from WineProducer (nolock) where ID = @ID) begin
	raiserror('WineProducer_Update:: Wine Producer record with ID [%i] does not exist.', 16, 1, @ID)
	RETURN -1
end

if @Name is NOT NULL and exists(select * from WineProducer (nolock) where ID != @ID and upper(Name) = upper(@Name)) begin
	raiserror('[USERERROR]:: Wine Producer with the same Name already exists.', 16, 1)
	RETURN -1
end

------------ Checks
if len(isnull(@UserName, '')) < 1 begin
	raiserror('WineProducer_Update:: @UserName is required.', 16, 1)
	RETURN -1
end
exec @EditorID = Audit_GetLookupID @ObjectName = 'entryuser', @ObjectValue = @UserName
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

	update WineProducer set
		Name = isnull(@Name, Name), 
		NameToShow = isnull(@NameToShow, NameToShow), 
		WebSiteURL = isnull(@WebSiteURL, WebSiteURL),
		locCountryID = case when @locCountry is NULL then locCountryID else @locCountryID end, 
		locRegionID = case when @locRegion is NULL then locRegionID else @locRegionID end, 
		locLocationID = case when @locLocation is NULL then locLocationID else @locLocationID end, 
		locLocaleID = case when @locLocale is NULL then locLocaleID else @locLocaleID end,  
		locSiteID = case when @locSite is NULL then locSiteID else @locSiteID end, 
		[Profile] = isnull(@Profile, Profile), 
		ContactInfo = isnull(@ContactInfo, ContactInfo),
		updated = getdate(), 
		WF_StatusID = isnull(@WF_StatusID, WF_StatusID), 
		EditorID = @EditorID
	where ID = @ID

	select @Result = @@ROWCOUNT
	if @@error <> 0 begin
		select @Result = -1
		ROLLBACK TRAN
	end else begin
		declare @msg nvarchar(1024) = dbo.fn_GetObjectDescription('WineProducer', @ID)
		exec Audit_Add @Type='Success', @Category='Update', @Source='SQL', @UserName=@UserName, @MachineName='', 
			@ObjectType='WineProducer', @ObjectID=@ID, @Description='WineProducer updated', @Message=@msg,
			@ShowRes=0
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

if @ShowRes = 1
	select Result = isnull(@Result, -1)

RETURN isnull(@Result, -1)
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[WineProducer_Update] TO [RP_DataAdmin]
    AS [dbo];

