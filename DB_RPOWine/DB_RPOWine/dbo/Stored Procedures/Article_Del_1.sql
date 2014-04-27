-- =============================================
-- Author:		Alex B.
-- Create date: 4/1/2014
-- Description:	Deletes Article and all associated with it records.
-- =============================================
CREATE PROCEDURE [dbo].[Article_Del]
	@ID int, 

	--@UserName varchar(50),
	@ShowRes smallint = 1

/*
declare @r int
exec @r = Article_Del @ID=4796	--, @UserName = 'test'
select @r
*/

AS
set nocount on
set xact_abort on

declare @Result int

------------ Checks
if not exists(select * from Article (nolock) where ID = @ID) begin
	raiserror('Article_Del:: Article record with ID=%i does not exist.', 16, 1, @ID)
	RETURN -1
end
------------ Checks

BEGIN TRY
	BEGIN TRANSACTION

	delete Article_TasteNote where ArticleID = @ID
	delete Assignment_Article where ArticleID = @ID
	delete Issue_Article where ArticleID = @ID
	delete TastingEvent_Article where ArticleID = @ID
	delete Article where ID = @ID
	
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
    ON OBJECT::[dbo].[Article_Del] TO [RP_DataAdmin]
    AS [dbo];

