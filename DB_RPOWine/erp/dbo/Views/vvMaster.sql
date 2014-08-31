--temporary view for update [=]
CREATE view vvMaster as
select fullNameG masterG, fullName splitG, isDerived, pubGN masterGN, pubN splitGN
	from vvPub a
	where isDerived = 0
		and not exists
			(select * from pubGToPub where pubN = a.pubGN)
