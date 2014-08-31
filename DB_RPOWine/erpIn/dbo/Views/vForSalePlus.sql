CREATE view vForSalePlus as 
	select c.bottlesperCase, c.litersperBottle
			, d.USDollars
			, ((price * USDollars) / (convert(float,bottlesperCase) * convert(float,litersperBottle)   )) dollarsPerLiter
			, a.*
		from vForSale a
			join erp..bottleSizes c
				on a.bottleSize = c.bottleSize
			join erp..currencyConversion d
				on a.Currency=d.alertCurrency
		where auction is null or auction not like '%[aA]%'
