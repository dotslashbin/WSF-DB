

-- =============================================
-- Author:		Alex B.
-- Create date: 1/26/2014
-- Description:	Updates TastingEvent record.
-- =============================================
CREATE PROCEDURE [dbo].[TastingEvent_Update]
	@ID int, 
	@Title nvarchar(255) = NULL, 
	@Location nvarchar(100) = NULL,
	@Notes nvarchar(max) = NULL
	

AS
set nocount on
set xact_abort on

declare @Result int


BEGIN TRY

	update TastingEvent set
		Title = isnull(@Title, Title),
		Location = isnull(@Location, Location),
		Notes = isnull(@Notes, Notes), 
		updated = getdate()
	where ID = @ID

	select @Result = @@ROWCOUNT
	if @@error <> 0 begin
		select @Result = -1
	end

END TRY
BEGIN CATCH
	declare @errSeverity int,
			@errMsg nvarchar(2048)
	select	@errSeverity = ERROR_SEVERITY(),
			@errMsg = ERROR_MESSAGE()


	raiserror(@errMsg, @errSeverity, 1)
END CATCH


RETURN isnull(@Result, -1)
GO


