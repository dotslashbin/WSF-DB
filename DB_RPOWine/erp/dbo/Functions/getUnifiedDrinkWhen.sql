create function getUnifiedDrinkWhen(@drinkDate datetime, @drinkDateHi datetime, @maturityN smallInt, @decantedN smallInt, @drinkWhenN smallInt)
returns smallInt
as begin
if (@drinkDate is not null or @drinkDateHi is not null) and @maturityN is not null
	return 100+@maturityN
else
	begin
		if @decantedN is not null and @drinkWhenN is not null
			return @drinkWhenN
	end
 
return 6
end
 
