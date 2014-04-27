-- =============================================
-- Author:		Alex B.
-- Create date: 4/17/2014
-- Description:	Adds new Publication.
-- =============================================
CREATE PROCEDURE [dbo].[Publication_Add]
	--@ID int = NULL, 
	@PublisherID int,
	@Name nvarchar(50),
	@ShowRes smallint = 1
	
/*
declare @r int
exec @r = Publication_Add @PublisherID=2, @Name = 'Test Publication'
select @r
*/

AS
set nocount on
set xact_abort on

declare @Result int

------------ Checks
if not exists(select * from Publisher (nolock) where ID = @PublisherID) begin
	raiserror('Publication_Add:: Publisher record with ID=%i does not exist.', 16, 1, @PublisherID)
	RETURN -1
end

if exists(select * from Publication (nolock) where Name = @Name) begin
	raiserror('Publication_Add:: Publication with the same name (%s) already exists.', 16, 1, @Name)
	RETURN -1
end

---------- Checks

BEGIN TRY
	BEGIN TRANSACTION

	insert into Publication (PublisherID, Name,
		created, updated)
	values (@PublisherID, @Name,
		getdate(), null)
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
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Publication_Add] TO [RP_DataAdmin]
    AS [dbo];

