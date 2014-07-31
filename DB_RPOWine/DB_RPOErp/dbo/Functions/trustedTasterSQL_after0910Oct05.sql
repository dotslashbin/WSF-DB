-----------------------------------------------------------------------------------------------------
-- Find Potential Trusted Tasters
-----------------------------------------------------------------------------------------------------
CREATE  function trustedTasterSQL_after0910Oct05(@whN int, @contains nvarchar(1000)=null, @mustAlreadyBeTrustedByMe bit = 0)
returns varchar(max)
begin
 
 
declare @s varchar(max), @sx varchar(max) 
set @s = '
with
a as (select tasterN, count(distinct wineN) countOfWinesTasted
	from tasting
	where isPrivate <> 1
		and isAnnonymous <> 1	
	group by tasterN
)
,b as (select tasterN, count (distinct whN) countOfWhoTrustsThisTaster
	from whToTrustedTaster
	group by tasterN
)
,c as (select whN, tasterN
	from whToTrustedTaster
	@whereMe@
)
,d as (select a.tasterN, y.displayName displayName, a.countOfWinesTasted, b.countOfWhoTrustsThisTaster
		, case when c.tasterN is null then 0 else 1 end isCurrentlyTrustedByMe
	from a
		join wh y on y.whN = a.tasterN
			and displayName like ''%[^ ]%''
			and displayName <> ''anonymous''
			@andContains@
		left join c on c.tasterN = a.tasterN
		left join b on b.tasterN = a.tasterN
	@whereAlreadyTrusted@
)
select * from d '
 
 if @whN > 0 begin
	set @sx = convert(varchar, @whN)
	set @s = replace(@s, '@whereMe@', 'where whN = '+@sx)
end
else begin
	set @s = replace(@s, '@whereMe@', 'where 0<>0')
end
 
if @mustAlreadyBeTrustedByMe <> 0
	set @s = replace(@s, '@whereAlreadyTrusted@', '	where c.tasterN is not null')
else
	set @s = replace(@s, '@whereAlreadyTrusted@', '')
 
if @contains like '%[^*" ]%' 
	set @s = replace(@s, '@andContains@', 'and contains(displayName, '''+@contains+''')')
else
	set @s = replace(@s, '@andContains@', '')
 
return @s
end
 
 
 
 
/*
declare @s varChar(max) = dbo.trustedTasterSQL(22, ' "d*"  ', 0)
set @s += 'order by displayName'
print @s
exec (@s)
 
 
declare @s varChar(max) = dbo.trustedTasterSQL(22, null, 1)
set @s += 'order by displayName'
print @s
exec (@s)
 
 
*/
