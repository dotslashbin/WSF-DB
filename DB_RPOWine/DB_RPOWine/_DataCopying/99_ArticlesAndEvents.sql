print '----- TastingEvent -----'
GO
BEGIN TRAN
	set identity_insert TastingEvent on
	insert into TastingEvent (ID, ParentID, ReviewerID, Title)
	values (0, 0, 0, 'Root')
	set identity_insert TastingEvent off
COMMIT TRAN
GO
