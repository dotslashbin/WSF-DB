 CREATE function [dbo].[bottlesInLocation_after1001Jan11](@whN int, @location int) 
returns @TT table(vintage varChar(4), fullName varChar(500), bottleSummary varChar(100), bottleLocations varChar(2000))
as
begin
 
with
a as (select whN, parentLocationN, locationN, purchaseN, bottleCountHere, currentBottleCount, isBottle from location)
,p as	(select *
		from a 
		where a.whN = @whN and a.locationN = @location
	union all
	select pc.*
		from a pc
			join p pp
				on pc.parentLocationN = pp.locationN
	)
,e as	(select d.whN, d.wineN, d.bottleSizeN, sum(p.bottleCountHere) bottleCountHere
		from p
			join purchase d
				on d.whN = p.whN and d.purchaseN = p.purchaseN
		where p.isBottle = 1
		group by d.whN, d.wineN, d.bottleSizeN
)
,h as	(select e.bottleCountHere, shortName, litres, vintage, producer, producerShow, labelName, j.bottleLocations, j.bottleCount bottleCountThisWine
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
insert into @TT(vintage, fullName, bottleSummary, bottleLocations)
select	
	   convert(varchar, vintage) vintage
	, (producerShow + isNull(' ' + labelName, '')) fullName
	, convert(varchar, bottleCountHere) + case when isNull(shortName, '') = '' then '' else ' ' + shortName + case when bottleCountHere=1 then '' else 's' end		end
	, case when bottleCountThisWine > bottleCountHere then bottleLocations else '' end
	from h
	order by producer, labelName, litres, vintage
	
return
end
/*
 
select * from [[bottlesInLocation_after1001Jan11]](20, 27350)
select * from [bottlesInLocation_after1001Jan08](20, 27356)
 
select * from bottlesInLocation_after1001Jan08(20,27373)
 
27350
select * from location where whN=20
summarizeBottleLocations 20, null
 
ooi whtowine, coun 
*/
 
 
 
 
 
 
