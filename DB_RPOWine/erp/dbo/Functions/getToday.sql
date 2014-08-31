create function getToday() returns smalldatetime
as begin
	declare @now smalldatetime = getDate()
	return convert(smalldatetime, datename(yyyy, @now) + datename(mm, @now) + datename(dd, @now))
end
