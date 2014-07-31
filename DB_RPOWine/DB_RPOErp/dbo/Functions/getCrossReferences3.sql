 -- aspx database crossref other reviews [=]
CREATE function getCrossReferences3 (@memberWhN int = 0, @currentPubGN int, @wineN int)
returns @T table(refDisplayName varchar(300), refPubGN int)
as begin
 
declare @masterGN int
set @masterGN = case when isnull(@memberWhN,0) = 0 then 18240 else 18241 end;
 
with
 splits as (select a.pubN splitGN
	from
		pubGtoPub a
		where
			a.pubGN = @masterGN
			and a.isDerived = 0
	)
--,thisSplitRaw as (select splitGN thisSplitGN
,thisSplit as (select top(1) splitGN thisSplitGN
	from
		splits
		join pubGToPub path
			on (splits.splitGN = path.pubGN) or (splits.splitGN = @currentPubGN)
	where
		path.pubN = @currentPubGN
	)
/*
,thisSplit as (select top 1 thisSplitGN
	from 
		(select thisSplitGN from thisSplitRaw
			union select 0 thisSplitGN
			) a
	)
*/
,splitCount as (select tastingCountThisPubG thisSplitTastingCount
	from 
		 mapPubGToWine
		,thisSplit
		where
			pubGN = thisSplitGN
			and wineN = @wineN
	)
,thisCount as (select tastingCountThisPubG thisTastingCount
	from 
		mapPubGToWine
	where
		pubGN = @currentPubGN
		and wineN = @wineN
	)
--,refs as (select b.displayName, a.splitGN
,refs as (select b.fullName, b.displayName, a.splitGN
	from
		splits a
	join wh b
		on a.splitGN = b.whN
	,thisSplit
	,splitCount
	,thisCount
	where splitGN <> thisSplitGN
		or thisSplitTastingCount > thisTastingCount
	)
insert into @T(refDisplayName, refPubGN)
	--select displayName, splitGN 
	select fullName+'  ('+convert(varchar, splitGN)+')' displayName, splitGN 
		from refs
		order by displayName
 
return
 
end 
 
 
 
 
 
 
