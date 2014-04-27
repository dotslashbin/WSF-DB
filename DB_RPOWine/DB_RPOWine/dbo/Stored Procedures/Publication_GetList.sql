-- =============================================
-- Author:		Alex B.
-- Create date: 4/17/2014
-- Description:	Gets List of Publications.
-- =============================================
CREATE PROCEDURE [dbo].[Publication_GetList]
	@ID int = NULL, 
	@PublisherID int = NULL,
	@ShowRes smallint = 1
	
/*
exec Publication_GetList
*/
	
AS
set nocount on

select 
	ID = pub.ID,
	Name = pub.Name,
	PublisherID = pub.PublisherID,
	PublisherName = p.Name,
	PublisherIsPrimary = p.IsPrimary
from Publication pub (nolock)
	join Publisher p (nolock) on pub.PublisherID = p.ID
where p.ID = isnull(@ID, p.ID)
	and (@PublisherID is NULL or pub.PublisherID = @PublisherID)
order by pub.Name, pub.ID
	
RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Publication_GetList] TO [RP_DataAdmin]
    AS [dbo];

