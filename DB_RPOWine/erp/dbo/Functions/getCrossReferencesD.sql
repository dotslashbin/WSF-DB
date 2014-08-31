 -- aspx database crossref other reviews [=]
create function getCrossReferencesD (@memberWhN int = 0, @currentPubGN int, @wineN int)
returns @T table(refDisplayName varchar(300), refPubGN int)
as begin
 
declare @masterGN int
set @masterGN = case when isnull(@memberWhN,0) = 0 then 18240 else 18241 end;
 
with
 splits as (select a.pubN splitGN
	from
		pubGtoPub a
		join mapPubGToWine b
			on a.pubN = b.pubGN
				and b.wineN = @wineN
		where
			a.pubGN = @masterGN
			and a.isDerived = 0
	)
,refs as (select b.fullName, b.displayName, a.splitGN
	from
		splits a
	join wh b
		on a.splitGN = b.whN
	where splitGN <> @currentPubGN
	)
insert into @T(refDisplayName, refPubGN)
	select fullName+'  ('+convert(varchar, splitGN)+')' displayName, splitGN 
		from refs
		order by displayName
 
return
 
end 
 
 
 
 
 
 
