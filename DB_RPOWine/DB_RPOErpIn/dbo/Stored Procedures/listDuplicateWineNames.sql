CREATE proc listDuplicateWineNames (@db varchar(200)) as begin
/*
use erpIn
listDuplicateWineNames 'erp13'

*/

declare @q varchar(max) = '
declare @T table(fromWineNameN int, toWineNameN int);

with
a as (select row_Number() over(partition by joinx order by activeVinn desc) iRow, wineNameN, joinX from xxDBxx..wineName)
,b as (select a2.wineNameN fromWineNameN, a.wineNameN toWineNameN
	from a
		join a a2
			on a.joinX=a2.joinX
	where a.iRow=1 and 	a2.iRow>1     )
insert into @T(fromWineNameN, toWineNameN) select fromWineNameN, toWineNameN from b;
select * from @T'

set @q = REPLACE(@q, 'xxDBxx', @db)
--print @q
exec (@q)

/*
with
a as (select row_Number() over(partition by joinx order by activeVinn desc) iRow, wineNameN, joinX from wineName)
select * from a  where a.iRow>1
*/

end