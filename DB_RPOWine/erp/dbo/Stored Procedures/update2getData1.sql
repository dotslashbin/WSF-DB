CREATE proc [dbo].[update2getData1]

as begin
set statistics time on
 
drop table erpIn.dbo.rpowinedataDWine
--select * into erpIn.dbo.rpowinedataDWine from  [EROBPARK-3\EROBPARK2K8].rpowinedataD.dbo.Wine
select * into erpIn.dbo.rpowinedataDWine 
from dbo.SYN_t_Wine	-- rpowinedataD.dbo.Wine
 
drop table erpIn.dbo.erpSearchDWine
--select * into erpIn.dbo.erpSearchDWine from  [EROBPARK-3\EROBPARK2K8].erpSearchD.dbo.Wine
select * into erpIn.dbo.erpSearchDWine 
from dbo.SYN_t_searchWine	-- erpSearchD.dbo.Wine
  
drop table erpIn.dbo.erpSearchDWAName
--select * into erpIn.dbo.erpSearchDWAName from  [EROBPARK-3\EROBPARK2K8].erpSearchD.dbo.WAName
select * into erpIn.dbo.erpSearchDWAName 
from dbo.SYN_t_searchWAName	-- erpSearchD.dbo.WAName
 
drop table erpIn.dbo.erpSearchDRetailers
--select * into erpIn.dbo.erpSearchDRetailers from  [EROBPARK-3\EROBPARK2K8].erpSearchD.dbo.retailers
select * into erpIn.dbo.erpSearchDRetailers 
from dbo.SYN_t_searchRetailers	-- erpSearchD.dbo.retailers
 
drop table erpIn.dbo.erpSearchDForSale
--select * into erpIn.dbo.erpSearchDForSale from  [EROBPARK-3\EROBPARK2K8].erpSearchD.dbo.ForSale
select * into erpIn.dbo.erpSearchDForSale 
from dbo.SYN_t_searchForSale	-- erpSearchD.dbo.ForSale
 
drop table erpIn.dbo.erpSearchDForSaleDetail
--select * into erpIn.dbo.erpSearchDForSaleDetail from  [EROBPARK-3\EROBPARK2K8].erpSearchD.dbo.ForSaleDetail
select * into erpIn.dbo.erpSearchDForSaleDetail 
from dbo.SYN_t_searchForSale	-- erpSearchD.dbo.ForSaleDetail
 
end
 
RETURN 1
