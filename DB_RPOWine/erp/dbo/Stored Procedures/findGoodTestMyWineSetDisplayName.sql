-- Find existing whToWine where all are in the wine table / hack test utility [=]
CREATE proc findGoodTestMyWineSetDisplayName as begin set noCount on


/*
update d
			set d.comments = c.summary
	from wh d
		join 
			(select top 10 *
				from (select 
					convert(float, sum(hasT)) / count(*) percentT, convert(float,sum(hasB)) / count(*) percentB, sum(hasBT) / count(*) percentBT
					, convert(varchar, whN) + ': ' + convert(varchar, sum(hasB)) +'B  ' + convert(varchar, sum(hasT)) + 'T  /  ' + convert(varchar, count(*)) des
					, convert(varchar, sum(hasB)) +' wines with bottles, ' + convert(varchar, sum(hasT)) + ' wines with tastings' summary
					, sum(hasT) hasT, sum(hasB) hasB, sum(hasBT)  hasBT, count(*) cnt, whN
					from	(select 
								  case when tastingCount > 0 then 1 else 0 end hasT
								, case when bottleCount > 0 then 1 else 0 end hasB
								, case when bottleCount > 0 and tastingCount > 1 then 1 else 0 end hasBT
								, *
							 from whToWine 
							) a
					group by whN
					) b
				order by percentT desc
				) c
				on c.whN = d.whN
*/



/*
update e
	set 
		 e.tag = 'Has' + convert(varchar, wineRound)
		,e.displayName = 'Has ' + convert(varchar, wineRound) + ' MyWines'
	from 
		wh e
		join 
			(select * from
				(select a.whn, displayName, wineCnt, (100 * floor(wineCnt / 100)) wineRound, missingCnt
				, row_number() over (
								partition by
									convert(int, wineCnt / 1000)
									,case when wineCnt >=1000 then 11 else convert(int, wineCnt / 100) end
								order by wineCnt 
									) iRank
					from wh a
						join (select whN, sum(tastingCount) sumTasting, sum() sumBottle count(*) wineCnt from whToWine group by whN) b
							on a.whN = b.whN
						left join 
							(select whN, count(*) missingCnt
								from whToWine c
									where not exists (select wineN from wine where wineN = c.wineN)
								group by whN
								) d
									on a.whN = d.whN
					where isNull(missingCnt, 0) = 0
					) a
				where iRank = 1 and wineCnt > 100
				) f
			on e.whn = f.whn
	where
		isGroup=0 
		and isLocation=0 
		and isPub=0 
		and isProfessionalTaster=0 
		and isErpMember=0 
		and isRetailer=0 
		and isImporter=0 
		and isWinery=0 
		and isWineMaker=0 
		and isEditor=0 
		and isView=0

	order by wineCnt desc
*/


end
