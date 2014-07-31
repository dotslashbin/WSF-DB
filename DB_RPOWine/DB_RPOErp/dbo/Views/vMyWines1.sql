

CREATE view [dbo].[vMyWines1] as
	select memberid,fullName, cntWines, cntBottles, cntLocations, cntTastings, cntPrivateTastings, cntLabels, isProfessionalTaster
		from (select whN, isProfessionalTaster, memberid,username,fullName from wh where memberid>0     ) a
			left join (select tasterN whN, count(distinct wineN) cntWinesWithTastings, count(*) cntTastings, sum(case when isPrivate=0 then 0 else 1 end) cntPrivateTastings from tasting group by tasterN     ) b
				on a.whN=b.whN
			join (select whN, count(*)cntWines, sum(bottleCount)cntBottles from whtowine group by whN     ) c
				on a.whN=c.whN
			left join (select whN, count(*)cntLocations from location group by whN     ) d
				on a.whN=d.whN
			left join (select whN, count(*)cntLabels from customLabels group by whN     ) e
				on a.whN=e.whN

