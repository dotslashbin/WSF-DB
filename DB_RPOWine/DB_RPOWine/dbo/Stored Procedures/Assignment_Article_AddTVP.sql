-- =============================================
-- Author:		Alex B.
-- Create date: 2/18/2014
-- Description:	Adds new Article to Assignment - bulk mode.
--				LeftID = AssignmentID
--				RightID = ArticleID
-- =============================================
CREATE PROCEDURE [dbo].[Assignment_Article_AddTVP]
	@tvpIDList as dbo.IDLink readonly,
	@ShowRes smallint = 1

/*
declare @t as dbo.IDLink
insert into @t (LeftID, RightID) 
values (2, 2), (2,3), (2,4)
exec Assignment_Article_AddTVP @tvpIDList = @t
*/	

AS
set nocount on
set xact_abort on

declare @Result int

------------ Checks
if exists(select * from @tvpIDList t left join Assignment a (nolock) on a.ID = t.LeftID where a.ID is NULL) begin
	raiserror('Assignment_Article_AddTVP:: Not all Assignment ids exist.', 16, 1)
	RETURN -1
end

if exists(select * from @tvpIDList t left join Article a (nolock) on a.ID = t.RightID where a.ID is NULL) begin
	raiserror('Assignment_Article_AddTVP:: Not all Article ids exist.', 16, 1)
	RETURN -1
end
------------ Checks

BEGIN TRY
	BEGIN TRANSACTION

	merge Assignment_Article as t
	using (
		select LeftID, RightID from @tvpIDList
	) as s 
		on t.AssignmentID = s.LeftID and t.ArticleID = s.RightID
	when not matched by target then
		INSERT (AssignmentID, ArticleID, created)
		values (s.LeftID, s.RightID, getdate());
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

if @ShowRes = 1
	select Result = isnull(@Result, -1)

RETURN isnull(@Result, -1)
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Assignment_Article_AddTVP] TO [RP_DataAdmin]
    AS [dbo];

