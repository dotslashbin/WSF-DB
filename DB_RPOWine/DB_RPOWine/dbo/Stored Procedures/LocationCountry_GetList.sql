-- =============================================
-- Author:		Alex B.
-- Create date: 2/16/2014
-- Description:	Gets list of all registered countries.
-- =============================================
CREATE PROCEDURE LocationCountry_GetList

AS
set nocount on;

select ID, Name
from LocationCountry (nolock)
where ID > 0
order by Name

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[LocationCountry_GetList] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[LocationCountry_GetList] TO [RP_Customer]
    AS [dbo];

