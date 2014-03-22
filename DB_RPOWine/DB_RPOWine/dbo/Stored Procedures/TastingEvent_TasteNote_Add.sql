

-- =============================================
-- Author:		Alex B.
-- Create date: 1/26/2014
-- Description:	Adds new TastingEvent-TasteNote linkage.
-- =============================================
CREATE PROCEDURE [dbo].[TastingEvent_TasteNote_Add]
	@TastingEventID int, @TasteNote int,

	--@UserName varchar(50),
	@ShowRes smallint = 1

/*
exec TastingEvent_TasteNote_Add	@TastingEventID=2, @TasteNote=15
*/	

AS
set nocount on
set xact_abort on

declare @Result int, 
		@CreatorID int


------------ Checks
select @Result = ID 
from TastingEvent (nolock) where ID = @TastingEventID
if @Result is NULL begin
	raiserror('TastingEvent_TasteNote_Add:: Tasting Event record with ID=%i does not exist.', 16, 1, @TastingEventID)
	RETURN -1
end

if not exists(select * from TasteNote (nolock) where ID = @TasteNote) begin
	raiserror('TastingEvent_TasteNote_Add:: Taste Note record with ID=%i does not exist.', 16, 1, @TasteNote)
	RETURN -1
end

if exists(select * from TastingEvent_TasteNote (nolock) where TastingEventID = @TastingEventID and TasteNoteID = @TasteNote) begin
	-- do nothing - linkage already exists
	if @ShowRes = 1
		select Result = 1
	RETURN 1
end

------------- Audit
--if len(isnull(@UserName, '')) < 1 begin
--	raiserror('TastingEvent_Add:: @UserName is required.', 16, 1)
--	RETURN -1
--end
--exec @CreatorID = Audit_GetLookupID @ObjectName = 'entryuser', @ObjectValue = @UserName
------------ Checks

BEGIN TRY
	BEGIN TRANSACTION

	insert into TastingEvent_TasteNote (TastingEventID, TasteNoteID,created)
	values (@TastingEventID, @TasteNote,getdate())
	
	if @@error <> 0 begin
		select @Result = -1
		ROLLBACK TRAN
	end else begin
		select @Result = 1
		
		update TasteNote set TastingEventID = @TastingEventID
		where ID = @TasteNote and TastingEventID is NULL
		
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


