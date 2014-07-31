-- explode pubG recurse recursion to get dropdown publication list [=]
CREATE function getPubDropDown (@StartPubGN int)
returns @T table(title varchar(300), pubGN int)
 
as begin
---------------------------------------------
--set @StartPubGN = case isNull(@StartPubGN, 0) when 0 then 18240 when 1 then 18241 when 2 then 18247 else 18240 end
---------------------------------------------
set @StartPubGN = case isNull(@StartPubGN, 0) when 0 then 18241 else @StartPubGN end
 
declare @indent varchar(99); set @indent = '....'
declare  @i int; select @i = 3
declare @X table(pubGN int, title varchar(999), indent varchar(99), parentTitles varchar(999))
 
insert into @X(pubGN, title, indent, parentTitles) select @startPubGN, dbo.getName(@startPubGN), @indent, ''
 
while @i > 0 begin
	insert into @X(pubGN, title, indent, parentTitles)
		select b.pubN, a.indent + c.fullName, a.indent + @indent, a.parentTitles + char(255) 
				+ case c.isProfessionalTaster when 1 then '0' else '1' end + char(255)
				+ c.fullName
			from @X a
				join pubGtoPub b
					on b.pubGN = a.pubGN and b.isDerived = 0
				join wh c
					on c.whN = b.pubN
			where not exists
				(select 1
					from @X d
						where d.pubGN = b.pubN
					)
 
	if @@rowCount = 0 Break
	set @i = @i - 1
	end
 
 
insert into @T(title, pubGN)
	select title, pubGN 
		from @X 
		where title is not null
		order by parentTitles
 
return
end
 
