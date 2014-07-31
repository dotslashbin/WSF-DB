CREATE function [tastingCountsInRange_0ld_sep28-2009](@wineN int, @pubGN int,  @trustedForWhN int)
returns @TT TABLE(wineN int, ratingRange int, cntTastingsInThisRange int)
begin
 
with a as (select wineN, pubN, tasterN
	,case
		when rating between 96 and 100 then 100 
		when rating between 90 and 95 then 95 
		when rating between 80 and 89 then 89 
		when rating between 70 and 79 then 79 
		else 69 
	end ratingRange 
from erp..tasting 
)
insert into @TT(wineN, ratingRange, cntTastingsInThisRange)
	select wineN,
	ratingRange, 
	COUNT(*) cntTastingsInThisRange
	from a 
	where 
		wineN=@wineN 
		and
		   (
			(pubN = @pubGN or (@pubGN is null or exists(select * from whToTrustedPub v where v.whN = @pubGN and v.pubN = a.pubN)))
			and
			(tasterN =  @trustedForWhN or ( @trustedForWhN is null or exists(select * from whToTrustedTaster v where v.whN =  @trustedForWhN and v.tasterN = a.tasterN)))
		   )
	group by wineN, ratingRange order by ratingRange desc
 
return
end 
 
