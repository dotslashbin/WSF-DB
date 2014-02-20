-- =============================================
-- Author:		Alex B.
-- Create date: 2/18/2014
-- Description:	Deletes Article from Assignment.
-- =============================================
CREATE PROCEDURE [dbo].[Assignment_Article_Del]
	@AssignmentID int, @ArticleID int,
	@ShowRes smallint = 1

/*
declare @r int
exec @r = Assignment_Article_Del @AssignmentID=1, @ArticleID=2
select @r
*/

AS
set nocount on
set xact_abort on

declare @Result int

BEGIN TRY
	BEGIN TRANSACTION

	delete Assignment_Article where AssignmentID = @AssignmentID and ArticleID = @ArticleID
	select @Result = @@ROWCOUNT

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
    ON OBJECT::[dbo].[Assignment_Article_Del] TO [RP_DataAdmin]
    AS [dbo];

