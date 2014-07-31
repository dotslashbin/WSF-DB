-- zapUser     saveUser     restoreUser
CREATE proc [dbo].[zapUser](@whN int)
as begin
/*
select * from bottleConsumed where whN=20
*/
set noCount on
delete from bottleConsumed where whN = @whN;
delete from tasting where tasterN = @whN;
delete from whToWine where whN = @whN;
delete from whToTrustedPub where whN=@whN
delete from whToTrustedTaster where whN=@whN
delete from Location where whN = @whN;
delete from Purchase where whN = @whN;
delete from Supplier where whN = @whN;
 
delete from importMap where whN = @whN;
set noCount off
end
 
