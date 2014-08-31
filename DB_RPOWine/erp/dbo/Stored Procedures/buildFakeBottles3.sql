/*
oodef buildFakeBottles3
oodef buildFakeLocations3
*/
CREATE proc buildFakeBottles3(@whN int, @maxSuppliers int, @maxWines int, @maxPurchases int, @bottlesPerBin1 int, @bottlesPerBin2 int )
as begin
	set noCount on
 
	 delete from fakeLocation;
 
	 with
	a as 
	(select a.*
		from location a
			left join location b
				on a.locationN = b.parentLocationN
		where b.locationN is null and a.whN = @whN and isNull(b.isBottle,0) = 0 and isNull(a.isBottle,0) = 0
	)
	,b as (select row_number() over(order by name)ii, locationN, parentLocationN, name from a)
	insert into fakeLocation(ii, whN, locationN, name, maxBottleCount)
		select ii, @whN, locationN, name, case when parentLocationN % 2 = 0 then @bottlesPerBin1 else @bottlesPerBin2 end from b;
 
	update fakeLocation set currentBottleCount = 0, remainingBottleCount = maxBottleCount
 
--buildFakeBottles3 20, 30, 100, 100, 18, 48
 
	declare @wineN int, @supplierN int, @bottleCount int, @purchaseN int, @maxLocations int, @r int, @ii int, @x int, @locationN int, @prevItemIndex int
	select @maxLocations = count(*) from fakeLocation;	
	
	while (@maxPurchases>0)
		begin
			select @R = @maxPurchases * 9997
			select @wineN = wineN from fakeWine where ii = 1 + @r % @maxWines
			select @supplierN = supplierN from fakeSupplier where ii = 1 + @r % @maxSuppliers
			select @bottleCount = 1 + @r %24
			
 
			insert into purchase(whN, wineN, supplierN, bottleSizeN, pricePerBottle, bottleCount, purchaseDate, deliveryDate)
				select @whN, @wineN, @supplierN, 9, 10 + @r % 20, @bottleCount, getDate(), getDate()
			select @purchaseN = scope_identity()
 
			select top 1 @ii = ii from fakeLocation where remainingBottleCount >  (@bottleCount / 3)
			if @ii is null
				select top 1 @ii = ii from fakeLocation where remainingBottleCount >  0
			-------------------------------------------------------------------------------------------
			declare @iiStart int = @ii
			while (@bottleCount > 0)
				begin
					select @x = case when remainingBottleCount > @bottleCount then @bottleCount else remainingBottleCount end
							,@locationN = locationN
						from fakeLocation where ii = @ii
					
					if @x > 0 
						begin
							update fakeLocation set currentBottleCount += @x, remainingBottleCount -=@x where ii=@ii
							set @bottleCount -= @x
 
							select @prevItemIndex = max(locationN) from location where parentLocationN = @locationN
							if @prevItemIndex is null set @prevItemIndex = @locationN
							insert into location(isBottle, whN, parentLocationN, prevItemIndex,purchaseN,bottleCountHere, bottleCountAvailable, name)
								select 1, @whN, @locationN, @prevItemIndex, @purchaseN, @x, @x, ''
						end					
				
					set @ii = (@ii + 1) % @maxLocations
					if @ii = @iiStart 
						begin
							print 'out of bin space'
							break 
						end
				end				
			-------------------------------------------------------------------------------------------
			
			exec dbo.calcWhToWine @whN, @wineN, 1
			set @maxPurchases -= 1
			
			if @bottleCount > 0
				begin
					print convert(varchar, @maxPurchases) + ' remaining'
					break
				end
		end
 
	set noCount off
end
/*
use erp;
go
exec dbo.zapUser 20
exec dbo.buildFakeLocations3 20,-1,'',10,3;
buildFakeBottles3 20, 30, 100, 200, 18, 50
 
 
select count(*) from location where isBottle = 1 and whN=20
select count(*) from location where isBottle = 0 and whN=20

ooi ' bottleLocation ',''
	bottleLocationN
	whN
	locationN
	prevItemIndex
	purchaseN
	bottleCountHere
	bottleCountAvailable
	createDate
	updateDate

ooi ' location ',''


select * from location where isBottle=0 order by name
select * from location where isBottle=1 order by name

*/ 
 
 
 
 
