
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteAllJulian] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

Begin Try
alter fullText Index on RPOSearch.dbo.forSaleDetail disable;
alter fullText Index on RPOSearch.dbo.wine disable;
alter fullText Index on RPOSearch.dbo.wineName disable;
alter fullText Index on rpoWineDataD.dbo.wine disable;
End Try
Begin Catch
End Catch

--Should be deleted whenever we rerun this script
delete from RPOSearch.dbo.forSale
delete from RPOSearch.dbo.wine
delete from RPOSearch.dbo.wineName

update RPOSearch.dbo.forSaleDetail set errors = null, warnings = null where warnings is not null or errors is not null;
update RPOSearch.dbo.forSale set errors = null, warnings = null where warnings is not null or errors is not null;
update RPOSearch.dbo.WAName set errors = null, warnings = null where warnings is not null or errors is not null;
update RPOSearch.dbo.Retailers set errors = null, warnings = null where warnings is not null or errors is not null;

update RPOSearch.dbo.forSaleDetail set wineN2 = null
update RPOSearch.dbo.forSaleDetail set wineN = null where wineN < 0 or isTempWineN = 1
update RPOSearch.dbo.forSale set wineN = null where wineN < 0 or isTempWineN = 1
update RPOSearch.dbo.WAName set vinn = null where vinn< 0 or isTempVinn = 1
------------------------------
--CAREFULL.  These are read in from Julian, don't delete unless you run JulianImport.vb again
delete from RPOSearch.dbo.forSaleDetail
delete from RPOSearch.dbo.WAName
delete from RPOSearch.dbo.Retailers
------------------------------

END