CREATE function [dbo].[oCrossT] (@ta varChar(max), @tb varChar(max), @ignoreWords varChar(max))
returns @TT table(field varchar(max), crossRefs varchar(max))
begin
 
--declare @ta varChar(max) = 'tasting', @tb varChar(max) = 'maywine', @ignoreWords varChar(max) = 'has Is N x Hi '
--declare @ta varChar(max) = 'tasting', @tb varChar(max) = 'maywine', @ignoreWords varChar(max)
--declare @TT table(field varchar(max), crossRefs varchar(max))
 
declare @field varchar(max)
 
declare @tta table(field varchar(max))
declare @ttb table(field varchar(max))
declare @tIgnore table(word varchar(max))
 
declare @aFields table (field varchar(max), word varchar(max))
declare @bFields table (field varchar(max), word varchar(max))
 
 
insert into @tIgnore(word)
	select * from dbo.oWords(@ignoreWords)
 
insert into @tta(field)
	select col from dbo.oofun(' ' + @ta + ' ', '', 'o')
insert into @ttb(field)
	select col from dbo.oofun(' ' + @tb + ' ', '', 'o')
	
declare i cursor for select field from @tta
open i
while 1=1
	begin
		fetch next from i into @field
		if @@fetch_status <> 0 break
		insert into @aFields(field, word)
			select @field, word from (select word from dbo.oWords(@field)  except select word col from @tIgnore) a
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
			select @field, word from (select word from dbo.oWords(@field)  except select word col from @tIgnore) a
	end
close i
deallocate i;
 
 
 
--select a.field aField, b.field bField, b.word
with
a as (select a.field aField, b.field bField, b.word bword
			from @bFields b
				join @aFields a
					on 	b.word like (a.word + '%')
			group by a.field, b.field, b.word     )
,b as (select aField, bField, count(*) abCnt
			from a
			group by aField, bField     )
,c as (select field aField, count(*) aCnt from @aFields group by field)
,d as (select field bField, count(*) bCnt from @bFields group by field)
,e as (select top 99999 b.aField, b.bField, abCnt, aCnt, bCnt
			from b
				join c on b.aField = c.aField
				join d on b.bField = d.bField
			order by 
				b.aField
				, case 
					when b.aField = b.bField then 0
					--when b.aField like (b.bField+'%') or b.bField like (b.aField+'%') then 1
					when b.aField like ('%'+b.bField+'%') or b.bField like ('%'+b.aField+'%') then 2					
					else 3
					end
				, aCnt+bCnt - 2*abCnt
				, b.bField     )
insert into @TT(field, crossRefs)
select aField, replace(dbo.concatFF(bField),char(12),'    ') crossRefs
	from e
	group by aField
 
return
end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
