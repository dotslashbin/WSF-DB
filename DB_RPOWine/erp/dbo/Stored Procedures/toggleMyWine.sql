-- toggle MyWines on and off for an individual wine allowing for hasBottles and hasTastings / database myWines toggle [=]
CREATE proc toggleMyWine @whN int, @wineN int, @on bit = 1 
as begin
/*
	-- @on=1 =>	Creates a whToWine record if not already there.  If there, makes sure that the isDerived bit is off
	-- @on=0 =>	Deletes whToWine record if both bottleCount and tastingCount are 0.  If they are non-zero, the record stays 
						and we make sure that the isDerived bit is on.  That way the record will get deleted if both bottleCount and tastingCount become zero
*/
 
declare @wineN2 int, @isDerived bit, @hasStuff bit
 
select top 1 @wineN2 = wineN, @isDerived = isNull(isDerived,1), @hasStuff = isnull(abs(bottleCount), 0) + isnull(abs(tastingCount), 0) from whToWine where whN = @whN and @wineN = wineN
if @on = 1 begin
		if @wineN2 is null begin
				insert into whToWIne(whN, wineN, isDerived) select @whN, @wineN, 0
			end
		if @wineN2 is not null and @isDerived = 1 begin
				update whToWine set isDerived = 0 where whN = @whN and wineN = @wineN
				end
		end
else begin
		if @wineN2 is not null begin
				if @isDerived = 0 begin
						if @hasStuff = 0 begin
								delete from whToWine  where whN = @whN and wineN = @wineN
								end
						else begin
								update whToWine set isDerived = 1 where whN = @whN and wineN = @wineN
								end
						end
				end
		end
end
 
