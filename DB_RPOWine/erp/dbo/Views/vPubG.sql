-- view of pubG expanded out to fullname / expanded pubG view[=]
CREATE view [vPubG] as
	select isnull(b.fullName, '') + ' (' + convert(varchar, a.pubGN) + ')' pubG, isnull(c.fullName, '') + ' (' + convert(varchar, a.pubN) + ')' Pub
		from pubGtoPub a
			join wh b on b.whN = a.pubGN
			join wh c on c.whN = a.pubN