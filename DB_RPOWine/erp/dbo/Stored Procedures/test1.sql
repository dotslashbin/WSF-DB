CREATE proc test1 (@whN int, @wineN int) as
begin
 
set noCount on 
-----------------------------------------------------------------------------------
-- Code
-----------------------------------------------------------------------------------
/*
summarizeBottleLocations 20, null
summarizeBottleLocations 22, null
summarizeBottleLocations 19, null
 
declare @whn int = 20, @wineN int = 84552
 
select wineN, bottleLocations from whToWine where whN=20 and bottleLocations is not null
*/ 
 
 
 
declare @s varchar(max)
declare @TT table(locationN int, parentLocationN int, prevItemIndex int,name varchar(200), isBottle bit, path varchar(2000), rooted bit, iiPrev int, iiParent int, iiPath varchar(300), depth int, ii int)
 
-----------------------------------------------------------------------------------
-- Get all locations that need numbering
-----------------------------------------------------------------------------------
insert into @TT(locationN, parentLocationN, prevItemIndex, name, isBottle, path, rooted, iiPrev, iiParent, iiPath, depth, ii)
select locationN, parentLocationN,prevItemIndex,name, isBottle,  convert(varchar(max), '') path, convert(bit,0) rooted, -1 iiPrev, -1 iiParent, convert(varchar(max), '')iiPath, 0 depth, 0 ii
	from location
	where whN = @whN and isBottle=0;
	
update a
	set a.rooted = 1
	from @TT a
		join @TT b
			on a.prevItemIndex = b.locationN;
 
with
a as	(select locationN, prevItemIndex, isBottle, rooted, 0 iiPrev
		from @TT
		where rooted = 0
	union all
	select c.locationN, c.prevItemIndex, c.isBottle, c.rooted, p.iiPrev + 1
		from @TT c
			join a p
				on p.locationN = case when c.prevItemIndex < 0 then c.parentLocationN else c.prevItemIndex end 
				--on c.prevItemIndex = p.locationN
	)
update b 
	set b.iiPrev = a.iiPrev
	from @TT b
		join a
			on b.locationN = a.locationN;
			
with 
a as (select row_number() over(partition by parentLocationN order by isBottle desc, iiPrev) ii2, iiParent from @TT)
update a
	set iiParent = ii2;
	
	
-----------------------------------------------------------------------------------
-- Get the path name for all locations with bottles of current wines
-----------------------------------------------------------------------------------
 
declare @padLen int
select @padLen = len(convert(varchar(max), max(iiParent))) from @TT
declare @pad varchar(max) = left('0000000', @padLen - 1);
 
with
a as	(select parentLocationN, locationN, name, convert(varchar(max), isNull(name, '')) path2,	right(@pad + convert(varchar(max), isNull(iiParent, '')),@padLen)iiPath2, 0 depth2
		from @TT
		where parentLocationN < 0
	union all
	--select pc.parentLocationN, pc.locationN, pc.name, pp.path2 + convert(varchar(max), ' ' + pc.name), pp.iiPath2 + right(@pad + convert(varchar(max), isNull(pc.iiParent, '')),@padLen), 1+pp.depth2
	select pc.parentLocationN, pc.locationN, pc.name, pp.path2 + convert(varchar(max), char(11) + pc.name), pp.iiPath2 + right(@pad + convert(varchar(max), isNull(pc.iiParent, '')),@padLen), 1+pp.depth2
		from @TT pc
			join a pp
				on pc.parentLocationN = pp.locationN
	)
update b set b.path = a.path2, b.iiPath = a.iiPath2, b.depth = a.depth2
	from @TT b
		join a
			on a.locationN = b.locationN;
			
 
-----------------------------------------------------------------------------------
-- Update the sequence field ii
-----------------------------------------------------------------------------------
with
a as (select row_number() over(order by iiPath) ii2, * from @TT)
update a set ii = ii2;
	
 
-----------------------------------------------------------------------------------
-- Gather up the bottle sizes for a particular wineN
-----------------------------------------------------------------------------------
with
g as (select top 199999 b.wineN, d.nameInSummary, d.litres, e.bottleCountHere bottleCount, f.path, f.iiPath, f.depth, f.ii
	from (select * from purchase where whN = @whN) a
		join wine b
			on a.wineN = b.wineN
		join bottleSize d
			on a.bottleSizeN = d.bottleSizeN
		join location e
			on e.whN = a.whN and e.purchaseN = a.purchaseN
		join @TT f
			on f.locationN = e.parentLocationN
	where e.whN = @whN and (@wineN is null  or a.wineN = @wineN)
	order by wineN, litres desc, ii)
,h as (select top 199999 wineN, litres, max(nameInSummary) nameInSummary, dbo.concatFF(convert(varchar, ii)+char(12)+path) concat
	from g
	group by wineN, litres
	order by wineN, litres
	)
select top 1 @s  = concat from h
print(@s)

end
 
/*
test1 20, 59866

*/ 
 
 
 
 
 
 
 
