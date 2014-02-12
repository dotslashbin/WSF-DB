-- =============================================
-- Author:		Alex B.
-- Create date: 1/31/2014
-- Description:	Adds new TastingEvent-TasteNote linkage - bulk mode.
--				LeftID = TastingEventID
--				RightID = TasteNoteID
-- =============================================
CREATE PROCEDURE [dbo].[TastingEvent_TasteNote_AddTVP]
	@tvpIDList as dbo.IDLink readonly,

	--@UserName varchar(50),
	@ShowRes smallint = 1

/*
declare @t as dbo.IDLink
insert into @t (LeftID, RightID) 
values (2, 2), (2,3), (2,4)
exec TastingEvent_TasteNote_AddTVP @tvpIDList = @t
*/	

AS
set nocount on
set xact_abort on

declare @Result int, 
		@CreatorID int

------------ Checks
if exists(select * from @tvpIDList t left join TastingEvent te (nolock) on te.ID = t.LeftID
	where te.ID is NULL) begin
	raiserror('TastingEvent_TasteNote_AddTVP:: Not all Tasting Event ids exist.', 16, 1)
	RETURN -1
end

if exists(select * from @tvpIDList t left join TasteNote tn (nolock) on tn.ID = t.RightID
	where tn.ID is NULL) begin
	raiserror('TastingEvent_TasteNote_AddTVP:: Not all Taste Note ids exist.', 16, 1)
	RETURN -1
end
------------ Checks

BEGIN TRY
	BEGIN TRANSACTION

	merge TastingEvent_TasteNote as t
	using (
		select LeftID, RightID from @tvpIDList
	) as s 
		on t.TastingEventID = s.LeftID and t.TasteNoteID = s.RightID
	when not matched by target then
		INSERT (TastingEventID, TasteNoteID, created)
		values (s.LeftID, s.RightID, getdate());
	select @Result = @@rowcount

	-- update default TastingEventID in TastingNote if neccessary
	merge TasteNote as t
	using (
		select LeftID, RightID,
			teStartDate = te.StartDate, teEndDate = isnull(te.EndDate, dateadd(day, 20, te.StartDate)),
			TasteDate = tn.TasteDate
		from @tvpIDList t
			join TastingEvent te (nolock) on t.LeftID = te.ID
			join TasteNote tn (nolock) on t.RightID = tn.ID
		where tn.TasteDate between te.StartDate and isnull(te.EndDate, dateadd(day, 20, te.StartDate))
	) as s 
		on t.ID = s.RightID and t.TastingEventID is NULL
	when matched then
		UPDATE set 
			TastingEventID = s.LeftID,
			updated = getdate()
	;
	

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
    ON OBJECT::[dbo].[TastingEvent_TasteNote_AddTVP] TO [RP_DataAdmin]
    AS [dbo];

