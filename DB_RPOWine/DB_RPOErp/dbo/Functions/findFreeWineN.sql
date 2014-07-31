
CREATE function findFreeWineN(@vinn int, @vintageAsOffset int)     returns int
as begin
declare @newWineN int, @vinnTimes int = 1000, @vinnPlus int = 100000000, @loWineN int, @hiWineN int
set @loWineN=@vinn*@vinnTimes+@vinnPlus
set @hiWineN=@loWineN+@vinnTimes
set @newWineN=@loWineN+@vintageAsOffset
if exists (select * from wine where wineN = @newWineN)
	begin
		with
		a as		(
						select row_number() over(order by wineN desc)ii, * from wine where wineN between @loWineN and (@hiWineN-1)
					)
		,b as		(
						select ii, wineN, (@hiWineN-wineN) ii2  from a
					)
		select @newWineN=(@hiWineN-min(ii)) from b where ii<>ii2
	end
return @newWineN
end



