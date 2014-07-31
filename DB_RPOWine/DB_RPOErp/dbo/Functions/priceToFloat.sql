
CREATE function priceToFloat(@price nvarchar(99))
returns float
as begin
	declare @f float
	
	if @price like '%$%' and @price not like '%$%$%' set @price = replace(@price, '$','')
	if @price like '%US$%' and @price not like '%US$%US$%' set @price = replace(@price, 'US$','')
	
	set @price=replace(replace(@price,'(',''),')','')
	set @price = ltrim(rtrim(@price))
 
	if @price=''
		return 0
	else
		begin
			if 1=dbo.isNumericOnly(@price)
				return convert(float, @Price)
		end
return null
end







