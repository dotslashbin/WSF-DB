-- =============================================
-- Author:		Alex B.
-- Create date: 1/28/2014
-- Description:	Updates TasteNote record.
-- =============================================
CREATE PROCEDURE [dbo].[TasteNote_Update]
	@ID int, 
	@OriginID int = NULL, -- used to point to the "edited" note...
	@UserId int = NULL,
	@Wine_N_ID int = NULL,
	
	@TasteDate date = NULL,
	@MaturityID smallint = NULL, 
	@Rating_Lo smallint = NULL, @Rating_Hi smallint = NULL,
	@DrinkDate_Lo date = NULL, @DrinkDate_Hi date = NULL,
	@IsBarrelTasting bit = NULL,

	@Places nvarchar(150) = null,
	@Notes nvarchar(max) = NULL,
	--@PublicationDate date = NULL,
	
	@WF_StatusID smallint = NULL,
	--@UserName varchar(50),
	@ShowRes smallint = 1
		
/*
select top 20 * from TasteNote order by ID desc
declare @r int
exec @r = TasteNote_Update @ID = 278791, @OriginID=NULL, @UserId=2, @Wine_N_ID=6151,
	@TasteDate = '2/1/2013', @MaturityID = 2,
	@Rating_Lo = 88, @Rating_Hi = 94, @Notes = 'First in my list... and a simple update.',
	@WF_StatusID = NULL
select @r

exec TasteNote_Update @ID = 254321, @WF_StatusID = 100
*/	

AS
set nocount on
set xact_abort on

declare @Result int, 
		@EditorID int,
		@prevWF_StatusID smallint,
		@prevOriginID int

select @UserId = nullif(@UserId, 0)

------------ Checks
select @prevWF_StatusID = WF_StatusID, @prevOriginID = OriginID from TasteNote (nolock) where ID = @ID
if @prevWF_StatusID is NULL begin
	raiserror('TasteNote_Update:: Taste Note record with ID=%i does not exist.', 16, 1, @ID)
	RETURN -1
end

if isnull(@OriginID, 0) > 0 and not exists(select * from TasteNote (nolock) where ID = @OriginID) begin
	raiserror('TastingEvent_Update:: Origin record with ID=%i does not exist.', 16, 1, @OriginID)
	RETURN -1
end

--if @UserId is NOT NULL begin
--	select @UserId = UserId from Users (nolock) where UserId = @UserId
--	if @UserId is NULL begin
--		raiserror('TastingEvent_Update:: User record does not exist.', 16, 1)
--		RETURN -1
--	end
--end

if @Wine_N_ID is NOT NULL and not exists(select * from Wine_N (nolock) where ID = @Wine_N_ID) begin
	raiserror('TastingEvent_Update:: Wine_N record with ID=%i does not exist.', 16, 1, @Wine_N_ID)
	RETURN -1
end

if @MaturityID is NOT NULL and not exists(select * from WineMaturity (nolock) where ID = @MaturityID) begin
	raiserror('TastingEvent_Update:: WineMaturity record with ID=%i does not exist.', 16, 1, @MaturityID)
	RETURN -1
end

------------ Lookup IDs
declare @locPlacesID int
exec @locPlacesID = Location_GetLookupID @ObjectName='locPlaces', @ObjectValue=@Places, @IsAutoCreate=1

------------- Audit
--if len(isnull(@UserName, '')) < 1 begin
--	raiserror('TastingEvent_Update:: @UserName is required.', 16, 1)
--	RETURN -1
--end
--exec @EditorID = Audit_GetLookupID @ObjectName = 'entryuser', @ObjectValue = @UserName
------------ Checks

BEGIN TRY
	BEGIN TRANSACTION
	
	-- if current and new WF status if "published" - silent update
	-- make a copy of the note IF current status is "published" and new status is not "published"
	if @prevWF_StatusID >= 100 and isnull(@WF_StatusID, 0) < 100 begin
		set @WF_StatusID = isnull(@WF_StatusID, 0)
		insert into TasteNote (OriginID, UserId, Wine_N_ID, TasteDate, MaturityID, 
			Rating_Lo, Rating_Hi, DrinkDate_Lo, DrinkDate_Hi, IsBarrelTasting, 
			locPlacesID, Notes,
			created, updated, WF_StatusID)
		select OriginID=@ID, UserId, Wine_N_ID, TasteDate, MaturityID, 
			Rating_Lo, Rating_Hi, DrinkDate_Lo, DrinkDate_Hi, IsBarrelTasting, 
			locPlacesID, Notes,
			created, getdate(), @WF_StatusID
		from TasteNote 
		where ID = @ID
		select @ID = scope_identity()
	end else if @prevWF_StatusID < 100 and isnull(@WF_StatusID, 0) >= 100 and isnull(@prevOriginID, 0) > 0 begin
		-- update "origin" record to status = -100 -- archived.
		update TasteNote set 
			updated = getdate(), 
			WF_StatusID = -100
		where ID = @prevOriginID
	end

	update TasteNote set 
		OriginID = isnull(@OriginID, OriginID), 
		UserId = isnull(@UserId, UserId), 
		Wine_N_ID = isnull(@Wine_N_ID, Wine_N_ID), 
		TasteDate = isnull(@TasteDate, TasteDate), 
		MaturityID = isnull(@MaturityID, MaturityID), 
		Rating_Lo = isnull(@Rating_Lo, Rating_Lo), 
		Rating_Hi = isnull(@Rating_Hi, Rating_Hi), 
		DrinkDate_Lo = isnull(DrinkDate_Lo, DrinkDate_Lo), 
		DrinkDate_Hi = isnull(@DrinkDate_Hi, DrinkDate_Hi), 
		IsBarrelTasting = isnull(@IsBarrelTasting, IsBarrelTasting), 
		locPlacesID = isnull(@locPlacesID, locPlacesID),
		Notes = isnull(@Notes, Notes), 
		updated = getdate(), 
		WF_StatusID = isnull(@WF_StatusID, WF_StatusID)
		--EditorID = @EditorID
	where ID = @ID

	select @Result = @@ROWCOUNT
	if @@error <> 0 begin
		select @Result = -1
		ROLLBACK TRAN
	--end else begin
	--	declare @msg nvarchar(1024) = dbo.fn_GetObjectDescription('TasteNote', @ID)
	--	exec Audit_Add @Type='Success', @Category='Update', @Source='SQL', @UserName=@UserName, @MachineName='', 
	--		@ObjectType='TasteNote', @ObjectID=@ID, @Description='TasteNote updated', @Message=@msg,
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

if @ShowRes = 1
	select Result = isnull(@Result, -1)

RETURN isnull(@Result, -1)
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[TasteNote_Update] TO [RP_DataAdmin]
    AS [dbo];

