create proc getFromErp3
as begin
set statistics time on
if OBJECT_ID('rpowinedatadWine ') >0 drop table rpowinedatadWine 
select * into rpowinedatadWine from [EROBPARK-3\EROBPARK2K5].rpowinedatad.dbo.wine

if OBJECT_ID('erpSearchDWine ') >0 drop table erpSearchDWine 
select * into erpSearchDWine from [EROBPARK-3\EROBPARK2K5].erpsearchd.dbo.wine

if OBJECT_ID('erpSearchDForSale') >0 drop table erpSearchDForSale
select * into erpSearchDForSale from [EROBPARK-3\EROBPARK2K5].erpSearchD.dbo.ForSale

if OBJECT_ID('erpSearchDForSaleDetail ') >0 drop table erpSearchDForSaleDetail 
select * into erpSearchDForSaleDetail from [EROBPARK-3\EROBPARK2K5].erpSearchD.dbo.ForSaleDetail

if OBJECT_ID('erpSearchDRetailers ') >0 drop table erpSearchDRetailers 
select * into erpSearchDRetailers from [EROBPARK-3\EROBPARK2K5].erpSearchD.dbo.Retailers

if OBJECT_ID('erpSearchDWAName ') >0 drop table erpSearchDWAName 
select * into erpSearchDWAName from [EROBPARK-3\EROBPARK2K5].erpSearchD.dbo.WAName

set statistics time off 
end