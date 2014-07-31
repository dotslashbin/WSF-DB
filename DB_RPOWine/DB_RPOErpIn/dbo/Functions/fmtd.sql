create function fmtd(@d as dateTime)
returns varchar(30)
as begin
return right('000' + convert(varchar, datePart(yy, @d)), 2) + '.' + right('000' + convert(varchar, datePart(mm, @d)), 2) + '.' + right('000' + convert(varchar, datePart(dd, @d)), 2)
end
