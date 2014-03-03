CREATE PROCEDURE srv.ChangeUserID
	@OldUserId int, @NewUserId int
	
AS
set nocount on

update Article set AuthorId = @NewUserId where AuthorId = @OldUserId
update Assignment set AuthorId = @NewUserId where AuthorId = @OldUserId
update Issue set ChiefEditorUserId = @NewUserId where ChiefEditorUserId = @OldUserId
update TasteNote set UserId = @NewUserId where UserId = @OldUserId
update TastingEvent set UserId = @NewUserId where UserId = @OldUserId

RETURN 1