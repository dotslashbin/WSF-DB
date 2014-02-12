-- =============================================
-- Author:		Alex B.
-- Create date: 2/04/2014
-- Description:	Gets list of WF changes associated with a particular object instance.
-- =============================================
CREATE PROCEDURE [dbo].[WF_GetHist]
	@ObjectTypeID int = NULL, @ObjectTypeName varchar(50) = NULL,
	@ObjectID int,
	@IsLastStateOnly bit = 0
	
AS
set nocount on

if isnull(@ObjectTypeID, 0) < 1 and @ObjectTypeName is NOT NULL
	select @ObjectTypeID = ID from WF_ObjectTypes (nolock) where Name = @ObjectTypeName
if isnull(@ObjectTypeID, 0) < 1 begin
	raiserror('ObjectTypeID cannot be found.', 16, 1)
	RETURN -1
end	

if @IsLastStateOnly = 1 begin
	select 
		WF_ObjectTypeID = h.ObjectTypeID,
		WF_ObjectID = h.ObjectID,
		WF_AssignedDate = h.AssignedDate,
		WF_StatusID = s.ID,
		WF_StatusName = s.Name,
		WF_AssignedByName = ab.FullName,
		WF_AssignedByLogin = ab.UserName,
		WF_AssignedToName = at.FullName,
		WF_AssignedToLogin = at.UserName,
		WF_Note = h.Note
	from WF h (nolock)
		join WF_Statuses s (nolock) on h.StatusID = s.ID
		join Users ab (nolock) on h.AssignedByID = ab.UserId
		join Users at (nolock) on h.AssignedToID = at.UserId
	where h.ObjectTypeID = @ObjectTypeID and h.ObjectID = @ObjectID
end else begin
	select 
		WF_ObjectTypeID = h.ObjectTypeID,
		WF_ObjectID = h.ObjectID,
		WF_AssignedDate = h.AssignedDate,
		WF_StatusID = s.ID,
		WF_StatusName = s.Name,
		WF_AssignedByName = ab.FullName,
		WF_AssignedByLogin = ab.UserName,
		WF_AssignedToName = at.FullName,
		WF_AssignedToLogin = at.UserName,
		WF_Note = h.Note
	from WF h (nolock)
		join WF_Statuses s (nolock) on h.StatusID = s.ID
		join Users ab (nolock) on h.AssignedByID = ab.UserId
		join Users at (nolock) on h.AssignedToID = at.UserId
	where h.ObjectTypeID = @ObjectTypeID and h.ObjectID = @ObjectID
	UNION ALL
	select 
		WF_ObjectTypeID = h.ObjectTypeID,
		WF_ObjectID = h.ObjectID,
		WF_AssignedDate = h.AssignedDate,
		WF_StatusID = s.ID,
		WF_StatusName = s.Name,
		WF_AssignedByName = ab.FullName,
		WF_AssignedByLogin = ab.UserName,
		WF_AssignedToName = at.FullName,
		WF_AssignedToLogin = at.UserName,
		WF_Note = h.Note
	from WFHist h (nolock)
		join WF_Statuses s (nolock) on h.StatusID = s.ID
		join Users ab (nolock) on h.AssignedByID = ab.UserId
		join Users at (nolock) on h.AssignedToID = at.UserId
	where h.ObjectTypeID = @ObjectTypeID and h.ObjectID = @ObjectID
	order by h.AssignedDate desc
end

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[WF_GetHist] TO [RP_DataAdmin]
    AS [dbo];

