CREATE function [tastingCountsInRange-old-sep29-2009](@whN int = null, @wineN int = null, @pubGN int,  @MustHaveReviewInThisPubG bit = 0, @mustBeTrustedTaster bit = 0)
returns @TT TABLE(wineN int, ratingRange int, cntTastingsInThisRange int)
begin
 
with a as (select wineN
		,case
			when rating between 96 and 100 then 100 
			when rating between 90 and 95 then 95 
			when rating between 80 and 89 then 89 
			when rating between 70 and 79 then 79 
			else 69 
		end ratingRange 
	from erp..tasting z
	left join whToTrustedPub y
		on y.whN = @whN and y.pubN = z.pubN
	left join whToTrustedTaster x
		on x.whN = @whN and x.tasterN = z.tasterN
	left join pubGToPub w
		on w.pubGN = @pubGN and w.pubN = z.pubN
where 
	z.wineN = @wineN
	and (z.tasterN = @whN or z.isPrivate <> 1)
	and (@MustHaveReviewInThisPubG = 0 or w.pubGN is not null)
	and (@mustBeTrustedTaster = 0 or (y.whN is not null or x.whN is not null))
)
insert into @TT(wineN, ratingRange, cntTastingsInThisRange)
	select wineN,
	ratingRange, 
	COUNT(*) cntTastingsInThisRange
	from a 
	group by wineN, ratingRange order by ratingRange desc
 
return
end 
