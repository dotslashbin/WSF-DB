-----------------------------------------------------------------------------------------------------
-- Find Potential Trusted Tasters
-----------------------------------------------------------------------------------------------------
CREATE function [dbo].[trustedTasterSQL_dev](@whN int, @contains nvarchar(1000)=null, @mustAlreadyBeTrustedByMe bit = 0, @maxRows int = 100)
returns varchar(max)
begin
 
 
declare @s varchar(max), @sx varchar(max) 
set @s = '
with
a as (select tasterN, count(distinct wineN) countOfWinesTasted
	from tasting
	where isPrivate <> 1
		and isAnnonymous <> 1	
	group by tasterN     )
,b as (select tasterN, count (distinct whN) countOfWhoTrustsThisTaster
	from whToTrustedTaster
	group by tasterN     )
, c as	(
		select distinct tasterN from whToTrustedTaster
		union
		select distinct tasterN from tasting     )     
, d as	(
		select c.tasterN, bb.displayName displayName
			, isNull(a.countOfWinesTasted, 0) countOfWinesTasted
			, isNull(b.countOfWhoTrustsThisTaster, 0) countOfWhoTrustsThisTaster
		from c
			join wh bb
				on c.tasterN=bb.whN
			join a
				on c.tasterN=a.tasterN
			left join b
				on c.tasterN=b.tasterN
		where
			displayName like ''%[^ ]%''
			@andContains@
			and displayName <> ''anonymous''     )
, e as	(
		select d.*, case when bb.tasterN is null then 0 else 1 end isCurrentlyTrustedByMe
			from d
			@left@ join whToTrustedTaster bb
				on d.tasterN = bb.tasterN and bb.@whN2@
			)
select top '+convert(varchar, @maxRows)+' * from e '
 
set @sx = convert(varchar, @whN)
set @s = replace(@s, '@whN@', @sx)
 
 if @whN > 0 begin
	set @sx = 'whN = '+@sx
	set @s = replace(@s, '@whN2@', @sx)
end
else begin
	set @sx = '0<>0'
	set @s = replace(@s, '@whN2@', @sx)
end
 
if @mustAlreadyBeTrustedByMe <> 0
	set @s = replace(@s, '@left@', '')
else
	set @s = replace(@s, '@left@', ' left ')
 
if @contains like '%[^*" ]%' 
	--set @s = replace(@s, '@andContains@', 'and contains(displayName, ''  "' +@contains+'*"   '')')
	set @s = replace(@s, '@andContains@', 'and contains(displayName, '''+@contains+''')')
 
else
	set @s = replace(@s, '@andContains@', '')
 
return @s
end
 
 
 
 
/*
declare @s varChar(max) = dbo.trustedTasterSQL_dev(20, 'flower*', 0, 100)
set @s += 'order by displayName'
print @s
exec (@s)
 
 
declare @s varChar(max) = dbo.trustedTasterSQL(22, null, 1)
set @s += 'order by displayName'
print @s
exec (@s)
 
 
*/
 
 
 
 
 
