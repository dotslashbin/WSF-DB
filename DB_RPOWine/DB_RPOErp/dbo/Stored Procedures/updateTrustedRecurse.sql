-- explode pubG recurse recursion update xx [=]
CREATE proc updateTrustedRecurse as begin
 
declare @i int; set @i = 20
 
while @i > 0 begin
	insert into whToTrusted(whN, trustedN, isDerived)
	select a.whN, b.pubN, 1
		from whToTrusted a
			join pubGToPub b
				on a.trustedN = b.pubGN
		where not exists
			(select * from whToTrusted c
				where c.whN = a.whN
					and c.trustedN = b.pubN)
 

 
	if @@rowCount = 0 Break
 
	set @i = @i - 1
	end
end
----------------------------------------------------------------
/*

select a.whN, b.fullName, trustedN, c.fullName, isDerived
	from whToTrusted a
		join wh b on b.whN = a.whN
		join wh c on c.whN = a.trustedN

updateTrustedRecurse

oom 'to'





*/
----------------------------------------------------------------