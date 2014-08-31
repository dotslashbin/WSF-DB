-- formatting price utility           [=]
CREATE function formatPriceRelease(@priceLo money, @priceHi money, @releasePrice money) returns varchar(30)
as begin
	declare @s varchar(30)
	if @priceLo is null
		set @s = ''
	else begin
		set @s = '$' + convert(varChar,(convert(int,round(@priceLo, 0))))
		if @priceHi is not null and round(@priceHi, 0) > round(@PriceLo, 0)
			set @s = @s + '-$' + convert(varChar,(convert(int,round(@priceHi, 0))))
		end
 
	if @releasePrice is not null
		set @s = @s + ' ($' + convert(varChar,convert(int,round(@releasePrice,0))) + ')'
	
	return @s
end
 
