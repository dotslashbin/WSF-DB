CREATE proc [update2getData1_3Aug2012]
as begin
set statistics time on
 
drop table erpin.dbo.rpowinedataDWine
select * into erpin.dbo.rpowinedataDWine from  [EROBPARK-3\EROBPARK2K8].rpowinedataD.dbo.Wine
 
drop table erpin.dbo.erpSearchDWine
select * into erpin.dbo.erpSearchDWine from  [EROBPARK-3\EROBPARK2K8].erpSearchD.dbo.Wine
  
drop table erpin.dbo.erpSearchDWAName
select * into erpin.dbo.erpSearchDWAName from  [EROBPARK-3\EROBPARK2K8].erpSearchD.dbo.WAName
 
drop table erpin.dbo.erpSearchDRetailers
select * into erpin.dbo.erpSearchDRetailers from  [EROBPARK-3\EROBPARK2K8].erpSearchD.dbo.retailers
 
drop table erpin.dbo.erpSearchDForSale
select * into erpin.dbo.erpSearchDForSale from  [EROBPARK-3\EROBPARK2K8].erpSearchD.dbo.ForSale
 
drop table erpin.dbo.erpSearchDForSaleDetail
select * into erpin.dbo.erpSearchDForSaleDetail from  [EROBPARK-3\EROBPARK2K8].erpSearchD.dbo.ForSaleDetail
 
end
