-- show compressed output table / compressed output show summary table utility xx [=]
CREATE proc ooSum (@sql varchar(max)) as begin
set noCount on

--------------------------------------------------------------------
-- Compress out the uninteresting single-value columns
--------------------------------------------------------------------

set @sql = replace(@sql, ' from ', ' into #T from ')

set @sql = @sql + '
insert into #C(column_name)
		select column_name
		from tempdb.information_schema.columns
		where table_name like ''[#]T%'''


--print @sql

begin try drop table #C end try begin catch end catch
create table #C(column_name varchar(max))

begin try drop table #T2 end try begin catch end catch
create table #T2(xxT2 varchar(max))

begin try drop table #T end try begin catch end catch
exec (@sql)
select * from #C

/*
select * into #T from wh where isPub = 1
select *
		from tempdb.information_schema.columns
		where table_name like '#T%'
		

oosum 'select * from wh where isPub = 1'

begin try drop table #T end try begin catch end catch
select * into #T from wh where isPub = 1;
select *
		from tempdb.information_schema.columns
		where table_name like '#T%'

select * from #C
ooSum2

exec	('exec (''print '''''foo''''''))

*/
----------------------
/*
drop table #T
exec('select * into #T from wh where isPub = 1;select * from #T')

oosum 'select * into #T from wh where isPub = 1'

select * into #T from wh where isPub = 1
select * from #T
ookey xx
*/
end
