--cover function to show simple menu appearance for myPopup [=]
-- temp demo function for larisa x [=] 
CREATE function showProgrammerViewOfMyPopup(@rawPopup varchar(2000)) 
returns varChar(2000)
as begin

declare @s varchar(2000)

set @s = @rawPopup
set @s = replace(@s, '<BR>', char(13) + char(10)+ '<BR>')
return @s

end
/*
print dbo.showProgrammerViewOfMyPopup(dbo.myPopup(1,2,3,4,5,6,1))
print dbo.showProgrammerViewOfMyPopup(dbo.myPopup(0,2,3,4,5,6,1))
*/
