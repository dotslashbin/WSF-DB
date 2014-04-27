-- =============================================
-- Author:		Alex B.
-- Create date: 4/17/2014
-- Description:	Deletes Publication.
-- =============================================
CREATE PROCEDURE [dbo].[Publication_Del]
	@ID int, 
	@ShowRes smallint = 1

/*
declare @r int
exec @r = Publication_Del @ID=18
select @r
*/

AS
set nocount on
set xact_abort on

declare @Result int

------------ Checks
if not exists(select * from Publication (nolock) where ID = @ID) begin
	raiserror('Publication_Del:: Publication with ID=%i does not exist.', 16, 1, @ID)
	RETURN -1
end
------------ Checks

BEGIN TRY
	BEGIN TRANSACTION

	delete Publication where ID = @ID
	select @Result = @@ROWCOUNT
	if @@error <> 0 begin
		select @Result = -1
		ROLLBACK TRAN
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
    ON OBJECT::[dbo].[Publication_Del] TO [RP_DataAdmin]
    AS [dbo];

