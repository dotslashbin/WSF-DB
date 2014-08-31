create proc fixDrinkWhenN as begin

update tasting
		set drinkWhenN=maturityN
	where
		drinkDate is null and drinkDateHi is null and decantedN is not null
		and drinkWhenN is null and maturityN is not null

end