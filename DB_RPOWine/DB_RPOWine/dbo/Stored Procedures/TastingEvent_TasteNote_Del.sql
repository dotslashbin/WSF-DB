
-- =============================================
-- Author:		Alex B.
-- Create date: 1/26/2014
-- Description:	Deletes TastingEvent-TasteNote linkage.
-- =============================================
CREATE PROCEDURE [dbo].[TastingEvent_TasteNote_Del]
	@TastingEventID int, @TasteNoteID int,

	--@UserName varchar(50),
	@ShowRes smallint = 1

/*
declare @r int
exec @r = TastingEvent_TasteNote_Del @TastingEventID=1, @TasteNote=2	--, @UserName = 'test'
select @r
*/

AS
set nocount on
set xact_abort on

declare @Result int

------------ Checks
if not exists(select * from TastingEvent (nolock) where ID = @TastingEventID) begin
	raiserror('TastingEvent_TasteNote_Del:: Tasting Event record with ID=%i does not exist.', 16, 1, @TastingEventID)
	RETURN -1
end

if not exists(select * from TasteNote (nolock) where ID = @TasteNoteID) begin
	raiserror('TastingEvent_TasteNote_Del:: Taste Note record with ID=%i does not exist.', 16, 1, @TasteNoteID)
	RETURN -1
end

------------ Audit Log
--if len(isnull(@UserName, '')) < 1 begin
--	raiserror('TastingEvent_Del:: @UserName is required.', 16, 1)
--	RETURN -1
--end
----exec @EditorID = Audit_GetLookupID @ObjectName = 'entryuser', @ObjectValue = @UserName
------------ Checks

BEGIN TRY
	BEGIN TRANSACTION

	--declare @msg nvarchar(1024) = dbo.fn_GetObjectDescription('WineProducer', @ID)
	
	delete TastingEvent_TasteNote where TastingEventID = @TastingEventID and TasteNoteID = @TasteNoteID
	select @Result = @@ROWCOUNT
	if @@error <> 0 begin
		select @Result = -1
		ROLLBACK TRAN
	end else begin
		-- remove default Tasting Event if necessary
		update TasteNote set TastingEventID = NULL
		where ID = @TasteNoteID and TastingEventID = @TastingEventID
	
	--	exec Audit_Add @Type='Success', @Category='Delete', @Source='SQL', @UserName=@UserName, @MachineName='', 
	--		@ObjectType='WineProducer', @ObjectID=@ID, @Description='WineProducer deleted', @Message=@msg,
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
    ON OBJECT::[dbo].[TastingEvent_TasteNote_Del] TO [RP_DataAdmin]
    AS [dbo];

