create proc [dbo].addToMyTrustedTasters(@whN int, @tasterN int)

as begin

set noCount on;
            begin
                       if not exists (select * from whToTrustedTaster where whN = @whN and tasterN = @tasterN)
                          
                             insert into whToTrustedTaster (whN, tasterN)  values ( @whN, @tasterN )
                             
                          end
                          
                         
                      
end
