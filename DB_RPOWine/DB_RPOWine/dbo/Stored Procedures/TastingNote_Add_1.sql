﻿-- =============================================
-- Author:		Alex B.
-- Create date: 1/28/2014
-- Description:	Adds new Taste Note.

-- Updte date: 10/2/2014 Sergey
-- Description:	Add @RaqtinQ  to list of parameters. Use in insert statement
-- =============================================
CREATE PROCEDURE [dbo].[TastingNote_Add]
	--@ID int = NULL, 
	@OriginID int = NULL, -- used to point to the "edited" note...
	@UserId int, @IssueID int,
	@Wine_N_ID int,
	
	@TasteDate date,
	@MaturityID smallint, 
	@Rating_Lo smallint, @Rating_Hi smallint = NULL,
	@DrinkDate_Lo date = NULL, @DrinkDate_Hi date = NULL,
	@EstimatedCost money = NULL, @EstimatedCost_Hi money = NULL,

	@IsBarrelTasting bit = 0,
	@RatingQ varchar(2) = null,

	@Places nvarchar(150) = null,
	@Notes nvarchar(max),
	@BottleSizeID int = NULL,
	
	@WF_StatusID smallint = NULL,
	@ShowRes smallint = 1
	
/*
select top 20 * from TasteNote order by ID desc
declare @r int
exec @r = TasteNote_Add @OriginID=0, @UserId=2, @IssueID=101, @Wine_N_ID=6151,
	@TasteDate = '2/1/2013', @MaturityID = 1,
	@Rating_Lo = 87, @Rating_Hi = 89, @DrinkDate_Lo='5/1/2015',
	@Notes = 'First in my list...',
	@WF_StatusID = NULL
select @r
*/

AS
set nocount on
set xact_abort on

declare @Result int, 
		@CreatorID int

select @OriginID = isnull(@OriginID, 0), @UserId = nullif(@UserId, 0)

------------ Checks
if @OriginID > 0 and not exists(select * from TasteNote (nolock) where ID = @OriginID) begin
	raiserror('TasteNote_Add:: Origin record with ID=%i does not exist.', 16, 1, @OriginID)
	RETURN -1
end

exec [dbo].[User_Add] @UserId = @UserId
if @UserId is NULL or not exists(select * from Users (nolock) where UserId = @UserId) begin
	raiserror('TasteNote_Add:: @UserId is required.', 16, 1)
	RETURN -2
end

if not exists(select * from Issue (nolock) where ID = @IssueID) begin
	raiserror('TasteNote_Add:: Issue record with ID=%i does not exist.', 16, 1, @IssueID)
	RETURN -1
end

if not exists(select * from Wine_N (nolock) where ID = @Wine_N_ID) begin
	raiserror('TasteNote_Add:: Wine_N record with ID=%i does not exist.', 16, 1, @Wine_N_ID)
	RETURN -1
end

if not exists(select * from WineMaturity (nolock) where ID = @MaturityID) begin
	raiserror('TasteNote_Add:: WineMaturity record with ID=%i does not exist.', 16, 1, @MaturityID)
	RETURN -1
end

------------ Lookup IDs
declare @locPlacesID int
exec @locPlacesID = Location_GetLookupID @ObjectName='locPlaces', @ObjectValue=@Places, @IsAutoCreate=1
------------ Checks

BEGIN TRY

	BEGIN TRANSACTION

	insert into TasteNote (OriginID, UserId, IssueID, Wine_N_ID, TasteDate, MaturityID, 
		Rating_Lo, Rating_Hi, DrinkDate_Lo, DrinkDate_Hi, IsBarrelTasting,RatingQ,
		EstimatedCost,EstimatedCost_Hi, 
		locPlacesID, Notes, BottleSizeID,
		created, updated, WF_StatusID)
		
	values (@OriginID, @UserId, @IssueID, @Wine_N_ID, @TasteDate, @MaturityID, 
		@Rating_Lo, @Rating_Hi, @DrinkDate_Lo, @DrinkDate_Hi, @IsBarrelTasting,@RatingQ, 
	    @EstimatedCost, @EstimatedCost_Hi,
		@locPlacesID, @Notes, isnull(@BottleSizeID, 0),
		getdate(), null, isnull(@WF_StatusID, 0))
		
	if @@error <> 0 begin
		select @Result = -1
		ROLLBACK TRAN
	end else begin
		select @Result = scope_identity()
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