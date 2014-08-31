CREATE proc exampleRemoteServer
as begin
--sp_addlinkedserver 
exec sp_serveroption 'EROBPARK-3\EROBPARK2K5', 'data access', 'true'
--select * into wine from  [EROBPARK-3\EROBPARK2K5].rpowinedatad.dbo.wine
end
