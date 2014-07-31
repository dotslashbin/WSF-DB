CREATE function dbo.bottlesInLocation(@whN int, @location int) 
/*
select * from dbo.bottlesInLocation_dev(20,1696)
select * from dbo.bottlesInLocation_dev(20,1695)
select * from dbo.bottlesInLocation(20,1696)
*/
returns @TT table(vintage varChar(4), fullName varChar(500), bottleSummary varChar(100), bottleLocations varChar(2000))
as
begin
 
--declare @whN int=20, @location int=1696;
with
a as (select whN, parentLocationN, locationN, purchaseN, bottleCountAvailable, isBottle from location)
,p as	(select *
		from a 
		where a.whN = @whN and a.locationN = @location
	union all
	select pc.*
		from a pc
			join p pp
				on pc.parentLocationN = pp.locationN
	)
,e as	(select d.whN, d.wineN, d.bottleSizeN, sum(p.bottleCountAvailable) bottleCountAvailable
		from p
			join purchase d
				on d.whN = p.whN and d.purchaseN = p.purchaseN
		where p.isBottle = 1
		group by d.whN, d.wineN, d.bottleSizeN
)
/*
select * from purchase where purchaseN=9062
select * from purchase where whN=20 and wineN=29478
select * from location where purchaseN in (9062, 9063)
select * from p
select * from a 
select * from e
*/
,h as	(select e.bottleCountAvailable, shortName, litres, vintage, producer, producerShow, labelName, j.bottleLocations, j.bottleCount bottleCountThisWine
		from e
			join wine f
				on f.wineN = e.wineN
			join wineName g
				on g.wineNameN = f.wineNameN
			join bottleSize h
				on h.bottleSizeN = e.bottleSizeN
			join whToWine j
				on j.whN = e.whN and  j.wineN = e.wineN
)
/*
select * from h
*/
insert into @TT(vintage, fullName, bottleSummary, bottleLocations)
select	
	   convert(varchar, vintage) vintage
	, (producerShow + isNull(' ' + labelName, '')) fullName
	, convert(varchar, bottleCountAvailable) + case when isNull(shortName, '') = '' then '' else ' ' + shortName + case when bottleCountAvailable=1 then '' else 's' end		end
	--, case when bottleCountThisWine > bottleCountAvailable then bottleLocations else '' end
	, bottleLocations
	from h
	order by producer, labelName, litres, vintage
	
return
end
/*
select * from bottlesInLocation_after10Jan14(19,30171)
 
select * from bottlesInLocation_after10Jan14(20, 27350) 
 
select * from bottlesInLocation_after1001Jan11(20, 27350)
select * from bottlesInLocation_after1001Jan11(20, 27356)
select * from bottlesInLocation_after1001Jan11(20, 27373)
 
27350
select * from location where whN=20
summarizeBottleLocations 20, null
 
ooi whtowine, coun 
*/
 
 
 
 
 
 
 
 
 
