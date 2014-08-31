CREATE proc xx(@whN int = null, @wineN int = null, @pubGN int,  @MustHaveReviewInThisPubG bit = 0, @mustBeTrustedTaster bit = 0)
as 
begin
 
select isPrivate,z.tasterN,z.pubN, *
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
	and (isNull(@MustHaveReviewInThisPubG,0) = 0 or w.pubGN is not null)
	and (isNull(@mustBeTrustedTaster,0) = 0 or (y.whN is not null or x.whN is not null))
end 

