-- show the whToTaster table [=]
create proc ootaster as begin
	select *
		from
			(select dbo.getName(whN) wh, dbo.getName(tasterN) taster
				from whToTaster
				) a
	order by wh, taster
		
	end
