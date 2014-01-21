-- =============================================
-- Author:		Alex B
-- Create date: 1/19/2014
-- Description:	Gets list of all Vintages available for a specified VinID
-- =============================================
CREATE PROCEDURE Wine_GetList_ByVinID
	@Wine_VinN_ID int

AS
set nocount on

select 
	Wine_N_ID = w.ID,
	Wine_VinN_ID = w.Wine_VinN_ID,
	VintageID = w.VintageID,
	Vintage = wv.Name,
	Wine_V_WF_StatusID = w.WF_StatusID
from Wine_N w (nolock)
	join WineVintage wv (nolock) on w.VintageID = wv.ID
where w.Wine_VinN_ID = @Wine_VinN_ID
order by Vintage

RETURN 1
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Wine_GetList_ByVinID] TO [RP_DataAdmin]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Wine_GetList_ByVinID] TO [RP_Customer]
    AS [dbo];

