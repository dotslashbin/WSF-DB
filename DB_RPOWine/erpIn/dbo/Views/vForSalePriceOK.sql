create view vForSalePriceOK as
	select * from vForSale
	where
		errors is null 
			or (     (     errors like '%[[E47]%' or errors like '%[[E48]%' or errors like '%[[E49]%'     )
					and
					OveridePriceException is not null     )
