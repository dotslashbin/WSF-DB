CREATE proc resolveDuplicateWineNames (@db varchar(200)) as begin
/*
use erpIn
resolveDuplicateWineNames 'erpIn'
resolveDuplicateWineNames 'erp13'
*/
 
declare @q varchar(max) = '
declare @T table(fromWineNameN int, toWineNameN int);
 
------------------------------------------------------------------------------------------------------------------------------
-- Find duplicats and develop a translate table
------------------------------------------------------------------------------------------------------------------------------ 
with
a as (select row_Number() over(partition by joinx order by activeVinn desc) iRow, wineNameN, joinX from xxDBxx..wineName)
,b as (select a2.wineNameN fromWineNameN, a.wineNameN toWineNameN
	from a
		join a a2
			on a.joinX=a2.joinX
	where a.iRow=1 and 	a2.iRow>1     )
insert into @T(fromWineNameN, toWineNameN) select fromWineNameN, toWineNameN from b;
select * from @T;
 
------------------------------------------------------------------------------------------------------------------------------
-- Map all secondary versions to primary
------------------------------------------------------------------------------------------------------------------------------ 
update c set wineNameN=b.toWineNameN
	from xxDBxx..wine c
		join @T b
			on c.wineNameN=b.fromWineNameN;
 
update c set wineNameN=b.toWineNameN
	from xxDBxx..tasting c
		join @T b
			on c.wineNameN=b.fromWineNameN;
 
begin try
update c set wineNameN=b.toWineNameN
	from xxDBxx..price c
		join @T b
			on c.wineNameN=b.fromWineNameN;
end try begin catch end catch;

begin try
update c set wineNameN=b.toWineNameN
	from xxDBxx..wineAlt c
		join @T b
			on c.wineNameN=b.fromWineNameN;
end try begin catch end catch;

begin try
update c set wineNameN=b.toWineNameN
	from xxDBxx..idUse c
		join @T b
			on c.wineNameN=b.fromWineNameN;
end try begin catch end catch;

begin try
update c set wineNameN=b.toWineNameN
	from xxDBxx..mapPubGToWine c
		join @T b
			on c.wineNameN=b.fromWineNameN;
end try begin catch end catch;

begin try
update c set wineNameN=b.toWineNameN
	from xxDBxx..wordKey c
		join @T b
			on c.wineNameN=b.fromWineNameN;
end try begin catch end catch;


------------------------------------------------------------------------------------------------------------------------------
-- Delete duplicates
------------------------------------------------------------------------------------------------------------------------------
with
a as (select row_Number() over(partition by joinx order by activeVinn desc) iRow, wineNameN, joinX from xxDBxx..wineName)
delete from a where a.iRow>1;'
 
set @q = REPLACE(@q, 'xxDBxx', @db)

begin transaction
declare @lock int
exec @lock = sp_getapplock @resource='addNewWine', @lockmode='Exclusive'
exec (@q)
if @lock<0
	begin
		rollback transaction
	end
else
	begin
		exec sp_releaseAppLock @resource='addNewWine'
		commit transaction
	end

 
/*
USE AdventureWorks2008R2;
GO
BEGIN TRANSACTION;
DECLARE @result int;
EXEC @result = sp_getapplock @Resource = 'Form1', 
               @LockMode = 'Exclusive';
IF @result = -3
BEGIN
    ROLLBACK TRANSACTION;
END
ELSE
BEGIN
    EXEC @result = sp_releaseapplock @Resource = 'Form1';
    COMMIT TRANSACTION;
END;
GO*/
 
end
