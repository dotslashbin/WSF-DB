CREATE function bottlesInLocation_before09Dec15(@location int) 
returns @TT table(fullName varChar(500), bottleSummary varChar(100))
as
begin
 
with
a as (select parentLocationN, locationN, purchaseN, bottleCountHere, isBottle from location)
,p as	(select *
		from a 
		where a.locationN = @location
	union all
	select pc.*
		from a pc
			join p pp
				on pc.parentLocationN = pp.locationN
	)
,e as	(select d.wineN, d.bottleSizeN, sum(p.bottleCountHere) bottleCount
		from p
			join purchase d
				on d.purchaseN = p.purchaseN
		where p.isBottle = 1
		group by d.wineN, d.bottleSizeN
)
,h as	(select bottleCount, shortName, litres, vintage, producer, producerShow, labelName 
		from e
			join wine f
				on f.wineN = e.wineN
			join wineName g
				on g.wineNameN = f.wineNameN
			join bottleSize h
				on h.bottleSizeN = e.bottleSizeN
)
insert into @TT(fullName, bottleSummary)
select	
	  (convert(varchar, vintage) + ' ' + producerShow + isNull(' ' + labelName, '')) fullName
	, convert(varchar, bottleCount) + case when isNull(shortName, '') = '' then '' else ' ' + shortName + case when bottleCount=1 then '' else 's' end		end
	from h
	order by producer, labelName, litres, vintage
	
return
end
/*
select * from bottlesInLocation(27356)
 
select * from bottlesInLocation(27373)
 
*/
 
 
