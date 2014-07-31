





CREATE proc [dbo].[autosetMW](@whN int, @wineN int, @IsOfInterest int, @HasMyNotes int,@InMyCellar int,@WantToTry int, @WantToBuy int,@WantToSell int)

as begin

set noCount on;
            begin
                       if not exists (select * from whToWine where whN = @whN and wineN = @wineN)
                          
                             insert into whToWine (whN, wineN)  values ( @whN, @wineN )
                             
                          end
                          
       
         update whToWine set 
         hasBottles=@InMyCellar,
         tastingCount=@HasMyNotes,
         WantToTry=@WantToTry, 
         IsOfInterest=@IsOfInterest,
         wantToSellBottleCount=@WantToSell,
         wantToBuyBottleCount=@WantToBuy
         
         
         where wineN=@wineN and whn=@whn
          
    exec calcWhToWine @whn,@wineN                     
                      
end

 







