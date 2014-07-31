-- view of pubG expanded out to fullname / expanded pubG view[=]
CREATE proc [dbo].[oopubg] as begin
select *
	from 
		(select isnull(b.fullName, '') + ' (' + convert(varchar, a.pubGN) + ')' pubG, isnull(c.fullName, '') + ' (' + convert(varchar, a.pubN) + ')' Pub, isDerived
			from pubGtoPub a
				join wh b on b.whN = a.pubGN
				join wh c on c.whN = a.pubN
			) a
	order by pubG, pub, isDerived
end
