
-- =============================================
-- Author:		Alex B.
-- Create date: 3/2/2014
-- Description:	Gets Resources (deadlines) assigned to the Assignment.
-- =============================================
CREATE PROCEDURE [dbo].[Assignment_ResourceD_GetList]
	@AssignmentID int,
	@ShowRes smallint = 1

/*
exec Assignment_ResourceD_GetList 2
*/	

AS
set nocount on
set xact_abort on

declare @Result int 

------------ Checks
select @Result = ID from Assignment (nolock) where ID = @AssignmentID
if @Result is NULL begin
	raiserror('Assignment_ResourceD_GetList:: Assignment record with ID=%i does not exist.', 16, 1, @AssignmentID)
	RETURN -1
end
------------ Checks

select 
	AssignmentID = ar.AssignmentID,
	TypeID = ar.TypeID,
	Deadline = ar.Deadline
from Assignment_ResourceD ar (nolock)
where ar.AssignmentID = @AssignmentID

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Assignment_ResourceD_GetList] TO [RP_DataAdmin]
    AS [dbo];

