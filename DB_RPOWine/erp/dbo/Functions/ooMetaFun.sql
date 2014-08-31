--coding reference utility			[=]
CREATE FUNCTION [dbo].[ooMetaFun](@arg varchar(10) = '')
RETURNS 
@TT table (nm varchar(max),def varchar(max), udate dateTime)
AS
BEGIN
--	A	All					Show all functions even those without a categories a [=] prefix
--	R	Recent			Show most recent first
--	W	Words			Breakout category words one per row

declare @T table (nm varchar(max),def varchar(max), udate dateTime)

if @arg like '%A%'
	insert into @T(nm, def)
		select [name] nm, dbo.getCategoryLine(y.definition) def 
			from sys.objects z left join sys.sql_modules y on z.object_id = y.object_id
			where 
				[type] not in ('D', 'IT', 'PK', 'S', 'V', 'U')
else
	insert into @T(nm, def)
		select [name] nm, dbo.getCategoryLine(y.definition) def 
			from sys.objects z left join sys.sql_modules y on z.object_id = y.object_id
			where 
				[type] not in ('D', 'IT', 'PK', 'S', 'V', 'U')
				and y.definition like '%[[]=]%'

update z set z.uDate = y.modify_date
	from @T z
		join sys.objects y
			on z.nm = y.name

if @arg like '%W%' begin
	insert into @TT(nm) select 'Word breakout not implemented yet'
	end
else if @arg like '%R%' begin
	insert into @TT(nm, def, udate)
		select nm, def, udate from @T
			order by udate desc, nm
	end
else begin
	insert into @TT(nm, def, udate)
		select nm, def, udate from @T
			order by nm, udate desc

	end

/*
select * from oometaFun('ra')
*/

RETURN 
END
