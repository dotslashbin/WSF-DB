------------------------------------------------------------------------------------------------------------------------------
-- snapAndLoad 
------------------------------------------------------------------------------------------------------------------------------
CREATE proc snapAndLoad @fromWhN int, @toWhN int
as begin
	exec dbo.saveUser @fromWhN, 'Snap'
	exec dbo.loadFromSnap @fromWhN, @toWhN
end
       