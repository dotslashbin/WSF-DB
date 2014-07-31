CREATE proc [dbo].[checkWhToWineRecord](@whN int, @wineN int)

as begin

set noCount on;
            begin
                       if not exists (select * from whToWine where whN = @whN and wineN = @wineN)
                          
                             insert into whToWine (whN, wineN)  values ( @whN, @wineN )
                             
                          end
                      
end

 

