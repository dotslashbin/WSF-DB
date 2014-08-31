CREATE PROCEDURE [dbo].[updateRecordsForNewWine] 
(
  @whn int, 
  @oldWineN int,
  @newWineN int
)
AS
IF EXISTS( SELECT * FROM whToWine WHERE whn=@whn and wineN=@newWineN)

BEGIN
  --This means the oldWIneRecord exists
  IF EXISTS( SELECT * FROM whToWine WHERE whn=@whn and wineN=@oldWineN)  delete from whToWine WHERE  whn=@whn and wineN=@oldWineN;
  IF EXISTS( SELECT * FROM whNameTowine WHERE whn=@whn and wineN=@oldWineN)  delete from whNameTowine WHERE  whn=@whn and wineN=@oldWineN;
  IF EXISTS( SELECT * FROM tasting WHERE TasterN=@whn and wineN=@oldWineN)  update tasting set wineN=@newWineN WHERE wineN=@oldWineN AND  TasterN=@whn;
END
ELSE
BEGIN
  IF EXISTS( SELECT * FROM whToWine WHERE whn=@whn and wineN=@oldWineN)  update  whToWine set wineN=@newWineN WHERE  wineN=@oldWineN AND  whn=@whn;
  IF EXISTS( SELECT * FROM whNameTowine WHERE whn=@whn and wineN=@oldWineN)  delete from whNameTowine WHERE  whn=@whn and wineN=@oldWineN;
  IF EXISTS( SELECT * FROM tasting WHERE TasterN=@whn and wineN=@oldWineN)  update tasting set wineN=@newWineN WHERE wineN=@oldWineN AND  TasterN=@whn;
END
