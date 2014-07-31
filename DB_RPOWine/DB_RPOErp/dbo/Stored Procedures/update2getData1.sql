CREATE proc [dbo].[update2getData1]

as begin
set statistics time on
 
drop table RPOErpIn.dbo.rpowinedataDWine
--select * into RPOErpIn.dbo.rpowinedataDWine from  [EROBPARK-3\EROBPARK2K8].rpowinedataD.dbo.Wine
select * into RPOErpIn.dbo.rpowinedataDWine 
from dbo.SYN_t_Wine	-- rpowinedataD.dbo.Wine
 
drop table RPOErpIn.dbo.erpSearchDWine
--select * into RPOErpIn.dbo.erpSearchDWine from  [EROBPARK-3\EROBPARK2K8].erpSearchD.dbo.Wine
select * into RPOErpIn.dbo.erpSearchDWine 
from dbo.SYN_t_searchWine	-- erpSearchD.dbo.Wine
  
drop table RPOErpIn.dbo.erpSearchDWAName
--select * into RPOErpIn.dbo.erpSearchDWAName from  [EROBPARK-3\EROBPARK2K8].erpSearchD.dbo.WAName
select * into RPOErpIn.dbo.erpSearchDWAName 
from dbo.SYN_t_searchWAName	-- erpSearchD.dbo.WAName
 
drop table RPOErpIn.dbo.erpSearchDRetailers
--select * into RPOErpIn.dbo.erpSearchDRetailers from  [EROBPARK-3\EROBPARK2K8].erpSearchD.dbo.retailers
select * into RPOErpIn.dbo.erpSearchDRetailers 
from dbo.SYN_t_searchRetailers	-- erpSearchD.dbo.retailers
 
drop table RPOErpIn.dbo.erpSearchDForSale
--select * into RPOErpIn.dbo.erpSearchDForSale from  [EROBPARK-3\EROBPARK2K8].erpSearchD.dbo.ForSale
select * into RPOErpIn.dbo.erpSearchDForSale 
from dbo.SYN_t_searchForSale	-- erpSearchD.dbo.ForSale
 
drop table RPOErpIn.dbo.erpSearchDForSaleDetail
--select * into RPOErpIn.dbo.erpSearchDForSaleDetail from  [EROBPARK-3\EROBPARK2K8].erpSearchD.dbo.ForSaleDetail
select * into RPOErpIn.dbo.erpSearchDForSaleDetail 
from dbo.SYN_t_searchForSale	-- erpSearchD.dbo.ForSaleDetail
 
end
 
RETURN 1