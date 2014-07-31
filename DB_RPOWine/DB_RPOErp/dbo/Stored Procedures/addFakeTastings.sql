--delete from tasting where tastingN > 5191083
--delete from tasting where pubN = 20
CREATE proc addFakeTastings (@wineN int) 
as begin
 
 
declare @tasterN int, @rating int, @notes nvarchar(max)
declare @iLoop int = 20
 
begin try
drop table #w;
end try begin catch end catch
select top 20 99 ii, whN into #w from wh where whN > 100 and isPub = 0 and fullName is not null;
with
	a as (select *, ROW_NUMBER() over (order by whN) iRow from #w)
	update a set ii = iRow
	
while @iLoop > 0
	begin
	
	select @tasterN = whN, @rating = 101 - ii from #w where ii = @iLoop;
	select @notes = 'Fake note from user# ' + convert(nvarchar(max), @tasterN) + '     ' + dbo.getName(@tasterN) + '     Rating: ' + convert(nvarchar(max), @rating)
	
	insert into tasting	(wineN,vinN,wineNameN,pubN,pubDate,notes
	,tasterN,tasteDate,bottleSizeN,rating,ratingShow,drinkDate,drinkDateHi
	,drinkWhenN,maturityN,estimatedCostLo,estimatedCostHi,whereTastedN,isAvailabeToTastersGroups,isAnnonymous,isPrivate,createDate,createWh,decantedN)
	select top 1 wineN,vinN,wineNameN,20 pubN,pubDate,@notes notes,@tasterN tasterN,tasteDate,bottleSizeN,@rating rating,@rating ratingShow,drinkDate,drinkDateHi,drinkWhenN,maturityN,estimatedCostLo,estimatedCostHi,whereTastedN,isAvailabeToTastersGroups,isAnnonymous,isPrivate,createDate,createWh,decantedN
		from tasting where wineN = 8	
 
	set @iLoop -= 1
	end
	
end
 
--addFakeTastings 8
--select * from tasting where pubN = 20
 
