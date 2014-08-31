CREATE proc updateErpFromIn as begin
/*
use erpIn
 
CHECK for erpxx refs in other functions
oo fdr,'erp1'
updateErpWineFromIn
updateErpWineNameFromIn
updateTastings
 
alter view vWineName as select * from erp..wineName
alter view vTastingNew as select * from tastingNew where dataSourceN is not null and dataIdN is not null
alter view vTasting as select * from erp..tasting where dataSourceN is not null and dataIdN is not null
alter view vWine as select * from erp..wine
alter view vWh as select * from erp..wh
 
oodef vWineName
oodef vTasting
oodef vWine
*/
 
exec dbo.updateErpWineNameFromIn
exec dbo.updateErpWineFromIn
exec dbo.updateErpTastingsFromIn
exec erp.dbo.updateSpeed
end
 
 
 
 
 
