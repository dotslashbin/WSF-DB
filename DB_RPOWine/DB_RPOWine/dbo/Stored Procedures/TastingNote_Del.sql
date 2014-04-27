


-- =============================================
-- Author:		Sergey Savchenko.
-- Create date: 4/20/2014
-- Description:	Updates TasteNote record.
-- =============================================
CREATE PROCEDURE [dbo].[TastingNote_Del]
	@ID int, 
	@ShowRes smallint = 1
		

AS
set nocount on
set xact_abort on

declare @Result int


BEGIN TRY
	BEGIN TRANSACTION
	
    delete TastingEvent_TasteNote where TasteNoteID = @ID
	delete TasteNote where ID = @ID

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

    if (xact_state() = 1 or xact_state() = -1)
		ROLLBACK TRAN

	raiserror(@errMsg, @errSeverity, 1)
END CATCH

if @ShowRes = 1
	select Result = isnull(@Result, -1)

RETURN isnull(@Result, -1)