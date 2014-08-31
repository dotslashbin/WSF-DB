CREATE proc [dbo].recalculateAllForWhN(@whN int)
as begin
set noCount on;

exec dbo.calcWhToWine @whN, 1
exec dbo.summarizeBottleLocations @whN, null;
exec dbo.summarizeBottleValuation @whN, null, null

end
