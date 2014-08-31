------------------------------------------------------------------------------------------------------------------------------
-- view vMyWinesUsage
------------------------------------------------------------------------------------------------------------------------------
CREATE view vMyWinesUsage as
with
a as (select whN, count(*) cntLocation from location group by whN)
,b as (select whN, count(*) cntPurchase from purchase group by whN)
,c as (select whN, count(*) cntMyWine from whToWine group by whN)
,d as (select tasterN whN, count(*) cntTasting from tasting group by tasterN)
,e as (select whN, count(*) cntLocationsWithBottles from location where bottleCountHere > 0 group by whN)
,f as (select whN, case when count(*) > 0 then 1 else 0 end hasSnap from savedTables..whToWine where saveName like '%[0-Z]%' group by whN having count(*)>0)
--select * from f
select g.whN, fullName,cntMyWine,cntPurchase,cntTasting,cntLocation,cntLocationsWithBottles ,hasSnap
	from wh g
		left join a on a.whN=g.whN
		left join b on b.whN=g.whN
		left join c on c.whN=g.whN
		left join d on d.whN=g.whN
		left join e on e.whN=g.whN
		left join f on f.whN=g.whN
	where cntPurchase>0 or cntMyWine>0 or cntTasting>0 or cntLocation>0 or hasSnap>0

