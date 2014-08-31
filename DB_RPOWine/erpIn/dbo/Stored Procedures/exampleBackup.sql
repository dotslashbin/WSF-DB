create proc exampleBackup 
as begin
set nocount on 
/*
BACKUP DATABASE [erpin] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL10.SQLDOUGVISTA64\MSSQL\Backup\erpin1009Sep25 before fall' WITH NOFORMAT, NOINIT,  NAME = N'erpin-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
*/
end