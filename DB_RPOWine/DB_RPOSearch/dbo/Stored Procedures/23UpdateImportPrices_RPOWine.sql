-- =============================================
-- Author:		Alex B.
-- Create date: 8/31/2014
-- Description:	Updates prices and other attributes in RPOWine database.
-- =============================================
CREATE PROCEDURE [dbo].[23UpdateImportPrices_RPOWine]

AS
set nocount on;

	exec RPOWine.srv.Wine_UpdatePrices
	exec RPOWine.srv.Wine_UpdateIsActiveWineN
	exec RPOWine.srv.Wine_Reload
	exec RPOWine.srv.Reload_FromSearchDB

RETURN 1