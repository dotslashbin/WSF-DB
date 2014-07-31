CREATE function fmtt(@d as dateTime)
returns varchar(30)
as begin
return '(' + right('000' + convert(varchar, datePart(hh, @d)), 2) + ':' + right('000' + convert(varchar, datePart(n, @d)), 2) + ')'
end
