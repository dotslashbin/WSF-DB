
-- =============================================
-- Author:		Alex B.
-- Create date: 1/26/2014
-- Description:	Adds new Tastin Event.
-- =============================================
CREATE PROCEDURE [dbo].[TastingEvent_Add]
	@Title nvarchar(255), 
	@Location nvarchar(100) = NULL,
	@Notes nvarchar(max) = NULL
	

AS
set nocount on
set xact_abort on

declare @Result int


BEGIN TRY

	insert into TastingEvent (Title, Location, Notes, created, updated)
	values (@Title,  @Location,@Notes,getdate(), null)
	if @@error <> 0 begin
		select @Result = -1
		ROLLBACK TRAN
	end else begin
		select @Result = scope_identity()
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


