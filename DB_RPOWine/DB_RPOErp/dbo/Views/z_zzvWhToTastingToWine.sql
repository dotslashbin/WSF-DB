create view [z_zzvWhToTastingToWine] as 
select a, wineN b 
	from mapWhToTasting z 
		join tasting y 
			on z.b = y.tastingN 
	group by z.a, y.wineN 