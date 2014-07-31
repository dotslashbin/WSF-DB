 -- aspx database crossref other reviews [=]
CREATE function getCrossReferences2 (@memberWhN int = 0, @currentPubGN int, @wineN int)
returns @T table(refDisplayName varchar(300), refPubGN int)
as begin

declare @masterGN int
declare @thisSplitGN int
set @masterGN = case when isnull(@memberWhN,0) = 0 then 18240 else 18241 end;

with
 splits as (select a.pubN splitGN
	from
		pubGtoPub a
		where
			a.pubGN = @masterGN
			and a.isDerived = 0
	)
,thisSplit as (select top(1) splitGN thisSplitGN
	from
		splits
		join pubGToPub path
			on (splits.splitGN = path.pubGN) or (splits.splitGN = @currentPubGN)
	where
		path.pubN = @currentPubGN
	)
select @thisSplitGN = thisSplitGN from thisSplit;

with
 splits as (select a.pubN splitGN
	from
		pubGtoPub a
		where
			a.pubGN = @masterGN
			and a.isDerived = 0
	)
,splitCount as (select tastingCountThisPubG thisSplitTastingCount
	from 
		 mapPubGToWine
		where
			pubGN = @thisSplitGN
			and wineN = @wineN
	)
,thisCount as (select tastingCountThisPubG thisTastingCount
	from 
		mapPubGToWine
	where
		pubGN = @currentPubGN
		and wineN = @wineN
	)
,refs as (select b.fullName, b.displayName, a.splitGN
	from
		splits a
	join wh b
		on a.splitGN = b.whN
	,splitCount
	,thisCount
	where splitGN <> @thisSplitGN
		or thisSplitTastingCount > thisTastingCount
	)
insert into @T(refDisplayName, refPubGN)
	--select displayName, splitGN 
	select fullName+'  ('+convert(varchar, splitGN)+')' displayName, splitGN 
		from refs
		order by displayName

return

end 
 
 
 
 
 
