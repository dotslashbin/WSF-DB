CREATE proc verifyTheUpdate as begin
set nocount on
 
select 'rpoWineDataD..wine' a, count(*) from dbo.SYN_t_Wine --[EROBPARK-3\EROBPARK2K5].rpowinedatad.dbo.wine
union
select 'tastingNew' a,count(*) b from erpIn..tastingNew
union
select 'tasting' a,count(*) b from erp..tasting
union
select 'unmatched new winen' a,count(*) b from (select wineN from erpin..tastingNew except select wineN from erp..wine)a
 
end
