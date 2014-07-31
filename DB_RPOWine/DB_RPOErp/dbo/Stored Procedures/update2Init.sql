CREATE proc [dbo].[update2Init]
as begin
set nocount on;
exec dbo.ooLog 'update2Init begin'

 
/*
drop proc update2views
select * into RPOErpIn..jWine from erpsearchd..wine
select * into RPOErpIn..eWine from rpowinedatad..wine					
*/
--drop synonym vTastingN
--begin try exec ('create synonym vTastingN for RPOErpIn..tastingNew') end try begin catch end catch
 
begin try drop view veWine end try begin catch end catch;
exec ('create view veWine as select *  from RPOErpIn..eWine')
 
begin try drop view vjWine end try begin catch end catch;
exec ('create view vjWine as select * from (select row_number() over (partition by winen  order by fixedid )ii, * from  RPOErpIn..jWine)a where ii=1')
 
begin try drop view vTastingNew end try begin catch end catch;
exec ('create view vTastingNew as select * from RPOErpIn..tastingNew')
 
begin try drop view vTastingNew2 end try begin catch end catch;
exec ('create view vTastingNew2 as select * from vTastingNew where dataSourceN is not null and dataIdN is not null')
 
begin try drop view vTasting end try begin catch end catch;
exec ('create view vTasting as select * from tasting')
 
begin try drop view vWinePlus end try begin catch end catch;
exec ('create view vWinePlus  as select a.*,b.producer,producershow,labelname,colorclass,winetype,dryness,variety,country,region,location,locale,site,joinx,matchName 	from wine a join winename b on a.winenamen=b.winenamen')
 
exec dbo.ooLog '     Views updated'
 
alter Index all on RPOErpIn.dbo.jWine disable;
alter index ix_jwine_wineN on RPOErpIn..jwine rebuild
update vjwine set joinx=null
update vjwine set joinx=dbo.getJoinx(producer,labelName,colorclass,country,region,location,locale,site,variety,winetype,dryness)
alter Index all on RPOErpIn.dbo.jWine rebuild;
 
exec dbo.ooLog '     jWine JoinX added'
 
alter Index ix_eWine_joinx on RPOErpIn.dbo.eWine disable;
update veWine set joinx=null
update veWine set joinx=dbo.getJoinx(producer,labelName,colorclass,country,region,location,locale,site,variety,winetype,dryness)
alter Index ix_eWine_joinx on RPOErpIn.dbo.eWine rebuild;
 
exec dbo.ooLog '     eWine JoinX added'
 
--create table mapJToE(jWineN int, eWineN int) 
--truncate table RPOErpIn..tastingNew	--vTastingNew
truncate table mapJToE
 
exec dbo.ooLog 'update2Init end'
end
 
 
 
