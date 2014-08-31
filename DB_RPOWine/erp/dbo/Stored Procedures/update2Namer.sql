CREATE proc [dbo].update2Namer as begin
exec dbo.oolog 'update2Namer begin'; 
declare @namerWhN int=dbo.constWhMlb()
 
update a
		set namerWhN=@namerWhN 
--select count(*)
	from winename a
		join vewine b
			on a.joinx=b.joinx
	where
		a.namerWhN is null or a.namerWhN<>@namerWhN
 
 
update a
		set namerWhN=dbo.constWhJb()
--select count(*)
	from winename a
		join vjwine b
			on a.joinx=b.joinx
	where
		a.namerWhN is null or a.namerWhN not in(dbo.constWhMlb(),dbo.constWhJb())
 
/*
update a set namerwhn=b.whn
	from winename a 
		join wine d on a.winenamen=d.winenamen
		join whtowine b on d.winen=b.winen
		join cc c on d.winen=c.winen
	where a.namerwhn is null
 
*/ 
 
exec dbo.oolog 'update2Namer end'; 
end
