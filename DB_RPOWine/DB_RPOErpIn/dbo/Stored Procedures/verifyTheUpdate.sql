CREATE proc [dbo].[verifyTheUpdate] as begin
set nocount on
 
select 'rpoWineDataD..wine' a, count(*) from RPOWine.dbo.Wine	-- [EROBPARK-3\EROBPARK2K5].rpowinedatad.dbo.wine
union
select 'tastingNew' a,count(*) b from tastingNew
union
select 'tasting' a,count(*) b from RPOErp..tasting
union
select 'unmatched new winen' a,count(*) b from (select wineN from tastingNew except select wineN from RPOErp.dbo.wine)a
 
end
