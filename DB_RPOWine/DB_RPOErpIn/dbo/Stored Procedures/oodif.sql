--coding utility [=]
CREATE PROC [dbo].oodif (@table1 varChar(50) = null, @table2 varChar(50) = null, @filter varChar(50) = '')

AS
BEGIN
	declare @TT table (ii int, col1 varchar(max),col2 varchar(max))
	declare @T1 table(col varchar(max), ii int)
	declare @T2 table(col varchar(max), ii int)
	set @filter = '%' + isNull(@filter, '') + '%'
	print @filter
	
	insert into @T1(col, ii)
		select column_name, row_number() over (order by column_name) from
			(
			select column_name from information_schema.columns where table_name = @table1 and column_name like @filter
			except
			select column_name from information_schema.columns where table_name = @table2 and column_name like @filter
			) a;

	insert into @T2(col,ii)
		select column_name, row_number() over (order by column_name) from
			(
			select column_name from information_schema.columns where table_name = @table2 and column_name like @filter
			except
			select column_name from information_schema.columns where table_name = @table1 and column_name like @filter
			) a;
	
	if (select count(*) from @T1) > (select count(*) from @T2)
		begin
			insert into @TT(ii, col1) select ii, col from @T1 order by ii
			update a set col2 = col from @TT a join @T2 b on a.ii = b.ii
		end
	else
		begin
			insert into @TT(ii, col2) select ii, col from @T2 order by ii
			update a set col1 = col from @TT a join @T1 b on a.ii = b.ii
		end

update @TT set col1 = isnull(col1, ''), col2 = isnull(col2,'')


select col1,col2 from @TT

/*
	with
	  a as (select col, row_number() over (order by col) ii from @T1)
	, b as (select col, row_number() over (order by col) ii from @T2)
	, c as	(select case when a.ii is null then b.ii else a.ii end ii, a.col col1, b.col col2
			from a  right outer join b on a.ii = b.ii
		)
	insert into @TT(col1, col2)
		--select col, col from a order by ii
		select col1,col2 from c order by ii
*/		

 
RETURN 
END
 
/*
oodif winename, nameyear, id
oon

*/