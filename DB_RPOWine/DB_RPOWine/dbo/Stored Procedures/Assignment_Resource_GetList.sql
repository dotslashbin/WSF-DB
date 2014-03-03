-- =============================================
-- Author:		Alex B.
-- Create date: 2/18/2014
-- Description:	Gets Resources assigned to the Assignment.
-- =============================================
CREATE PROCEDURE [dbo].[Assignment_Resource_GetList]
	@AssignmentID int,
	@ShowRes smallint = 1

/*
exec Assignment_Resource_GetList 2
*/	

AS
set nocount on
set xact_abort on

declare @Result int 

------------ Checks
select @Result = ID from Assignment (nolock) where ID = @AssignmentID
if @Result is NULL begin
	raiserror('Assignment_Resource_GetList:: Assignment record with ID=%i does not exist.', 16, 1, @AssignmentID)
	RETURN -1
end
------------ Checks

select 
	AssignmentID = ar.AssignmentID,
	UserId = ar.UserId,
	UserName = isnull(u.FullName, ''),
	UserRoleID = isnull(ar.UserRoleID, 0),
	UserRoleName = isnull(ur.Name, '')
from Assignment_Resource ar (nolock)
	left join UserRoles ur (nolock) on ar.UserRoleID = ur.ID
	left join Users u (nolock) on ar.UserId = u.UserId
where ar.AssignmentID = @AssignmentID

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Assignment_Resource_GetList] TO [RP_DataAdmin]
    AS [dbo];

