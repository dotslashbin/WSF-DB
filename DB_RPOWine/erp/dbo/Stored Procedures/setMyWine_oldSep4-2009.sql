-- toggle MyWines on and off for an individual wine allowing for hasBottles and hasTastings / database myWines toggle [=]
CREATE proc [dbo].[setMyWine_oldSep4-2009] @whN int, @wineN int, @on bit = null, @bottleCntNeeded bit = 1, @tastingCntNeeded bit = 1
as begin
 
/*
@on is null		compute isOfInterest from bottleCount and tastingCount
@on = 1			force isOfInterest On
@on = 0			turn of isOfInterest unless there are bottles or tastings
 
@bottleCntNeeded = 0		Calling routine is sure that bottleCounts have not been altered in current situation
 
@tastingCntNeeded = 0	Calling routine is sure that tasting Counts have not been altered in current situation
*/
 
declare @wineN2 int = null, @hasHadStuff bit = null, @bottleCount int = 0, @tastingCount int = 0, @hasPurchases bit = 0, @hasStuff bit = 0, @isOfInterest bit = 0;
 
select top 1 @wineN2 = wineN, 
	@hasHadStuff = isNull(hasHadStuff,1),
	@isOfInterest = isNull(isOfInterest,1), 
	@bottleCount = isnull(abs(bottleCount), 0),
	@tastingCount = isnull(abs(tastingCount), 0)
	from whToWine 
		where whN = @whN and @wineN = wineN
 
if  @bottleCntNeeded  = 1 
	begin
		if exists (select top 1 *  from erpCellar..purchase where whN = @whN and wineN = @wineN)
			set @hasPurchases = 1
		else
			set @hasPurchases = 0
 
		select @bottleCount = isNull(sum(bottleCount), 0)
			from erpCellar..purchase where whN = @whN and wineN = @wineN and bottleCount > 0;
			
		select @bottleCount +=  isNull(sum(bottleCountHere), 0)
			from erpCellar..purchase a
				join erpCellar..bottleLocation b
					on a.purchaseN = b.purchaseN
			where a.whN = @whN and a.wineN = @wineN and bottleCountHere > 0
	end
 
if @tastingCntNeeded = 1 
	begin
		set @tastingCount = 0;
		select @tastingCount =  count(*) from tasting where tasterN = @whN and wineN = @wineN
	end
 
if @tastingCount > 1 or @bottleCount > 1 or @hasPurchases =1 or (@hasHadStuff = 1 and @isOfInterest = 1)
	set @hasStuff = 1
 
if @on is null 
	begin
		if @hasStuff = 1
			begin
				if @wineN2 is null 
						insert into whToWine(whN, wineN, bottleCount, tastingCount, hasHadStuff, isOfInterest)
							select @whN, @wineN, @bottleCount, @tastingCount, @hasStuff, 1
				else 
						update whToWine set bottleCount = @bottleCount, tastingCount = @tastingCount, hasHadStuff = @hasStuff, isOfInterest = 1
							where whN = @whN and wineN = @wineN
			end
		else 
			begin
				if @wineN2 is not null
					update whToWine set bottleCount = 0, tastingCount = 0, @hasHadStuff = 0
						where whN = @whN and wineN = @wineN
			end
	end
else 
	if @on = 1 
		begin
				if @wineN2 is null
					insert into whToWIne(whN, wineN, bottleCount, tastingCount, hasHadStuff, isOfInterest) 
						select @whN, @wineN, @bottleCount, @tastingCount, 0, 1
				else 
					update whToWine set bottleCount = @bottleCount, tastingCount = @tastingCount, hasHadStuff = 0, isOfInterest = 1
						where whN = @whN and wineN = @wineN
		end
	else 
		begin
			if @wineN2 is not null 
				begin
					if @tastingCount > 0 or @bottleCount > 0 or @hasPurchases  = 1
						update whToWine set bottleCount = @bottleCount, tastingCount = @tastingCount, hasHadStuff = 1, isOfInterest = 1
							where whN = @whN and wineN = @wineN
					else
						update whToWine set bottleCount = 0, tastingCount = 0, hasHadStuff = 0, isOfInterest = 0 
							where whN = @whN and wineN = @wineN
				end
		end
end 
 
 
 
