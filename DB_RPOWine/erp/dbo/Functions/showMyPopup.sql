-- test [=]
CREATE function showMyPopup (
	@bottleCount int, @wantToBuyCount int, @sellerCount int, @wantToSellCount int, @buyerCount int, @tastingCount int, @isOfInterest  bit
	)
returns varchar(2000)
 as begin
declare @s varchar(2000), @r varchar(4000)
 
set @s = erp.dbo.myPopup(@bottleCount, @wantToBuyCount, @sellerCount, @wantToSellCount, @buyerCount, @tastingCount, @isOfInterest )
set @s = char(13) + char(10) + @s + char(13) + char(10) 
set @r = '--------------------------------------------' + char(13) + char(10) 
set @r = @r + dbo.showPlainViewOfMyPopup(@s)  + char(13) + char(10) 
set @r = @r + '--------------------------------------------' + char(13) + char(10) 
 
set @r = @r + dbo.showProgrammerViewOfMyPopup(@s)  + char(13) + char(10) 
set @r = @r + '--------------------------------------------' + char(13) + char(10) 
 
set @r = @r + dbo.showHTMLViewOfMyPopup(@s)  + char(13) + char(10) 
set @r = @r + '--------------------------------------------' + char(13) + char(10) 
return @r
end
 
 
 
/*
exec dbo.showMyPopup dbo.myPopup(1,2,3,4,5,6,1)
print dbo.showMyPopup2 (0,2,3,4,5,6,1)
*/
 
 
