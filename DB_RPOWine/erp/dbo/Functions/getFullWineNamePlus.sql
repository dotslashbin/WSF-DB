create function getFullWineNamePlus (@wineN int)
returns varchar(max)
as begin
return (Select  (b.producerShow+isnull ( (' '+b.labelName) , '') +isNull (' ('+isNull (colorClass+', ', '') +isNull (isNull (site, isNull (locale, isNull (location, isNull (region, isNull (country, '') ) ) ) ) , '') +') ', '') ) fullWineNamePlus
	from 
		wine a
		join wineName b
			on b.wineNameN = a.wineNameN
	 where wineN = @wineN     )
end
