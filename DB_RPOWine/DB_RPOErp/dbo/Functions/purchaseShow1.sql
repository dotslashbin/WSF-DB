CREATE function [dbo].[purchaseShow1](@supplier nvarchar(max), @purchaseDate nvarchar(max), @price nvarchar(max), @yearLo nvarchar(max), @yearHi nvarchar(max), @priceLo nvarchar(max), @priceHi nvarchar(max))
returns nvarchar(max)
as begin
declare @s nvarchar(max), @p nvarchar(max), @d nvarchar(max)
if @supplier is null and @purchaseDate is null and @price is null
	return null
 
if @supplier like '%[0-z]%'
	set @s=@supplier
else
	set @s='From?'
 
if 1=isNumeric(@price)
	set @p='$'+@price
else
	set @p='$?'
 
if 1=isdate(@purchaseDate)
	set @d= year(@purchaseDate)
else 
	set @d='date?'
set @d='('+@d+')'
 
/*if 1=isdate(@purchaseDate)
	set @d= '('+convert(nvarchar,year(@purchaseDate))+')'
else 
	set @d='(date)'
*/
if ((convert(float,@priceLo)*1.5)<convert(float,@priceHi))
	set @p='<b>'+@p+'</b>'
if @yearHi<>@yearLo
	set @d='<b>'+@d+'</b>'
	
set @s=@p+' '+@s+' '+@d
set @s=replace(@s,'<b>','<b><span style="color:Red">')
set @s=replace(@s,'</b>','</span></b>')
return @s
end
/*
*/
 
 
 
