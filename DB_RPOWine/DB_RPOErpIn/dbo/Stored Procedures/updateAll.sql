CREATE proc [dbo].[updateAll] as begin
set noCount on
  
  ------------------------------------------------------------------------------------------
  -- Overview
  ------------------------------------------------------------------------------------------
  /*
  Make sure vWineErp and vBottleSize are correct
  
  updateNames
  updateDollars6
  updateTastings
  */
  
------------------------------------------------------------------------------------------
  -- Prices and BottleSize
  ------------------------------------------------------------------------------------------
--exec dbo.updateImportFromAccess
 
--exec dbo.updateJulianPrices26
exec dbo.updateBottleSize
 
------------------------------------------------------------------------------------------
-- Update Tastings NOT VERIFIED FOR FINAL
------------------------------------------------------------------------------------------
/*
truncate table tasting
*/

/*
updateTastingNewFromERP
updateTastingFromNew
updateTastingNewFromEWS
updateTastingFromNew
*/
 
 
set noCount off
end
 
