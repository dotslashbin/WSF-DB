create proc foo as begin
update whToWine 
	set bottleCount = 4
where whN = -2
end