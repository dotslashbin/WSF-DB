--select * from ocrossstats('tasting', 'maywine')
CREATE function [dbo].[oCrossStats] (@ta varChar(max), @tb varChar(max))
returns @TT table(word varchar(max), cnt int, crossRefs varchar(max))
begin

--declare @ta varChar(max) = 'tasting', @tb varChar(max) = 'maywine'
--declare @TT table(field varchar(max), crossRefs varchar(max))
declare @field varchar(max)

declare @tta table(field varchar(max))
declare @ttb table(field varchar(max))

declare @aFields table (field varchar(max), word varchar(max))
declare @bFields table (field varchar(max), word varchar(max))


insert into @tta(field)
	select col from dbo.oofun(' ' + @ta + ' ', '', 'o')								   u
insert into @ttb(field)
	select col from dbo.oofun(' ' + @tb + ' ', '', 'o')


declare i cursor for select field from @tta
open i
while 1=1
	begin
		fetch next from i into @field
		if @@fetch_status <> 0 break
		insert into @aFields(field, word)
			select @field, word from dbo.oWords(@field)
	end
close i
deallocate i

declare i cursor for select field from @ttb
open i
while 1=1
	begin
		fetch next from i into @field
		if @@fetch_status <> 0 break
		insert into @bFields(field, word)
			select @field, word from dbo.oWords(@field)
	end
close i
deallocate i

insert into @TT(word, cnt, crossRefs)
	select word, count(*) cnt, replace(dbo.concatFF(field), char(12), '   ') fields
		from (select * from @aFields union select * from @bFields group by field, word) a
		group by word
		order by cnt desc, word

return
end
