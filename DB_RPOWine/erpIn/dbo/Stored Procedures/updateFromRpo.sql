CREATE proc updateFromRpo as begin
/*
RESTORE DATABASE [erp] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL10.SQLDOUGVISTA64\MSSQL\repldata\erp 19 addwine2 fixed' WITH  FILE = 1,  NOUNLOAD,  STATS = 10
GO
RESTORE DATABASE [erpIn] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL10.SQLDOUGVISTA64\MSSQL\Backup\erpInX.bak' WITH  FILE = 1,  NOUNLOAD,  STATS = 10
GO
 
BACKUP DATABASE [erp] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL10.SQLDOUGVISTA64\MSSQL\Backup\erp1012Dec06 nameyear donebak' WITH NOFORMAT, NOINIT,  NAME = N'erp-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
 
 
USE erpIn
 
 drop view vRpoWine 
create view vWineFromRpo as select * from rpoWinedata..wine
 
truncate table tastingNew
verifyTheUpdate
*/
exec dbo.updateTastingNewFromRpo
exec dbo.updateNamesFromRpo
 
--exec dbo.updateErpTastingsFromNew
 
 
/*

use erpin
select * from vWineFromRpo where labelName like '%insolente%'














use erp
select count(*) from erp..tasting
select count(*) from erpin..tastingSnap
 
drop table tastingeSnap
 
use erpin
select * into tastingeSnap from erp..tasting
 
select dataIdN into aaDif from
		(
		select * from erpin..tastingsnap
		except
		select * from erp..tasting
		) a
 
select * into aaIntersect from
(select dataidn from erp..tasting
intersect
select dataidn from erpin..tastingSnap)a
 
 
select * from
		(select * from erp..tasting where dataidn in (select * from aaintersect)
		union
		select * from erpin..tastingSnap  where dataidn in (select * from aaintersect)
		)a
	order by winen,dataidn
 
select top 1 * from aaintersect
 
select 1 a,* from erp..tasting where dataidn=123389
union
select 2 a,* from erpin..tastingSnap where dataidn=123389
 
 
select * from erpin..tastingNew
except
select * from erp..tasting
 
sp_rename aaintersect, aaBoth
 
select dataIdn into aa from
	(select * from aadif
	intersect
	select * from aaboth)a
	
select a.* from erp..tasting a join aa on a.dataidn=aa.dataidn
union
select a.* from erpin..tastingSnap a join aa on a.dataidn=aa.dataidn
order by wineN, dataidn
 
with a as (
	select a.* from erp..tasting a join aa on a.dataidn=aa.dataidn
	union
	select a.* from erpin..tastingSnap a join aa on a.dataidn=aa.dataidn
	)
select * into aaa from a 
	where tastingN=115766
	order by wineN, dataidn
 
ov aaa
 
 
 
*/
 
 
end
 
