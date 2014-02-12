CREATE PROCEDURE [dbo].[WF_Statuses_GetList]
	@ShowRes smallint = 1

AS
set nocount on

select	
		ID,
		Name
from WF_Statuses (nolock)
order by SortOrder, ID, Name

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[WF_Statuses_GetList] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[WF_Statuses_GetList] TO PUBLIC
    AS [dbo];

