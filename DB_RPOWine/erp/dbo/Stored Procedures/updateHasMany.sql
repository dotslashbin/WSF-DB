create proc updateHasMany (@whN int)
as begin
set noCount on
declare @i int, @maxLoops int = 30;
declare @T table (name varchar(200), locationN int, parentLocationN int, wineN int, hasMany bit);

with
a as (select parentLocationN, wineN, row_number() over (partition by parentLocationN order by wineN) ii
	from location b
		join purchase c
			on b.purchaseN = c.purchaseN
	where b.whN = @whN
	group by parentLocationN, wineN
)
,b as (select * from a where ii = 1)
,c as (select parentLocationN, ii from a where ii = 2)
,d as (select b.parentLocationN, b.wineN, c.ii ii2
	from b
		left join c
			on b.parentLocationN = c.parentLocationN
)
insert into @T(name, locationN, parentLocationN, wineN, hasMany)
	select e.name, e.locationN, e.parentLocationN, d.wineN, case when d.ii2 = 2 then 1 else 0 end hasMany
	from location e
		left join d
			on d.parentLocationN = e.locationN
	where e.whN = @whN and isBottle = 0
	order by locationN

set @i = 0
while @i < @maxLoops 
	begin
		update a set a.wineN = b.wineN
			from @T a
				join @T b
					on a.locationN = b.parentLocationN
			where a.wineN is null and b.wineN is not null	
		if @@rowCount = 0 break
		set @i += 1
	end;

set @i = 0
while @i < @maxLoops 
	begin
		update a set a.hasMany = 1
		from @T a
			join @T b
				on a.locationN = b.parentLocationN
		where a.hasMany = 0 
			and (a.wineN <> b.wineN or b.hasMany = 1)

		if @@rowCount = 0 break
		set @i += 1
	end;

update a set a.hasManyWines = b.hasMany
	from location a
		join @T b
			on a.locationN = b.locationN
	where whN = @whN
		and b.hasMany <> a.hasManyWines


--select * from location where hasManyWines = 1
end
/*
updateHasMany 20
*/