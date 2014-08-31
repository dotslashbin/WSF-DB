
CREATE view [dbo].[vMyWines2] as
select memberid,fullName, cntWines, cntBottles, cntLocations, cntTastings, cntPrivateTastings, cntLabels, isProfessionalTaster,interest,buyShow,sellShow,tryShow,InMyCellar
		from (select whN, isProfessionalTaster, memberid,username,fullName from wh where memberid>0     ) a
			left join (select tasterN whN, count(distinct wineN) cntWinesWithTastings, count(*) cntTastings, sum(case when isPrivate=0 then 0 else 1 end) cntPrivateTastings from tasting group by tasterN     ) b
				on a.whN=b.whN
			join (select whN, count(*)cntWines, sum(bottleCount)cntBottles from whtowine group by whN     ) c
				on a.whN=c.whN
			left join (select whN, count(*)cntLocations from location group by whN     ) d
				on a.whN=d.whN
			left join (select whN, count(*)cntLabels from customLabels group by whN     ) e
				on a.whN=e.whN
            left join (select  whN, count(IsOfInterest) interest  from whtowine  where COALESCE(IsOfInterest,'0')=1 and COALESCE(hasBottlesShow,'0')=0 group by whN     ) i		  
            on a.whN=i.whN	
			left join (select  whN, count(wantToBuyShow) buyShow  from whtowine  where COALESCE(wantToBuyShow,'0')=1 group by whN     ) f		  
			 on a.whN=f.whN		
			left join (select  whN, count(wantToSellShow) sellShow  from whtowine  where COALESCE(wantToSellShow,'0')=1 group by whN     ) g		  
			 on a.whN=g.whN		
            left join (select  whN, count(wantToTryShow) tryShow  from whtowine  where COALESCE(wantToTryShow,'0')=1 group by whN     ) h		  
			 on a.whN=h.whN	
				
			 left join (select  whN, count(hasBottlesShow) InMyCellar  from whtowine  where (COALESCE(bottleCount,'0') =0 and COALESCE(hasBottlesShow,'0')=1) group by whN     ) k		  
			 on a.whN=k.whN		
