-- update		[=]
CREATE procedure updateErp as begin
 
exec updateErpFromRpoWineData
exec updateErpFromErpSearch
exec updateErpRetailersFromErpSearch
exec updateErpWineNamesFromErpSearch
--OLD exec updateErpWineAltFromErp
exec updateErpWineFromAlt

exec updateWineNameProducerURL
 
end


