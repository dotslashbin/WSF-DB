-- icons utility [=]
CREATE  procedure ooicons 
as begin 
	select * from icon order by displayName, tag
end
