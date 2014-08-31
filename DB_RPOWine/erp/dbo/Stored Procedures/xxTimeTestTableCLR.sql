--timing test for clr functions returning tables xx [=]
create proc xxTimeTestTableCLR as begin set noCount on /*



begin try drop table #b end try begin catch end catch
create table #b(word nvarchar(300))
declare @m varchar(99); set @m =  'CLR fun of 3 each'
exec dbo.timer @m
set noCount on
declare @i int
set @i = 0
while @i < 50000 begin
	insert into #b(word) select w from dbo.getWords('one')
	set @i = 1 + @i
	end
exec dbo.timer @m, 1;
select convert(varchar, count(*)) + ' records' from #b
go
begin try drop table #b end try begin catch end catch
create table #b(word nvarchar(300))
declare @m varchar(99); set @m =  'SQL fun of 3 each'
exec dbo.timer @m
set noCount on
declare @i int
set @i = 0
while @i < 50000 begin
	insert into #b(word) select w from dbo.getWordsxx('one')
	set @i = 1 + @i
	end
exec dbo.timer @m, 1
select convert(varchar, count(*)) + ' records' from #b
select * from times order by starttime desc

*/
end