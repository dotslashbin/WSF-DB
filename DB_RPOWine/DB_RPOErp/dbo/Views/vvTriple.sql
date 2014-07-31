--temporary view for update [=]
create view vvTriple as
	select masterG, splitG, b.fullName thisG, masterGN, splitGN, b.pubN thisGN
		from vvMaster a
			join vvpub b
				on a.splitGN = b.pubGN
