CREATE PROCEDURE [dbo].[_JOB_UpdateMyWinesFromERP]

AS

exec dbo.update2getData1
exec dbo.update2getData2
exec dbo.update2Init
exec dbo.update2Wh
exec dbo.update2wineNames
exec dbo.update2winesChanged
exec dbo.update2winesNew 'erp'
exec dbo.update2winesNew 'julian'
exec dbo.update2namer
exec dbo.update2tastingStep1
exec dbo.update2tastingStep2
exec dbo.update2price
exec dbo.updateWinenameInfo;


--truncate table ewine
--truncate table jwine
--truncate table tastingNew
DBCC SHRINKDATABASE(N'RPOErpIn' );

RETURN 1
