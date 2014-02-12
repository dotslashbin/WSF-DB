-- =============================================
-- Author:		Alex B.
-- Create date: 1/31/2014
-- Description:	Searches for a Wine (Wine_N) and returns internal ID of the wine.
--				If a particular Wine_N record cannot be found, it will be created and new ID returned.
-- =============================================
CREATE PROCEDURE [dbo].[Wine_GetID]
	--@ID int = NULL, 
	@Producer nvarchar(100), @WineType nvarchar(50), @Label nvarchar(120),
	@Variety nvarchar(50), @Dryness nvarchar(30), @Color nvarchar(30),
	@Vintage nvarchar(4),
	
	@locCountry nvarchar(25) = NULL, @locRegion nvarchar(50) = NULL, 
	@locLocation nvarchar(50) = NULL, @locLocale nvarchar(50) = NULL, @locSite nvarchar(50) = NULL,
	
	@WF_StatusID smallint = NULL,
	--@UserName varchar(50),
	@IsAutoCreate bit = 1,
	@ShowRes smallint = 1

/*
declare @r int
exec @r = Wine_GetID @Producer = 'Gerard Depardieu', @WineType = 'Table', @Label = 'Domaine de St. Augustin',
	@Variety = 'Proprietary Blend', @Dryness = 'Dry', @Color = 'Red',
	@Vintage = '2002',
	@locCountry = 'Algeria', @locRegion = 'Coteaux de Tlemcen', 
	@locLocation = 'a', @locLocale = NULL, @locSite = NULL,
	@WF_StatusID = NULL, @IsAutoCreate = 0
select @r
*/

AS
set nocount on
set xact_abort on

declare @Result int, 
		@CreatorID int,
		@Wine_VinN_ID int

------------ Checks
if @IsAutoCreate = 1 and (len(isnull(@Vintage, '')) < 1)
begin
	select @Result = -1
	raiserror('Wine_GetID:: Cannot find or register a new Wine: vintage is required.', 16, 1)
	RETURN -1
end
------------ Checks

------------- Audit
--if len(isnull(@UserName, '')) < 1 begin
--	raiserror('WineVin_GetID:: @UserName is required.', 16, 1)
--	RETURN -1
--end
--exec @CreatorID = Audit_GetLookupID @ObjectName = 'entryuser', @ObjectValue = @UserName

exec @Wine_VinN_ID = WineVin_GetID	
	@Producer=@Producer, @WineType=@WineType, @Label=@Label, @Variety=@Variety, @Dryness=@Dryness, @Color=@Color,
	@locCountry=@locCountry, @locRegion=@locRegion, @locLocation=@locLocation, @locLocale=@locLocale, @locSite=@locSite,
	@WF_StatusID = @WF_StatusID,
	--@UserName = @UserName,
	@IsAutoCreate = @IsAutoCreate,
	@ShowRes = 0
if @Wine_VinN_ID < 1 begin
	select @Result = @Wine_VinN_ID
	raiserror('Wine_GetID:: Cannot find or register a new WineVin.', 16, 1)
	if @ShowRes = 1
		select Result = isnull(@Result, -1)
	RETURN isnull(@Result, -1)
end

BEGIN TRY
	BEGIN TRANSACTION

	------------ Lookup IDs
	declare @VintageID int
	exec @VintageID = Wine_GetLookupID @ObjectName='winevintage', @ObjectValue=@Vintage, @IsAutoCreate=@IsAutoCreate
	------------ Lookup IDs

	------------ Checks
	if @VintageID < 1 begin
		select @Result = -1
		raiserror('Wine_GetID:: Cannot find or register a new Wine: vintage is required.', 16, 1)
	end
	------------ Checks

	-- this is a unique key therefore only 1 record can be returned
	select @Result = ID from Wine_N
	where Wine_VinN_ID = @Wine_VinN_ID and VintageID = @VintageID
	if @Result is NULL begin
		insert into Wine_N (Wine_VinN_ID, VintageID,
			created, updated, WF_StatusID)
		values (@Wine_VinN_ID, @VintageID,
            getdate(), null, isnull(@WF_StatusID, 0))
		if @@error <> 0 begin
			select @Result = -1
			ROLLBACK TRAN
		end else begin
			select @Result = scope_identity()
		--	declare @msg nvarchar(1024) = dbo.fn_GetObjectDescription('Wine_N', @Result)
		--	exec Audit_Add @Type='Success', @Category='Add', @Source='SQL', @UserName=@UserName, @MachineName='', 
		--		@ObjectType='Wine_N', @ObjectID=@Result, @Description='Wine_N added', @Message=@msg,
		--		@ShowRes=0
		end
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
    ON OBJECT::[dbo].[Wine_GetID] TO [RP_DataAdmin]
    AS [dbo];

