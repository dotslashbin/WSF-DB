 -- aspx database crossref other reviews todo xx  [=]
CREATE function getCrossReferences (@memberWhN int = 0, @currentPubGN int, @wineN int)
returns @T table(crossName varchar(300), crossPubGN int)
as begin
  
declare @masterGN int, @currentSplitGN int, @currentSplitTastingCount int, @currentTastingCount int
--set @masterGN = case when isnull(@memberWhN,0) = 0 then 18240 else 18241 end;
 
--set @masterGN = case isNull(@memberWhN, 0) when 0 then 18240 when 1 then 18241 when 2 then 18247 else 18240 end
if @memberWhN is not null
	set @masterGN = (select masterPubN from wh where whN = @memberWhN);
if isnull(@masterGN, 0) = 0 begin 
	set @masterGN = 18240
	if isnull(@currentPubGN, 0) = 0 set @currentPubGN = 18223
	end
else begin
	if isnull(@currentPubGN, 0) = 0 set @currentPubGN = @masterGN
	end
 
declare @splits table(splitGN int, tastingCount int)
 
insert into @splits(splitGN, tastingCount)
	select a.pubN, b.tastingCountThisPubG
		from
			pubGtoPub a
			join mapPubGToWine b
				on a.pubN = b.pubGN
					and b.wineN = @wineN
			where
				a.pubGN = @masterGN
				and a.isDerived = 0
				and a.pubN <> @currentPubGN
 
select @currentSplitGN = splitGN
	from 
		@splits a
	where exists
		(select * from pubGToPub where pubGN = a.splitGN and pubN = @currentPubGN)
 
select @currentTastingCount = tastingCountThisPubG
	from mapPubGToWine
	where pubGN = @currentPubGN
		and wineN = @wineN
 
insert into @T(crossName, crossPubGN)
	select b.displayName, a.splitGN
		from
			@splits a
		join wh b
			on a.splitGN = b.whN
		where  
			splitGN <> isnull(@currentSplitGN, -1)
			or tastingCount > isNull(@currentTastingCount, -1)
		order by isProfessionalTaster desc, displayName
 
return
end 
 
 
 
