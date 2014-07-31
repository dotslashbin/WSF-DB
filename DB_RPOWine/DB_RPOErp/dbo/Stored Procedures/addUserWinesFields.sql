CREATE proc [dbo].addUserWinesFields (@tb nvarchar(50), @extraAction nvarchar(max))
 
as begin
 
begin try	
	exec
		('update vUserWines  
			set 
				hasErpTasting=isNull(hasErpTasting,0), presentBeforeThisCycle=isNull(presentBeforeThisCycle,0), twoErpMatches=isNull(twoErpMatches,0), 
				setByUser=isNull(setByUser,0), fromSameVintage=isNull(fromSameVintage,0), fromOtherVintage=isNull(fromOtherVintage,0)'
		)
end try
begin catch	
	begin try exec (@extraAction) end try begin catch end catch
	exec dbo.addField @tb, 'hasErpTasting  bit null'
	exec dbo.addField @tb, 'presentBeforeThisCycle  bit null'
	exec dbo.addField @tb, 'twoErpMatches bit null' 
	exec dbo.addField @tb, 'setByUser bit null' 
	exec dbo.addField @tb, 'fromSameVintage bit null' 
	exec dbo.addField @tb, 'fromOtherVintage bit null' 
 
	exec
		('update vUserWines  
			set 
				hasErpTasting=isNull(hasErpTasting,0),  presentBeforeThisCycle=isNull(presentBeforeThisCycle,0), twoErpMatches=isNull(twoErpMatches,0), 
				setByUser=isNull(setByUser,0), fromSameVintage=isNull(fromSameVintage,0), fromOtherVintage=isNull(fromOtherVintage,0)'
		)
 
end catch
end
 
 
 

