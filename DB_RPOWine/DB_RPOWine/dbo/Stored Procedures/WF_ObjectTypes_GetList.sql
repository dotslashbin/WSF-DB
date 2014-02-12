-- =============================================
-- Author:		Alex B.
-- Create date: 2/04/2014
-- Description:	Gets List of registered Object Types.
-- =============================================
CREATE PROCEDURE [dbo].[WF_ObjectTypes_GetList]

AS
set nocount on

select	
		ID,
		Name
from WF_ObjectTypes (nolock)
order by Name

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[WF_ObjectTypes_GetList] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[WF_ObjectTypes_GetList] TO PUBLIC
    AS [dbo];

