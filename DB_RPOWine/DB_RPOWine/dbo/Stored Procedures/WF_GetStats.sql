-- =============================================
-- Author:		Alex B.
-- Create date: 2/04/2014
-- Description:	Gets basic statistic of the WF assignments.
-- =============================================
CREATE PROCEDURE [dbo].[WF_GetStats]
	@ObjectTypeID int = NULL, @ObjectTypeName varchar(50) = NULL,
	@StatusID smallint = NULL, @StatusName varchar(50) = NULL,
	@AssignedByID int = NULL, @AssignedByLogin varchar(100) = NULL, @AssignedByName varchar(100) = NULL,
	@AssignedToID int = NULL, @AssignedToLogin varchar(100) = NULL, @AssignedToName varchar(100) = NULL

AS
set nocount on

if isnull(@ObjectTypeID, 0) < 1 and @ObjectTypeName is NOT NULL
	select @ObjectTypeID = ID from WF_ObjectTypes (nolock) where Name = @ObjectTypeName
if isnull(@StatusID, 0) < 1 and @StatusName is NOT NULL
	select @StatusID = ID from WF_Statuses (nolock) where Name = @StatusName

if isnull(@AssignedByID, 0) < 1 and @AssignedByLogin is NOT NULL begin
	select @AssignedByID = UserId from Users (nolock) where UserName = lower(rtrim(@AssignedByLogin))
	if @AssignedByID is NULL
		RETURN 0
end

if isnull(@AssignedToID, 0) < 1 and @AssignedToLogin is NOT NULL begin
	select @AssignedToID = UserId from Users (nolock) where UserName = lower(rtrim(@AssignedToLogin))
	if @AssignedToID is NULL
		RETURN 0
end
-----------------------------------------------------------------------

; with r as (
	select ObjectTypeID, StatusID, AssignedByID, AssignedToID, NumberOfObjects = count(*)
	from WF wf (nolock) 
	where (@ObjectTypeID is NULL or wf.ObjectTypeID = @ObjectTypeID)
		and (@StatusID is NULL or wf.StatusID = @StatusID)
		and (@AssignedByID is NULL or wf.AssignedByID = @AssignedByID)
		and (@AssignedToID is NULL or wf.AssignedToID = @AssignedToID)
	group by ObjectTypeID, StatusID, AssignedByID, AssignedToID
)
select
	WF_ObjectTypeID = stat.ObjectTypeID,
	WF_ObjectTypeName = isnull(ot.Name, 'TOTAL'),
	WF_StatusID = stat.StatusID,
	WF_StatusName = case 
		when stat.StatusID = -1 then 'Unassigned' 
		else isnull(s.Name, 'TOTAL') 
	end,
	WF_AssignedToName = case
		when s.Name is NULL and ut.FullName is NULL then ''
		else isnull(ut.FullName, 'TOTAL')
	end,
	WF_AssignedToLogin = isnull(ut.UserName, ''),
	WF_NumberOfObject = NumberOfObjects
from (
	select wf.ObjectTypeID, wf.StatusID, wf.AssignedToID,
		NumberOfObjects = sum(NumberOfObjects)
	from r wf
	group by wf.ObjectTypeID, wf.StatusID, wf.AssignedToID
	with rollup
	) stat
	join WF_ObjectTypes ot on stat.ObjectTypeID = ot.ID
	left join WF_Statuses s (nolock) on stat.StatusID = s.ID	
	left join Users ut (nolock) on stat.AssignedToID = ut.UserId
--order by WF_ObjectTypeName, WF_Status, WF_AssignedByLogin, WF_AssignedToLogin

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[WF_GetStats] TO [RP_DataAdmin]
    AS [dbo];

