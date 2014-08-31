CREATE proc MinimizeDBSize as begin
set nocount on

--select 'truncate table ' +name from sys.tables 
DROP table vAlert4
DROP table wineName4
DROP  table vForSale4
DROP  table tastingNewEWS
DROP  table ovv_temp1
truncate table tasting
DROP  table priceBreakdown1

end
