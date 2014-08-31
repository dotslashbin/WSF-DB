

create proc xxx 
as begin

declare @11 varchar(max)
set @11 = 'old'
print @11
exec dbo.xx @11
print @11

end