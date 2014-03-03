-- =============================================
-- Author:		Alex B.
-- Create date: 2/22/2014
-- Description:	Adds a new ResourceD to the Assignment or updates deadline.
-- =============================================
CREATE PROCEDURE [dbo].[Assignment_ResourceD_AddUpdateTVP]
	@AssignmentID int, 
	@tvpResourceList as dbo.AssignmentResourceD readonly,
	@ShowRes smallint = 1

/*
set nocount on
declare @t as dbo.AssignmentResourceD
insert into @t (TypeID, Deadline) 
values (2, '2/21/2014'), (3, '3/5/2014')
exec Assignment_ResourceD_AddUpdateTVP @AssignmentID=2, @tvpResourceList = @t
*/	

AS
set nocount on
set xact_abort on

declare @Result int 

------------ Checks
select @Result = ID from Assignment (nolock) where ID = @AssignmentID
if @Result is NULL begin
	raiserror('Assignment_ResourceD_AddUpdateTVP:: Assignment record with ID=%i does not exist.', 16, 1, @AssignmentID)
	RETURN -1
end
------------ Checks

BEGIN TRY
	BEGIN TRANSACTION

	merge Assignment_ResourceD as t
	using (
		select TypeID, Deadline
		from @tvpResourceList
	) as s 
		on t.TypeID = s.TypeID and t.AssignmentID = @AssignmentID
	when matched then
		UPDATE set 
			Deadline = isnull(s.Deadline, t.Deadline),
			updated = getdate()
	when not matched by target then
		INSERT (AssignmentID, TypeID, Deadline, created)
		values (@AssignmentID, s.TypeID, s.Deadline, getdate());
	select @Result = @@rowcount
	
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
    ON OBJECT::[dbo].[Assignment_ResourceD_AddUpdateTVP] TO [RP_DataAdmin]
    AS [dbo];

