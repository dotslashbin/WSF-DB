






-- =============================================
-- Author:		Alex B.
-- Create date: 1/31/2014
-- Description:	Searches for a WineVin and returns internal ID of the record.
--				If a particular Wine_VinN record cannot be found, it will be created and new ID returned.
-- =============================================
-- 11/17/2014 do not create new record for Wine_VinN if @IsAutoCreate = 0 
-- =============================================
-- =============================================
--
-- addition 12/06/2014 Sergey
--
-- do not report error if a wine id could not be found and @IsAutoCreate is 0 
--
--
-- addition 12/21/2014 Sergey
--
-- report to Wine_VinN_Log when new Vin is created 
--
--
--
-- addition 01/17/2015 Sergey
--
-- remove insertion of a record to  Wine_VinN_Log when new record is created
--



CREATE PROCEDURE [dbo].[WineVin_GetID]
	--@ID int = NULL, 
	@Producer nvarchar(100), @WineType nvarchar(50), @Label nvarchar(120),
	@Variety nvarchar(50), @Dryness nvarchar(30), @Color nvarchar(30),

	@locCountry nvarchar(25) = NULL, @locRegion nvarchar(50) = NULL, 
	@locLocation nvarchar(50) = NULL, @locLocale nvarchar(50) = NULL, @locSite nvarchar(50) = NULL,
	
	@WF_StatusID smallint = NULL,
	--@UserName varchar(50),
	@IsAutoCreate bit = 1,
	@ShowRes smallint = 1
	
/*
declare @r int
exec @r = WineVin_GetID @Producer = 'Gerard Depardieu', @WineType = 'Table', @Label = '',
	@Variety = 'Proprietary Blend', @Dryness = 'Dry', @Color = 'Red',
	@locCountry = 'Algeria', @locRegion = 'Coteaux de Tlemcen', 
	@locLocation = 'a', @locLocale = NULL, @locSite = NULL,
	@WF_StatusID = NULL, @IsAutoCreate = 0
select @r
*/

AS
set nocount on
set xact_abort on

declare @Result int, 
		@CreatorID int

------------ Checks
if @IsAutoCreate = 1 and 
	(len(isnull(@Producer, '')) < 1 or len(isnull(@WineType, '')) < 1  or len(isnull(@Color, '')) < 1)
begin
	select @Result = -1
	raiserror('WineVin_GetID:: Cannot find or register a new WineVin: producer, wine type, label and color are required.', 16, 1)
	RETURN -1
end
------------ Checks

------------- Audit
--if len(isnull(@UserName, '')) < 1 begin
--	raiserror('WineVin_GetID:: @UserName is required.', 16, 1)
--	RETURN -1
--end
--exec @CreatorID = Audit_GetLookupID @ObjectName = 'entryuser', @ObjectValue = @UserName

BEGIN TRY
	BEGIN TRANSACTION

	------------ Lookup IDs
	declare @ProducerID int, @TypeID int, @LabelID int, @VarietyID int, @DrynessID int,	@ColorID int
	exec @ProducerID = Wine_GetLookupID @ObjectName='wineproducer', @ObjectValue=@Producer, @IsAutoCreate=@IsAutoCreate
	exec @TypeID = Wine_GetLookupID @ObjectName='winetype', @ObjectValue=@WineType, @IsAutoCreate=@IsAutoCreate
	exec @LabelID = Wine_GetLookupID @ObjectName='winelabel', @ObjectValue=@Label, @IsAutoCreate=@IsAutoCreate
	exec @VarietyID = Wine_GetLookupID @ObjectName='winevariety', @ObjectValue=@Variety, @IsAutoCreate=@IsAutoCreate
	exec @DrynessID = Wine_GetLookupID @ObjectName='winedryness', @ObjectValue=@Dryness, @IsAutoCreate=@IsAutoCreate
	exec @ColorID = Wine_GetLookupID @ObjectName='winecolor', @ObjectValue=@Color, @IsAutoCreate=@IsAutoCreate
		
	declare @locCountryID int, @locRegionID int, @locLocationID int, @locLocaleID int, @locSiteID int
	exec @locCountryID = Location_GetLookupID @ObjectName='locCountry', @ObjectValue=@locCountry, @IsAutoCreate=@IsAutoCreate
	exec @locRegionID = Location_GetLookupID @ObjectName='locRegion', @ObjectValue=@locRegion, @IsAutoCreate=@IsAutoCreate
	exec @locLocationID = Location_GetLookupID @ObjectName='locLocation', @ObjectValue=@locLocation, @IsAutoCreate=@IsAutoCreate
	exec @locLocaleID = Location_GetLookupID @ObjectName='locLocale', @ObjectValue=@locLocale, @IsAutoCreate=@IsAutoCreate
	exec @locSiteID = Location_GetLookupID @ObjectName='locSite', @ObjectValue=@locSite, @IsAutoCreate=@IsAutoCreate
	------------ Lookup IDs

	------------ Checks
--
-- addition 12.06.2014
--
if @IsAutoCreate = 1
begin
	if @ProducerID < 1 or @TypeID < 1 or @LabelID < 0 
	begin
		select @Result = -1
		raiserror('WineVin_GetID:: Cannot find or register a new WineVin: producer, wine type and label are required.', 16, 1)
	end
end
	------------ Checks

	-- this is a unique key therefore only 1 record can be returned
	select @Result = ID from Wine_VinN
	where ProducerID = @ProducerID and TypeID = @TypeID and LabelID = @LabelID 
		and VarietyID = @VarietyID and DrynessID = @DrynessID and ColorID = @ColorID
		and locCountryID = @locCountryID and locRegionID = @locRegionID 
		and locLocationID = @locLocationID and locLocaleID = @locLocaleID and locSiteID = @locSiteID
	if @Result is NULL and @IsAutoCreate = 1 begin
		insert into Wine_VinN (GroupID, 
			ProducerID, TypeID, LabelID, VarietyID, DrynessID, ColorID,
            locCountryID, locRegionID, locLocationID, locLocaleID, locSiteID,
			created, updated, WF_StatusID)
		values (0,
			@ProducerID, @TypeID, @LabelID, @VarietyID, @DrynessID, @ColorID,
            @locCountryID, @locRegionID, @locLocationID, @locLocaleID, @locSiteID,
            getdate(), null, isnull(@WF_StatusID, 0))
		if @@error <> 0 begin
			select @Result = -1
			ROLLBACK TRAN
		end else begin
			select @Result = scope_identity()
			
			
		--	declare @msg nvarchar(1024) = dbo.fn_GetObjectDescription('Wine_VinN', @Result)
		--	exec Audit_Add @Type='Success', @Category='Add', @Source='SQL', @UserName=@UserName, @MachineName='', 
		--		@ObjectType='Wine_VinN', @ObjectID=@Result, @Description='Wine_VinN added', @Message=@msg,
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


