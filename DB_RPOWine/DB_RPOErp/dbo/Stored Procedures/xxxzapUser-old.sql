-----------------------------------------------------------------------------------------------------------------------------------------------
-- zapUser     saveUser     restoreUser
CREATE proc [xxxzapUser-old](@whN int)
as begin
delete from tasting where tasterN = @whN;
delete from whToWine where whN = @whN;
delete from erpCellar..BottleLocation  where whN = @whN;
delete from erpCellar..Location where whN = @whN;
delete from erpCellar..Purchase where whN = @whN;
delete from erpCellar..Supplier where whN = @whN;
end

