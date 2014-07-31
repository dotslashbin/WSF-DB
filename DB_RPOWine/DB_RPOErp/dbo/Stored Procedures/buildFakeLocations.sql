 
CREATE proc buildFakeLocations(@whN int, @parent int, @prefix varchar(max), @maxWidth int, @maxDepth int)
as begin
	set noCount on
	declare @i int = 0, @locationN int, @prefix2 varChar(max), @maxDepth2 int
	if @maxDepth > 0
	begin
		set @locationN = @parent
		while(1=1)
		begin
			if @i >= @maxWidth break
			set @prefix2 = @prefix + char(97+ @i)
			insert into location(whN, parentLocationN, prevItemIndex, name) select @whN, @parent, @locationN, @prefix2
			set @locationN = scope_identity()
			if @maxDepth > 1 
				begin
					set @maxDepth2 = @maxDepth - 1
					exec dbo.buildFakeLocations @whN, @locationN, @prefix2, @maxWidth, @maxDepth2
				end
			else
				begin
					declare @wineN int, @supplierN int, @bottleCount int, @purchaseN int
					select @wineN = wineN from fakeWine where ii = 1 + @locationN % 7
					select @supplierN = supplierN from fakeSupplier where ii = 1 + @locationN % 5
					
					if @supplierN is null
					begin
						print @locationN
					end
					
					select @bottleCount = 1 + @locationN %24
					insert into purchase(whN, wineN, supplierN, bottleSizeN, pricePerBottle, bottleCount, purchaseDate, deliveryDate)
						select @whN, @wineN, @supplierN, 9, 10 + @locationN % 20, @bottleCount, getDate(), getDate()
					select @purchaseN = scope_identity()
	 
					insert into bottleLocation(whN, locationN, prevItemIndex,purchaseN,bottleCountHere, bottleCountAvailable)
						select @whN, @locationN, @locationN, @purchaseN, @bottleCount,@bottleCount
					exec dbo.calcWhToWine @whN, @wineN, 1
				end			
			
			set @i += 1
		end
	end
	set noCount off
end
 
 
