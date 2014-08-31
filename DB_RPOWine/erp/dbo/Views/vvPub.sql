--temporary view for update [=]
CREATE view vvPub as
select 
		 (b.fullName + '  (' + convert(varchar, a.pubGN) + ')') fullNameG
		,(c.fullName + '  (' + convert(varchar, a.pubN) + ')') fullName
		,a.isderived, a.pubGN, a.pubN
	from 
		pubGToPub a
		join wh b
			on a.pubGN = b.whN
		join wh c
			on a.pubN = c.whN
