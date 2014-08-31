/*
select dbo.formatPrice_after1003Mar06(123, 45, null, null)
select dbo.formatPrice_after1003Mar06(null, 45, null, null)
select dbo.formatPrice_after1003Mar06(123456789, 45, null, null)
select dbo.formatPrice_after1003Mar06(123, 45, 456, null)
select *from price where wineN=26404

select dbo.formatPrice_after1003Mar06(mostRecentPriceLo, 45, mostRecentPriceHi, null)
	from price where includesNotForSaleNow = 1 and includesAuction = 0 and wineN=26404
ooi price
mostRecentPriceLo
mostRecentPriceHi
*/

-- formatting price utility          [=]
CREATE function [dbo].[formatPrice](@priceLo money, @releasePriceLo money, @priceHi money, @releasePriceHi money) returns varchar(30)
--alter function [dbo].[formatPrice_after1003Mar06](@priceLo money, @releasePriceLo money, @priceHi money, @releasePriceHi money) returns varchar(30)
as begin
	declare @s varchar(30)
 
	if @priceLo is null
		if @releasePriceLo is null set @s = '' else set @s = '(' + convert(varChar, convert(int, round(@releasePriceLo,0))) + ')'
	else 
		begin
			set @s = convert(varChar,(convert(int,round(@priceLo, 0))))
			if @priceHi is not null and round(@priceHi, 0) > round(@PriceLo, 0)
				set @s = @s + '-' + convert(varChar,(convert(int,round(@priceHi, 0))))
			if len(@s) > 7 and @priceHi is not null
				set @s = convert(varChar,(convert(int,round((@priceLo+@priceHi) / 2, 0)))) + '+'
		end
 
	return @s
end
 
 
