﻿-- =============================================
-- Author:		Alex B.
-- Create date: 2/17/2014
-- Description:	Gets List of Assignments.
--				Input parameters are used as a filter.
-- =============================================
CREATE PROCEDURE [dbo].[Assignment_GetList]
	@ID int = NULL, 
	@AuthorId int = NULL,
	@Title nvarchar(255) = NULL,

	@WF_StatusID smallint = NULL,
	
	--@StartRow int = NULL, @EndRow int = NULL,
	--@SortBy varchar(20) = NULL, @SortOrder varchar(3) = NULL
	@ShowRes smallint = 1
	
/*
exec Assignment_GetList @Title = 'test', @WF_StatusID = 100
*/
	
AS
set nocount on

if @ID is not null begin
	select 
		ID = a.ID,
		AuthorId = a.AuthorId,
		AuthorName = isnull(u.FullName, ''),
		Title = a.Title,
		Deadline = a.Deadline,
		Notes = a.Notes,
		created = a.created, 
		updated = a.updated,
		
		WF_StatusID = isnull(wfs.ID, -1),
		WF_StatusName = isnull(wfs.Name, '')
	from Assignment a (nolock)
		left join Users u (nolock) on a.AuthorId = u.UserId
		left join WF_Statuses wfs (nolock) on a.WF_StatusID = wfs.ID
	where a.ID = @ID
end else begin
	if @Title is NOT NULL 
			select @Title = '%' + @Title + '%'
		
	select 
		ID = a.ID,
		AuthorId = a.AuthorId,
		AuthorName = isnull(u.FullName, ''),
		Title = a.Title,
		Deadline = a.Deadline,
		Notes = a.Notes,
		created = a.created, 
		updated = a.updated,
		
		WF_StatusID = isnull(wfs.ID, -1),
		WF_StatusName = isnull(wfs.Name, '')
	from Assignment a (nolock)
		left join Users u (nolock) on a.AuthorId = u.UserId
		left join WF_Statuses wfs (nolock) on a.WF_StatusID = wfs.ID
	where a.AuthorId = isnull(@AuthorId, a.AuthorId)
		and (@Title is NULL or a.Title like @Title)
		and a.WF_StatusID = isnull(@WF_StatusID, a.WF_StatusID)
	order by Deadline desc, a.ID
end
	
RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Assignment_GetList] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Assignment_GetList] TO [RP_Customer]
    AS [dbo];
