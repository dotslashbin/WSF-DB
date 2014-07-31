-- show compressed output table / compressed output show summary table utility xx [=]
CREATE proc [oosum2] (@a varchar = null) as begin
set noCount on

--------------------------------------------------------------------
-- Compress out the uninteresting single-value columns
--------------------------------------------------------------------

/*
set @sql = replace(@sql, ' from ', ' into #T from ')
print @sql

begin try drop table #T end try begin catch end catch
select * into #T from wh where isPub = 1
select *
		from tempdb.information_schema.columns
		where table_name like '#T%'
		
select *
		from tempdb.information_schema.columns
		where table_name like '#T%'

*/
end


