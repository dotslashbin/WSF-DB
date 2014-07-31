create proc uniqueToIssue (@issues varChar(max)) as begin

begin try
	drop table wineNameP
end try begin catch end catch

select wineNameN,(isNull(producer,'')+'|'+isnull(labelname,''))joinP into wineNameP from erp..wineName;

with
ww as	(	select * from erp..wine     )
,mm as	(	select * from wineNameP    )
,tt as	(	select * from erpin..tastingNew)
,a as	(	select joinP,vintage, tt.* from ww join tt on ww.wineN=tt.wineN join mm on ww.wineNameN=mm.wineNameN)
,b as		(	select joinP from a where issue in (@issues) intersect select joinP from a where issue not in (@issues)    )
,c as		(	select a.* from a join b on a.joinP=b.joinP     )
,d as		(	select joinP, vintage from c where issue in (@issues) except select joinP, vintage from c where issue not in (@issues)     )
select*from d order by joinP,vintage
end