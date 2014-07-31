-- explode pubG recurse recursion update [=]
CREATE proc updatePubGRecurse as begin
 
declare @i int; set @i = 20
 
while @i > 0 begin
	insert into pubGToPub(pubGN, pubN, isDerived)
	select a.pubGN, b.pubN, 1
		from pubGToPub a
			join pubGToPub b
				on a.pubN = b.pubGN
		where 
			not exists
				(select * from pubGtoPub c
					where c.pubGN = a.pubGN
						and c.pubN = b.pubN)
		group by a.pubGN, b.pubN
 
	if @@rowCount = 0 Break
 
	set @i = @i - 1
	end
 
insert into pubGToPub(pubGN, pubN, isDerived)
	select pubN, pubN, 1
		from 
			(select pubN
				from pubGToPub
				group by pubN
				) a
	where not exists
		(select 1 from pubGToPub b
			where b.pubGN = a.pubN
			)

delete from pubGToPub
	where
		pubGN = pubN
		and exists
			(select 1 from pubGToPub b
				where b.pubGN <> b.pubN
					and b.pubGN = pubGToPub.pubN
				)
 
end
 
 
