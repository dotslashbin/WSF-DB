﻿ 
CREATE proc [dbo].[updateBottleCount_before10Jan04b] (@whN int = -1) as
begin
	set noCount on
	declare @loops int = 20
	if @whN is null
		begin
			update location set currentBottleCount = 0;
			while @loops > 0
				begin
					with
					a as (select parentLocationN, sum(isNull(bottleCountHere, 0) + isNull(currentBottleCount, 0)) bottleCountInLocation from location group by parentLocationN)
					update b set currentBottleCount = a.bottleCountInLocation
						from location b
							join a
								on b.locationN = a.parentLocationN
						where isNull(b.currentBottleCount, 0) <> isNull(a.bottleCountInLocation, 0)
				
					if @@rowCount = 0 break
					set @loops -= 1
				end			
		end
	else
		begin
			update location set currentBottleCount = 0 where whN=@whN ;
			while @loops > 0
				begin
					with
					a as (select parentLocationN, sum(isNull(bottleCountHere, 0) + isNull(currentBottleCount, 0)) bottleCountInLocation from location where whN=@whN group by parentLocationN)
					update b set currentBottleCount = a.bottleCountInLocation
						from location b
							join a
								on b.locationN = a.parentLocationN
						where b.whN = @whN and isNull(b.currentBottleCount, 0) <> isNull(a.bottleCountInLocation, 0)
				
					if @@rowCount = 0 break
					set @loops -= 1
				end			
			exec dbo.updateHasMany @whN
		end
end
/*
select * from location where whN=19 order by parentLocationN, locationN
 
select * from location where whN=19  and isBottle = 1order by parentLocationN, locationN
*/
 
 
 
 
