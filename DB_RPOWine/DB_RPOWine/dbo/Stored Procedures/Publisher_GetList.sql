-- =============================================
-- Author:		Alex B.
-- Create date: 4/17/2014
-- Description:	Gets List of Publishers.
-- =============================================
CREATE PROCEDURE [dbo].[Publisher_GetList]
	@ID int = NULL, 
	@ShowRes smallint = 1
	
/*
exec Publisher_GetList
*/
	
AS
set nocount on

select 
	ID = p.ID,
	Name = p.Name,
	IsPrimary = p.IsPrimary
from Publisher p (nolock)
where p.ID = isnull(@ID, p.ID)
order by p.IsPrimary, Name
	
RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Publisher_GetList] TO [RP_DataAdmin]
    AS [dbo];

