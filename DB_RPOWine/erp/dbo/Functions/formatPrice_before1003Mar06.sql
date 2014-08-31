-- formatting price utility          [=]
CREATE function [dbo].[formatPrice_before1003Mar06](@priceLo money, @releasePriceLo money, @priceHi money, @releasePriceHi money) returns varchar(30)
as begin
	declare @s varchar(30)
 
	if @priceLo is null select @priceLo = @releasePriceLo, @priceHi = @releasePriceHi
 
	if @priceLo is null
		set @s = ''
	else begin
		set @s = convert(varChar,(convert(int,round(@priceLo, 0))))
		if @priceHi is not null and round(@priceHi, 0) > round(@PriceLo, 0)
			set @s = @s + '-' + convert(varChar,(convert(int,round(@priceHi, 0))))
		end
	if len(@s) > 7 set @s = convert(varChar,(convert(int,round(@priceLo, 0)))) + '+'
 
	return @s
end
 
 
