CREATE function isErpPub(@pubN int)
returns bit with schemabinding 
as begin
	return (case when @pubN in (1,2,3,4,5,8,9,19909) then 1 else 0 end)
end
 
 
