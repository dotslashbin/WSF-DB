CREATE function isErpPro(@tasterN int)
returns bit with schemabinding 
as begin
	return (case when @tasterN in (10,11,12,13,14,15,16,17,18283) then 1 else 0 end)
end
 
 
 
