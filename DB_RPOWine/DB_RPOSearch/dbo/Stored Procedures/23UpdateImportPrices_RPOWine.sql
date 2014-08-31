-- =============================================
-- Author:		Alex B.
-- Create date: 8/31/2014
-- Description:	Updates prices and other attributes in RPOWine database.
-- =============================================
CREATE PROCEDURE [23UpdateImportPrices_RPOWine]

AS
set nocount on;

	exec RPOWine.srv.Wine_UpdatePrices
	exec RPOWine.srv.Wine_UpdateIsActiveWineN
	exec RPOWine.srv.Wine_Reload

RETURN 1