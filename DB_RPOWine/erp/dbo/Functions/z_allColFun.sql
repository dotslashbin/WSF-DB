--utility 			 [=]
CREATE function [dbo].[z_allColFun] (
	  @1 varchar(99)
	, @1alias varchar(99) = ''
	, @2 varchar(99) = ''
	, @2alias varchar(99) = ''
	, @2suffix varchar(99) = ''
	)
returns varchar(max)
as begin
declare @r varchar(max) 
declare @T1 table(col varchar(99))
declare @T2 table(col varchar(99))
declare @both table(col varchar(99))
	if 0 = len(@2) begin
		select @r = dbo.concatenate(col) from oofun(' ' + @1 + ' ', '', 'i')
		end
	else begin
		insert into @T1(col) select  col from oofun(' ' + @1 + ' ', '', 'i')
		insert into @T2(col) select  col from oofun(' ' + @2 + ' ', '', 'i')
		insert into @both(col) 
			select * from (
				select col from @T1 
				intersect 
				select col from @T2
				) z
		if exists(select * from @both)  begin
			if len(@2alias) > 0 begin
					if 0 = len(@1alias) set @1alias = @1
					update @T1 set col = @1alias + '.' + col where col in (select col from @both)
					if 0 = len(@2suffix) set @2suffix = '_' + @2alias
					update @T2 set col =  @2alias + '.' + col + ' ' + col + @2suffix  where col in (select col from @both)
				end
			else begin
				--delete from @T1 where col in (select col from @both)
				delete from @T2 where col in (select col from @both)
				end
			end

			insert into @T1(col) select col from @T2
			select @r = dbo.concatenate(col) from @T1
		end

	set @r = replace(@r, ';   ',';')
	set @r = replace(@r, ';  ',';')
	set @r = replace(@r, '; ',';')
	set @r = replace(@r, ';',',')

	if right(@r, 1) = ','  	set @r = left(@r, len(@r) - 1)

	return @r
end


