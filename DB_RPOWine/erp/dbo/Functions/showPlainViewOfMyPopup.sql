--cover function to show simple menu appearance for myPopup [=]
CREATE function showPlainViewOfMyPopup(@rawPopup varchar(2000)) 
returns varChar(2000)
as begin

declare @s varchar(2000)

--set @s = replace(@s, '<ED>', '<i><small> (edit)</small></i>')
set @s = @rawPopup
set @s = replace(@s, '<ED>', ' (edit)')
 
set @s = replace(@s, '<IN>', '     ')
set @s = replace(@s, '<BR>', char(13) + char(10))
set @s = replace(@s, '</A>', '')
 
set @s = replace(@s,'<a1>','')
set @s = replace(@s,'<a2>','')
set @s = replace(@s,'<a3>','')
set @s = replace(@s,'<a4>','')
set @s = replace(@s,'<a5>','')
set @s = replace(@s,'<a6>','')
set @s = replace(@s,'<a7>','')
set @s = replace(@s, '<a8>','')
set @s = replace(@s, '<a9>','')
set @s = replace(@s, '<a10>','')
set @s = replace(@s, '<a11>','')
set @s = replace(@s, '<a12>','')
set @s = replace(@s, '<a13>','')

set @s = replace(@s, '</a>','')
	
return @s

end
/*
print dbo.showPlainViewOfMyPopup(dbo.myPopup(1,2,3,4,5,6,1))
*/
