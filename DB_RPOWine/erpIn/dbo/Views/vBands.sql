create view vBands as select
	case 
		when wineN < 0 then 'wineN < 0'
		when wineN = 0 then 'wineN = 0'
		when wineN < 1000000 then 'wineN < 1000000'
		when wineN >= 1000000 then 'wineN >= 1000000'
		when wineN is null then 'wineN is null'
		else 'else'
		end wineN
	, case 
		when activeVinn < 0 then 'activeVinn < 0'
		when activeVinn = 0 then 'activeVinn = 0'
		when activeVinn < 1000000 then 'activeVinn < 1000000'
		when activeVinn >= 1000000 then 'activeVinn >= 1000000'
		when activeVinn is null then 'activeVinn is null'
		else 'else'
		end activeVinn
	from wine
		
	
