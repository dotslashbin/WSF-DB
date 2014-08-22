IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TasteNote_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[TasteNote]'))
ALTER TABLE [dbo].[TasteNote] DROP CONSTRAINT [FK_TasteNote_Users]
GO
----------------------------------------------
select distinct 'update Article set AuthorId=' + cast(u.UserIdProd as varchar(20)) + ' where AuthorId=' + cast(u.UserId as varchar(20))
from Article a join Users u on a.AuthorId = u.UserId
where u.UserId != u.UserIdProd

select distinct 'update Assignment set AuthorId=' + cast(u.UserIdProd as varchar(20)) + ' where AuthorId=' + cast(u.UserId as varchar(20))
from Assignment a join Users u on a.AuthorId = u.UserId
where u.UserId != u.UserIdProd

select distinct 'update Assignment_Resource set UserId=' + cast(u.UserIdProd as varchar(20)) + ' where UserId=' + cast(u.UserId as varchar(20))
from Assignment_Resource a join Users u on a.UserId = u.UserId
where u.UserId != u.UserIdProd

--select distinct 'update Issue set ChiefEditorUserId=' + cast(u.UserIdProd as varchar(20)) + ' where ChiefEditorUserId=' + cast(u.UserId as varchar(20))
--from Issue a join Users u on a.ChiefEditorUserId = u.UserId
--where u.UserId != u.UserIdProd

select distinct 'update TasteNote set UserId=' + cast(u.UserIdProd as varchar(20)) + ' where UserId=' + cast(u.UserId as varchar(20))
from TasteNote a join Users u on a.UserId = u.UserId
where u.UserId != u.UserIdProd
----------------------------------------------

select distinct 'update Users set UserId=' + cast(u.UserIdProd as varchar(20)) + ' where UserId=' + cast(u.UserId as varchar(20))
from Users u
where u.UserId != u.UserIdProd

----------------------------------------------
set identity_insert Users on
--- Update Users scripts ---
set identity_insert Users off
----------------------------------------------

ALTER TABLE [dbo].[TasteNote]  WITH CHECK ADD  CONSTRAINT [FK_TasteNote_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[TasteNote] CHECK CONSTRAINT [FK_TasteNote_Users]
GO

exec [srv].[Wine_Reload] @IsFullReload = 1

print 'Done.'
GO