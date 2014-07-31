--coding utility to snapshot time intervals 		[=]
CREATE PROCEDURE Timer @Event varChar(100), @Finish bigInt = null as begin set noCount on
	if @Finish is null
		Insert Into dbo.times(Event, StartTime) select @Event, getDate()
	else
		update dbo.times set seconds = (select dateDiff(second, startTime, getDate()))
			where event = @event and startTime = (select max(startTime) from dbo.times where event = @Event)
 end