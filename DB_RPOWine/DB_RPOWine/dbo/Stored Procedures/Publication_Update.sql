-- =============================================
-- Author:		Alex B.
-- Create date: 4/17/2014
-- Description:	Updates Publication.
-- =============================================
CREATE PROCEDURE [dbo].[Publication_Update]
	@ID int = NULL, 
	@PublisherID int = NULL,
	@Name nvarchar(50) = NULL,
	@ShowRes smallint = 1
	
/*
declare @r int
exec @r = Publication_Update @ID=18, @PublisherID=2, @Name = 'Test Publication 2'
select @r
*/

AS
set nocount on
set xact_abort on

declare @Result int

------------ Checks
if @PublisherID is NOT NULL and not exists(select * from Publisher (nolock) where ID = @PublisherID) begin
	raiserror('Publication_Update:: Publisher record with ID=%i does not exist.', 16, 1, @PublisherID)
	RETURN -1
end

if not exists(select * from Publication (nolock) where ID = @ID) begin
	raiserror('Publication_Update:: Publication with ID=%i does not exist.', 16, 1, @ID)
	RETURN -1
end

if exists(select * from Publication (nolock) where Name = @Name and ID != @ID) begin
	raiserror('Publication_Update:: Publication with the same name (%s) already exists.', 16, 1, @Name)
	RETURN -1
end
---------- Checks

BEGIN TRY
	--BEGIN TRANSACTION

	update Publication set 
		PublisherID = isnull(@PublisherID, PublisherID), 
		Name = isnull(@Name, Name),
		updated = getdate()
	where ID = @ID
	
	select @Result = @@ROWCOUNT
	if @@error <> 0
		select @Result = -1
	
	--COMMIT TRANSACTION
	
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
    ON OBJECT::[dbo].[Publication_Update] TO [RP_DataAdmin]
    AS [dbo];

