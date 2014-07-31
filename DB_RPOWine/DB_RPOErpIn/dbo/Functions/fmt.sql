CREATE function fmt(@d as dateTime)
returns varchar(30)
as begin
return dbo.fmtd(@d) + '  ' + dbo.fmtt(@d)
end
