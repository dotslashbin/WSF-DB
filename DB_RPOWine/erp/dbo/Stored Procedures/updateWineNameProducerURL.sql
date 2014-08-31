-- database producerURL update		[=]
CREATE procedure updateWineNameProducerURL as begin
 
set noCount on
  
exec snapRowVersion erp;
 
update a set a.producerUrlN = b.idN
	from wineName a
		join producerURL b 
			on b.producer 
			= a.producer
	where 
		(a.producerUrlN is null and b.idN is not null)
		 or (a.producerUrlN is null and b.idN is not null) 
		or (a.producerUrlN <> b.idN)
 
end
 
 
